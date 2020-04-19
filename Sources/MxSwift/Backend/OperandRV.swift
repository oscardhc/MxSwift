//
//  InstRV.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/4/8.
//

import Foundation

class Assmebly {
    var functions = List<FunctionRV>()
    var globals = List<GlobalRV>()
}

protocol OperandConvertable {
    var getOP: OperandRV {get}
}

extension Int: OperandConvertable {
    var getOP: OperandRV {Imm(self)}
}

class OperandRV: CustomStringConvertible, OperandConvertable {
    var description: String {"?"}
    var getOP: OperandRV {self}
    var getReg: Register? {self as? Register}
}

class InstRV: CustomStringConvertible, OperandConvertable, Hashable {
    
    enum OP {
        case lui, auipc, jal, jalr, beq, bne, blt, bge, bltu, bgeu
        case lb, lh, lw, lbu, lhu, sb, sh, sw
        case addi, slti, sltiu, xori, ori, andi, slli, srli, srai
        case add, sub, sll, slt, sltu, xor, srl, sra, or, and
        case mul, mulh, mulhsu, mulhu, div, divu, rem, remu
        // pseudo
        case bgt, ble, j, ret, sgt, mv, call, bnez, beqz, snez, seqz, li
        // not even pseudo MUST BE ADJUSTED WHEN OUTPUT!
        case subi
    }
    var isBranch: Bool {
        "\(op)".hasPrefix("b")
    }
    
    static let OppBranch: [OP: OP] = [
        .beq: .bne, .bne: .beq,
        .blt: .bge, .bge: .blt,
        .bgt: .ble, .ble: .bgt,
        .bnez: .beqz, .beqz: .bnez
    ]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    static func == (lhs: InstRV, rhs: InstRV) -> Bool {
        lhs === rhs
    }
    
    var description: String {
        if op == .subi {
            return "\(OP.addi) \(dst!), \(src[0]), \((src[1] as! Imm).reversed)"
        } else if dst == nil {
            return "\(op) \(src.joined())"
        } else {
            return "\(op) \(dst!), \(src.joined())"
        }
    }
    func printAsLast(nextBlock: BlockRV? = nil) -> String {
        if inBlock.succs.count < 2 {
            return description
        } else if nextBlock == inBlock.succs[0] {
            return "\(Self.OppBranch[op]!) \(src.filter{!($0 is BlockRV)}.joined()), \(inBlock.succs[1])"
        } else if nextBlock == inBlock.succs[1] {
            return "\(op) \(src.filter{!($0 is BlockRV)}.joined()), \(inBlock.succs[0])"
        } else {
            return "\(op) \(src.filter{!($0 is BlockRV)}.joined()), \(inBlock.succs[0])" + "\n" + "j \(inBlock.succs[1])"
        }
    }
    
    var op: OP
    private(set) var dst : Register!
    private(set) var src = [OperandRV]()
    var getOP: OperandRV {dst}
    subscript(idx: Int) -> OperandRV {src[idx]}
    
    var inBlock: BlockRV
    var nodeInBlock: List<InstRV>.Node!
    
    var use = Set<Register>()
    var def = Set<Register>()
    
    var ii = Set<Register>()
    var oo = Set<Register>()
    
    var succs: [InstRV] {
        self === inBlock.insts.last! ? inBlock.succs.map{$0.insts.first!} : [nodeInBlock.next!.value]
    }
    
    @discardableResult init(_ op: OP, in block: BlockRV, at index: Int = -1, to dst: Register? = nil, _ src: OperandConvertable...) {
        self.op = op
        self.inBlock = block
        
        self.dst = dst
        if dst != nil {
            def.insert(dst!)
            dst!.defs.append(self)
        }
        for s in src {
            self.src.append(s.getOP)
            if let r = s.getOP.getReg {
                use.insert(r)
                r.uses.append(self)
            }
        }
        
        switch op {
        case .call:
            use.formUnion(
                (0..<min(8, (src[0] as! FunctionRV).argNum)).map{RV32["a\($0)"]}
            )
            def.formUnion(
                RV32.callerSave.map{RV32[$0]}
            )
        case .ret:
            use.insert(RV32["ra"])
        default:
            break
        }
        
        if index == -1 {
            self.nodeInBlock = block.insts.append(self)
        } else {
            self.nodeInBlock = block.insts.insert(self, at: index)
        }
    }
    
