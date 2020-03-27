//
//  Inliner.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/3/26.
//

import Foundation

class Inliner: ModulePass {
    
    var inlinable = [Function]()
    var valueMap = [Value: Value]()
    
    func findValue(_ v: Value) -> Value {
        if let ret = valueMap[v] {
            return ret
        } else {
            assert(v is Const)
            return v
        }
    }
    
    private func copy(_ inst: Inst, in block: BasicBlock, returnBlock: BasicBlock) -> Inst {
        
        func op(_ i: Int) -> Value {
            findValue(inst[i])
        }
        
        switch inst {
        case is PhiInst:
            let phi = PhiInst(type: inst.type, in: block)
            inst.operands.forEach {phi.added(operand: findValue($0))}
            return phi
        case is SExtInst:       return SExtInst(val: op(0), toType: inst.type, in: block)
        case is CastInst:       return CastInst(val: op(0), toType: inst.type, in: block)
        case is BrInst:
            if inst.operands.count > 1 {
                return BrInst(condition: op(0), accept: op(1), reject: op(2), in: block)
            } else {
                return BrInst(des: op(0), in: block)
            }
        case let g as GEPInst:  return GEPInst(type: inst.type, base: op(0), needZero: g.needZero, val: op(1), in: block)
        case is ReturnInst:
            BrInst(des: returnBlock, in: block)
            return returnBlock.insts.first!.added(operand: op(0)).added(operand: block)
        case is LoadInst:       return LoadInst(alloc: op(0), in: block)
        case is StoreInst:      return StoreInst(alloc: op(1), val: op(0), in: block)
        case is CallInst:       return CallInst(function: (inst as! CallInst).function, arguments: [Value](inst.operands), in: block)
        case is AllocaInst:     return AllocaInst(forType: inst.type.getBase, in: block)
        case is CompareInst:    return CompareInst(lhs: op(0), rhs: op(1), cmp: (inst as! CompareInst).cmp, in: block)
        case is BinaryInst:     return BinaryInst(type: inst.type, operation: inst.operation, lhs: op(0), rhs: op(1), in: block)
        default:
            assert(false)
            return Inst(name: "", type: .int, operation: .add, in: block)
        }
    }
    
    private func inline(f: Function, in cur: Function, for call: CallInst) {
        valueMap.removeAll()
        let domTree = DomTree(function: f)
        
        let retBlock = BasicBlock(curfunc: cur)
        _ = PhiInst(type: f.type, in: retBlock)
        
        for (form, real) in zip(f.operands, call.operands) {
            valueMap[form] = real
        }
        for blk in f.blocks {
            valueMap[blk] = BasicBlock(curfunc: cur)
        }
        
        func dfs(cur: DomTree.Node) {
            for i in cur.block!.insts {
                let newInst = copy(i, in: findValue(cur.block!) as! BasicBlock , returnBlock: retBlock)
                valueMap[i] = newInst
            }
            for son in cur.domSons {
                dfs(cur: son)
            }
        }
        
        dfs(cur: domTree[f.blocks.first!])
        
        var nxt = call.nextInst
        while let cur = nxt {
            nxt = cur.nextInst
            cur.changeAppend(to: retBlock)
        }
        
        BrInst(des: findValue(f.blocks.first!), in: call.inBlock)
        for u in call.inBlock.users where u.user is PhiInst {
            u.reconnect(fromValue: retBlock)
        }
        call.replaced(by: retBlock.insts.first!)
    }
    
    override func visit(v: Module) {
        
        for f in v.functions {
            for b in f.blocks {
                for i in b.insts {
                    if let c = i as? CallInst, c.function.name == "@check" {
                        inline(f: c.function, in: f, for: c)
                    }
                }
            }
        }
        
    }
    
}
