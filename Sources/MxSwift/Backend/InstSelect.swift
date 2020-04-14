//
//  InstSelect.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/4/8.
//

import Foundation

prefix operator *
prefix func * (val: Value) -> OperandConvertable {
    InstSelect.instance.operand(val)
}
prefix operator **
prefix func ** (val: Value) -> Register {
    *val as! Register
}

class InstSelect: IRVisitor {
    
    var resultString: String {"\(self) finished. "}
    let immUpperSize = 1 << 12
    
    static var instance: InstSelect!
    init() {
        program = Assmebly()
        Self.instance = self
    }
    
    let program: Assmebly
    var curBlock: BlockRV!
    var curFunction: FunctionRV!
    var curFunctionIR: FunctionIR!
    
    var iMap = [InstIR: OperandRV]()
    var aMap = [Value: OperandRV]()
    var fMap = [FunctionIR: FunctionRV]()
    var saves = [String: VReg]()
    var bMap = [BlockIR: BlockRV]()
    var cMap = [String: Class]()
    var gMap = [Global: GlobalRV]()
    
    private func loadImmediate(_ val: Int, to reg: Register, in blk: BlockRV) -> Register {
        if val >= immUpperSize {
            return InstRV(.addi, in: blk, to: reg,
                          InstRV(.lui, in: blk, to: VReg(), val / immUpperSize),
                          val % immUpperSize).dst
        } else {
            return InstRV(.addi, in: blk, to: reg, RV32["zero"], val).dst
        }
    }
    func operand(_ val: Value, in _blk: BlockRV? = nil) -> OperandConvertable {
        let blk: BlockRV = _blk ?? curBlock
        switch val {
        case let g as GlobalVariable:
            return gMap[g]!
        case let c as ConstIR:
            if let i = c as? IntC {
                return loadImmediate(i.value, to: VReg(), in: blk)
            } else {
                assert(c is NullC)
                return loadImmediate(0, to: VReg(), in: blk)
            }
        case let i as InstIR:
            iMap[i] = iMap[i] ?? VReg()
            return iMap[i]!
        case let b as BlockIR:
            return bMap[b]!
        default:
            return aMap[val]!
        }
        assert(false)
        return -1
    }
    
