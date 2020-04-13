//
//  InstRV.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/4/8.
//

import Foundation

protocol OperandConvertable {
    var getOP: OperandRV {get}
}

extension Int: OperandConvertable {
    var getOP: OperandRV {Imm(self)}
}

class OperandRV: CustomStringConvertible, OperandConvertable {
    var description: String {"?"}
    var getOP: OperandRV {self}
}

class InstRV: CustomStringConvertible, OperandConvertable {
    
    enum OP {
        case lui, auipc, jal, jalr, beq, bne, blt, bge, bltu, bgeu
        case lb, lh, lw, lbu, lhu, sb, sh, sw
        case addi, slti, sltiu, xori, ori, andi, slli, srli, srai
        case add, sub, sll, slt, sltu, xor, srl, sra, or, and
        case mul, mulh, mulhsu, mulhu, div, divu, rem, remu
        // pseudo
        case bgt, ble, j, ret, sgt, mv, call, bnez
        // not even pseudo MUST BE ADJUSTED WHEN OUTPUT!
        case subi
    }
    
    var description: String {
        if dst == nil {
            return "\(op) \(src.joined())"
        } else {
            return "\(op) \(dst!), \(src.joined())"
        }
    }
    
    var op: OP
    private(set) var dst : Register!
    private(set) var src = List<OperandRV>()
    var getOP: OperandRV {dst}
    subscript(idx: Int) -> OperandRV {src[idx]}
    
    var inBlock: BlockRV
    var nodeInBlock: List<InstRV>.Node!
    
    var use: [Register] {
        src.filter{$0 is Register}.map{$0 as! Register}
    }
    var def: [Register] {
        dst == nil ? [] : [dst]
    }
    
    
    @discardableResult init(_ op: OP, in block: BlockRV, at index: Int = -1, to dst: Register? = nil, _ src: OperandConvertable...) {
        self.op = op
        self.inBlock = block
        
        self.dst = dst
        if dst != nil {
            dst!.defs.append(self)
        }
        
        for s in src {
            self.src.append(s.getOP)
            if let r = s.getOP as? Register {
                r.uses.append(self)
            }
        }
        
        if index == -1 {
            self.nodeInBlock = block.insts.append(self)
        } else {
            self.nodeInBlock = block.insts.insert(self, at: index)
        }
    }
    
//    @discardableResult func d(_ d: Register) -> Self {dst = d; return self;}
//    @discardableResult func s(_ s: OperandConvertable) -> Self {src.append(s.getOP); return self;}
//
//    @discardableResult static func >> (i: InstRV, d: Register) -> InstRV {return i.d(d);}
//    @discardableResult static func << (i: InstRV, s: OperandConvertable) -> InstRV {return i.s(s);}
    
}

class BlockRV: OperandRV {
    
    let name: String
    var insts = List<InstRV>()
    var inFunction: FunctionRV
    var nodeInFunction: List<BlockRV>.Node!
    
    var gen = Set<Register>()
    var kill = Set<Register>()
    var ii = Set<Register>()
    var oo = Set<Register>()
    
    override var description: String {"." + name}
    var succs: [BlockRV] {
        insts.last!.src.filter{$0 is BlockRV}.map{$0 as! BlockRV}
    }
    
    init(name: String, in f: FunctionRV) {
        self.name = name
        inFunction = f
        super.init()
        nodeInFunction = inFunction.blocks.append(self)
    }

}

class FunctionRV: OperandRV {
    
    let name: String
    var blocks = List<BlockRV>()
    var inProgram: Assmebly
    var nodeInProgram: List<FunctionRV>.Node!
    
    override var description: String {name}
    
    var stackSize: Int = 0
    
    init(name: String, in prog: Assmebly) {
        self.name = name
        self.inProgram = prog
        super.init()
        nodeInProgram = self.inProgram.functions.append(self)
    }
    
    func newVar() -> OffsetReg {
        stackSize += 4
        return OffsetReg(RV32["sp"], offset: stackSize-4)
    }
    
}

class Assmebly {
    
    var functions = List<FunctionRV>()
    var globals = List<GlobalRV>()
    
}

class GlobalRV: OperandRV {
    
    let name: String
    let space: Int
    override var description: String {".comm \(name), \(space), \(space)"}
    init(name: String, space: Int, in prog: Assmebly) {
        self.name = name
        self.space = space
        super.init()
        _ = prog.globals.append(self)
    }
}

class Imm: OperandRV {
    var value: Int
    override var description: String {"\(value)"}
    init(_ v: Int) {
        value = v
    }
}

class OffsetReg: OperandRV {
    var reg: Register
    var offset: Int
    override var description: String {"(\(offset)\(reg)"}
    init(_ reg: Register, offset: Int) {
        self.reg = reg
        self.offset = offset
    }
}