    func replaced(by i: InstRV) {
        if dst != nil {
            dst.defs.removeAll {$0 === self}
        }
        for s in src {
            if let r = s.getReg {
                r.uses.removeAll {$0 === self}
            }
        }
        nodeInBlock.value = i
    }
    
    func newDst(_ d: Register) {
        dst.defs.removeAll {$0 === self}
        dst = d
        def = [d]
        dst.defs.append(self)
    }
    func newSrc(_ s: OperandRV, at i: Int) {
        var offset: OffsetReg? = nil
        if let r = src[i].getReg {
            offset = src[i] as? OffsetReg
            r.uses.removeAll {$0 == self}
            use.remove(r)
        }
        if offset != nil {
            offset!.reg = s as! Register
        } else {
            src[i] = s
        }
        if let r = s.getReg {
            r.uses.append(self)
            use.insert(r)
        }
    }
    
}

class BlockRV: OperandRV, Equatable {
    
    let name: String
    var insts = List<InstRV>()
    var inFunction: FunctionRV
    var nodeInFunction: List<BlockRV>.Node!
    
    var pcopy = [(Register, Register)]()
    var gen = Set<Register>()
    var kill = Set<Register>()
    var ii = Set<Register>()
    var oo = Set<Register>()
    
    let loopDepth: Int
    
    override var description: String {"." + name}
    var succs: [BlockRV] {
        insts.last!.src.compactMap{$0 as? BlockRV}
    }
    var preds = [BlockRV]()
    
    init(name: String, in f: FunctionRV, depth: Int) {
        self.name = name
        self.loopDepth = depth
        inFunction = f
        super.init()
        nodeInFunction = inFunction.blocks.append(self)
    }
    
    static func == (lhs: BlockRV, rhs: BlockRV) -> Bool {
        lhs === rhs
    }

}

class FunctionRV: OperandRV {
    
    let name: String
    var blocks = List<BlockRV>()
    let inProgram: Assmebly
    var nodeInProgram: List<FunctionRV>.Node!
    
    override var description: String {name}
    
    let stackSize = Imm(0)
    let argNum: Int
    
    init(name: String, in prog: Assmebly, argNum: Int) {
        self.name = name
        self.inProgram = prog
        self.argNum = argNum
        super.init()
        nodeInProgram = self.inProgram.functions.append(self)
    }
    
    func newVar() -> OffsetReg {
        stackSize.value += 4
        return OffsetReg(RV32["sp"], offset: Imm(stackSize.value - 4))
    }
    
    func initPred() {
        for b in blocks {
            b.preds.removeAll()
        }
        for b in blocks {
            b.succs.forEach {$0.preds.append(b)}
        }
    }
    
}

class GlobalRV: OperandRV {
    
    let name: String
    let space: Int
    let value: Int
    var high: String {"%hi(\(name))"}
    var low: String {"%lo(\(name))"}
    
    override var description: String {high}
    var toPrint: String {"""

  .globl \(name)
\(name):
  .word \(value)
"""}
    
    init(name: String, value: Int, space: Int, in prog: Assmebly) {
        self.name = name
        self.value = value
        self.space = space
        super.init()
        _ = prog.globals.append(self)
    }
}
class GlobalStr: GlobalRV {
    
    let str: StringC
    override var toPrint: String {"""

  .globl \(name)
\(name):
  .asciz "\(str.rowValue)"
"""}
    
    init(name: String, str: StringC, in prog: Assmebly) {
        self.str = str
        super.init(name: name, value: 0, space: 4, in: prog)
    }
    
}

class Imm: OperandRV {
    var value: Int = -1
    var global: GlobalRV?
    override var description: String {
        if global != nil {
            return global!.low
        }
        return "\(value)"
    }
    init(_ v: Int) {
        value = v
    }
    init(_ v: GlobalRV) {
        global = v
    }
    var reversed: Imm {
        Imm(-value)
    }
}

class OffsetReg: OperandRV {
    var reg: Register
    var offset: Imm
    override var description: String {"\(offset)(\(reg))"}
    override var getReg: Register? {reg}
    init(_ reg: Register, offset: Imm) {
        self.reg = reg
        self.offset = offset
    }
}

class StackPointer: OffsetReg {
    
    var function: FunctionRV
    init(in f: FunctionRV,offset: Imm) {
        function = f
        super.init(RV32["sp"], offset: offset)
    }
    
}