    func work(on v: Module) {
        visit(v: v)
    }
    func visit(v: Module) {
        v.globalVar.forEach {$0.accept(visitor: self)}
        for f in v.functions {
            fMap[f] = FunctionRV(name: f.name, in: program)
        }
        for f in v.functions where !f.blocks.isEmpty {
            f.accept(visitor: self)
        }
    }
    func visit(v: FunctionIR) {
        saves.removeAll()
        bMap.removeAll()
        curFunctionIR = v
        curFunction = fMap[v]!
        
        for b in v.blocks {
            bMap[b] = BlockRV(name: b.name, in: curFunction)
        }
        curBlock = bMap[v.blocks.first!]!
        
        for reg in RV32.calleeSave + ["ra"] {
            saves[reg] = VReg()
            InstRV(.mv, in: curBlock, to: saves[reg]!, RV32[reg])
        }
        for (idx, op) in v.operands.enumerated() {
            let reg = VReg(name: op.name)
            aMap[op] = reg
            if idx < 8 {
                InstRV(.mv, in: curBlock, to: reg, RV32["a\(idx)"])
            } else {
                InstRV(loadMap[op.type.space]!, in: curBlock, to: reg, OffsetReg(RV32["sp"], offset: Imm(idx-8)))
            }
        }
        
        for b in v.blocks {
            for p in b.insts where p is PhiInst {
                iMap[p] = VReg(name: "phi_\(p.name)")
            }
        }
        for b in v.blocks {
            for p in b.insts where p is PhiInst {
                for i in 0..<p.operands.count/2 {
                    let use = **(p[i*2])
                    bMap[p[i*2+1] as! BlockIR]!.pcopy.append((**p, use))
                }
            }
        }

        
        v.blocks.forEach {
            $0.accept(visitor: self)
        }
        
        for irb in v.blocks {
            if let b = bMap[irb], !b.pcopy.isEmpty {
                let last = b.insts.last!.nodeInBlock
                while true {
                    b.pcopy = b.pcopy.filter({$0.0 !== $0.1})
                    if b.pcopy.isEmpty {
                        break
                    }
                    if let copy = b.pcopy.filter({ c in
                        b.pcopy.filter({$0.1 === c.0}).isEmpty
                    }).last {
                        InstRV(.mv, in: b, to: copy.0, copy.1)
                        b.pcopy.removeAll(where: {$0.0 === copy.0 && $0.1 === copy.1})
                    } else {
                        let copy = b.pcopy.removeLast()
                        b.pcopy.append((copy.0, InstRV(.mv, in: b, to: VReg(name: "copy_tmp"), copy.1).dst))
                    }
                }
                last?.moveAppendTo(newlist: b.insts)
            }
        }
        
    }
    func visit(v: Class) {}
    func visit(v: BlockIR) {
        curBlock = bMap[v]!
        v.insts.forEach {
            $0.accept(visitor: self)
        }
    }
    func visit(v: GlobalVariable) {
        gMap[v] = GlobalRV(name: v.name, space: v.type.space, in: program)
    }
    func visit(v: PhiInst) {}
    func visit(v: SExtInst) {}
    func visit(v: CastInst) {}
    static let jop: [CompareInst.CMP: InstRV.OP] = [
        .eq: .beq, .ne: .bne, .sge: .bge, .sgt: .bgt, .sle: .ble, .slt: .blt
    ]
    func visit(v: BrInst) {
        if v.operands.count == 1 {
            InstRV(.j, in: curBlock, *v[0])
        } else {
            if v[0].users.count == 1, v[0] is CompareInst {
                assert(v[0].users[0].user === v)
                let c = v[0] as! CompareInst
                InstRV(Self.jop[c.cmp]!, in: curBlock, *c[0], *c[1], *v[1], *v[2])
            } else {
                InstRV(.bnez, in: curBlock, *v[0], *v[1], *v[2])
            }
        }
    }
    func visit(v: GEPInst) {
        let offset: OperandConvertable = {
            if v[0].type is PointerT {
                return InstRV(.mul, in: curBlock, to: VReg(), *v[1], loadImmediate(v[0].type.space, to: VReg(), in: curBlock))
            } else {
                return loadImmediate(cMap[v[0].type.description]!.offset(at: (v[1] as! IntC).value),
                                     to: VReg(), in: curBlock)
            }
        }()
        InstRV(.add, in: curBlock, to: (*v as! Register), *v[0], offset)
    }
    private let loadMap : [Int: InstRV.OP] = [1: .lb, 4: .lw]
    private let storeMap: [Int: InstRV.OP] = [1: .sb, 4: .sw]
    func visit(v: LoadInst) {
        if v[0] is GlobalVariable {
            InstRV(loadMap[v[0].type.getBase.space]!, in: curBlock, to: (*v as! Register),
                   OffsetReg(InstRV(.lui, in: curBlock, to: VReg(), *v[0]).dst, offset: Imm(*v[0] as! GlobalRV)))
        } else {
            InstRV(loadMap[v[0].type.getBase.space]!, in: curBlock, to: (*v as! Register), OffsetReg(*v[0] as! Register, offset: Imm(0)))
        }
    }
    func visit(v: StoreInst) {
        InstRV(storeMap[v[1].type.getBase.space]!, in: curBlock, *v[0], *v[1])
    }
    func visit(v: CallInst) {
        for (i, op) in v.operands.enumerated() {
            if i < 8 {
                InstRV(.mv, in: curBlock, to: RV32["a\(i)"], *op)
            } else {
                InstRV(storeMap[op.type.space]!, in: curBlock, *op, curFunction.newVar())
            }
        }
        InstRV(.call, in: curBlock, fMap[v.function]!)
        if !(v.type is VoidT) {
            InstRV(.mv, in: curBlock, to: (*v as! Register), RV32["a0"])
        }
    }
    func visit(v: AllocaInst) {
        assert(false)
    }
    func visit(v: ReturnInst) {
        for reg in RV32.calleeSave + ["ra"] {
            InstRV(.mv, in: curBlock, to: RV32[reg], saves[reg]!)
        }
        if !(curFunctionIR.type is VoidT) {
            InstRV(.mv, in: curBlock, to: RV32["a0"], *v[0])
        }
        InstRV(.ret, in: curBlock)
    }
    
    static let aop: [InstIR.OP: (InstRV.OP, InstRV.OP?)] = [
        .add: (.add, .addi), .sub: (.sub, .subi), .mul: (.mul, nil),
        .sdiv: (.div, nil), .srem: (.rem, nil),
        .shl: (.sll, .slli), .ashr: (.sra, .srai),
        .and: (.and, .andi), .or: (.or, .ori), .xor: (.xor, .xori)
    ]
    static let cop: [CompareInst.CMP: (InstRV.OP, InstRV.OP?)] = [
        .eq: (.sub, .subi), .ne: (.xor, .xori),
        .slt:(.slt, .slti), .sgt: (.sgt, nil)
    ]
    static let rop: [CompareInst.CMP: InstRV.OP] = [
        .sge: .slt, .sle: .sgt
    ]
    
    func visit(v: BinaryInst) {
        var op: InstRV.OP!
        if let c = v as? CompareInst {
            if c.users.count == 1, c.users[0].user is BrInst {
                return
            }
            if Self.cop[c.cmp] != nil {
                op = Self.cop[c.cmp]!.0
            } else {
                InstRV(.xori, in: curBlock,
                       InstRV(Self.rop[c.cmp]!, in: curBlock, to: VReg(), *v[0], *v[1]),
                       1)
                return
            }
        } else {
            op = Self.aop[v.operation]!.0
        }
        InstRV(op , in: curBlock, to: (*v as! Register), *v[0], *v[1])
    }

    
}
