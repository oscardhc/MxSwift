//
//  InstSelect.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/4/8.
//

import Foundation

class InstSelect: IRVisitor {
    
    var resultString: String {"\(self) finished. "}
    let immUpperSize = 1<<12
    
    var curBlock: BlockRV!
    var curFunction: FunctionRV!
    var curFunctionIR: FunctionIR!
    
    var iMap = [InstIR: OperandRV]()
    var aMap = [Value: OperandRV]()
    var fMap = [FunctionIR: OperandRV]()
    var saves = [String: VReg]()
    
    private func operand(_ val: Value, in _blk: BlockRV? = nil, noImm: Bool = false) -> OperandConvertable {
        let blk: BlockRV = _blk ?? curBlock
        switch val {
        case let c as ConstIR:
            if let i = c as? IntC {
                if i.value > immUpperSize || noImm {
                    return InstRV(op: .addi, in: blk).d(VReg())
                        .s(InstRV(op: .lui, in: blk)
                            .d(VReg())
                            .s(i.value % immUpperSize))
                        .s(i.value / immUpperSize)
                } else if noImm {
                    return InstRV(op: .addi, in: blk).d(VReg()).s(RV32["zero"]).s(i.value)
                } else {
                    return i.value
                }
            }
        case let i as InstIR:
            iMap[i] = iMap[i] ?? VReg()
            return iMap[i]!
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
        v.functions.forEach {$0.accept(visitor: self)}
    }
    func visit(v: FunctionIR) {
        saves.removeAll()
        curFunctionIR = v
        curFunction = FunctionRV()
        curBlock = BlockRV(in: curFunction)
        
        for reg in RV32.calleeSave {
            saves[reg] = VReg()
            InstRV(op: .mv, in: curBlock).s(RV32[reg]).d(saves[reg]!)
        }
        for (idx, op) in v.operands.enumerated() {
            let reg = VReg(name: op.name)
            aMap[op] = reg
            if idx < 8 {
                InstRV(op: .mv, in: curBlock).d(reg).s(RV32["a\(idx)"])
            } else {
                InstRV(op: loadMap[op.type.space]!, in: curBlock).d(reg).s(OffsetReg(RV32["sp"], offset: idx-8))
            }
        }
        
        v.blocks.forEach {
            $0.accept(visitor: self)
        }
    }
    func visit(v: Class) {
    }
    func visit(v: BlockIR) {
        v.insts.forEach {
            $0.accept(visitor: self)
        }
    }
    func visit(v: GlobalVariable) {
        
    }
    func visit(v: PhiInst) {
        
    }
    func visit(v: SExtInst) {
        
    }
    func visit(v: CastInst) {
    
    }
    func visit(v: BrInst) {
        if v.operands.count == 1 {
            
        } else {
            if v[0].users.count == 1 {
                assert(v[0].users[0].user === self)
            } else {
                
            }
        }
    }
    func visit(v: GEPInst) {
    
    }
    private let loadMap : [Int: InstRV.OP] = [1: .lb, 4: .lw]
    private let storeMap: [Int: InstRV.OP] = [1: .sb, 4: .sw]
    func visit(v: LoadInst) {
        switch v[0].type.getBase {
        case let i as IntT:
            InstRV(op:loadMap[i.space]!, in: curBlock).d(operand(v) as! Register).s(operand(v[0]))
        default:
            assert(false)
        }
    }
    func visit(v: StoreInst) {
        switch v[1].type.getBase {
        case let i as IntT:
            InstRV(op:storeMap[i.space]!, in: curBlock).s(operand(v[0])).s(operand(v[1]))
        default:
            assert(false)
        }
    }
    func visit(v: CallInst) {
        for (i, op) in v.operands.enumerated() {
            if i < 8 {
                InstRV(op: .mv, in: curBlock).d(RV32["a\(i)"]).s(operand(op))
            } else {
                InstRV(op: storeMap[op.type.space]!, in: curBlock)
                    .s(operand(op))
                    .s(curFunction.newVar())
            }
        }
        InstRV(op: .call, in: curBlock).s(fMap[v.function]!)
        if !(v.type is VoidT) {
            InstRV(op: .mv, in: curBlock).d(operand(v) as! Register).s(RV32["a0"])
        }
    }
    func visit(v: AllocaInst) {
        assert(false)
    }
    func visit(v: ReturnInst) {
        for reg in RV32.calleeSave {
            InstRV(op: .mv, in: curBlock).s(saves[reg]!).d(RV32[reg])
        }
        InstRV(op: .ret, in: curBlock)
    }
    
    let bop: [InstIR.OP: (InstRV.OP, InstRV.OP?)] = [
        .add: (.add, .addi), .sub: (.sub, .subi), .mul: (.mul, nil),
        .sdiv: (.div, nil), .srem: (.rem, nil),
        .shl: (.sll, .slli), .ashr: (.sra, .srai),
        .and: (.and, .andi), .or: (.or, .ori), .xor: (.xor, .xori)
    ]
    let cop: [CompareInst.CMP: (InstRV.OP, InstRV.OP?)] = [
        .eq: (.sub, .subi), .ne: (.xor, .xori),
        .slt:(.slt, .slti), .sgt: (.sgt, nil)
    ]
    
    func visit(v: BinaryInst) {
        var op: (InstRV.OP, InstRV.OP?)!
        if let c = v as? CompareInst {
            if c.users.count == 1, c.users[0].user is BrInst {
                return
            }
            op = cop[c.cmp]!
        } else {
            op = bop[v.operation]!
        }
        let ret = operand(v) as! Register
        let lhs = operand(v[0], noImm: true) as! Register
        let rhs = operand(v[1], noImm: op.1 == nil)
        if rhs is Int {
            InstRV(op: op.1!, in: curBlock).d(ret).s(lhs).s(rhs as! Int)
        } else {
            InstRV(op: op.0 , in: curBlock).d(ret).s(lhs).s(rhs as! Register)
        }
    }

    
}
