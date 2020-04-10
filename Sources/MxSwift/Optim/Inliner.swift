//
//  Inliner.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/3/26.
//

import Foundation

class Inliner: ModulePass {
    
    var inlinable = [IRFunction]()
    var valueMap = [Value: Value]()
    
    func findValue(_ v: Value) -> Value {
        if let ret = valueMap[v] {
            return ret
        } else {
            assert(v is ConstIR)
            return v
        }
    }
    
    private func copy(_ inst: InstIR, in block: BlockIR, returnBlock: BlockIR) -> InstIR {
        
        func op(_ i: Int) -> Value {
            findValue(inst[i])
        }
        
        switch inst {
        case is PhiInst:
            let phi = PhiInst(type: inst.type, in: block)
            return phi
        case is BrInst:
            if inst.operands.count > 1 {
                return BrInst(condition: op(0), accept: op(1), reject: op(2), in: block)
            } else {
                return BrInst(des: op(0), in: block)
            }
        case is ReturnInst:
            BrInst(des: returnBlock, in: block)
            return returnBlock.insts.first!.added(operand: op(0)).added(operand: block)
        case is CallInst:
            let call = CallInst(function: (inst as! CallInst).function, arguments: [], in: block)
            inst.operands.forEach {call.added(operand: findValue($0))}
            return call
        case is SExtInst:       return SExtInst     (val: op(0), toType: inst.type, in: block)
        case is CastInst:       return CastInst     (val: op(0), toType: inst.type, in: block)
        case let g as GEPInst:  return GEPInst      (type: inst.type, base: op(0), needZero: g.needZero, val: op(1), in: block)
        case is LoadInst:       return LoadInst     (alloc: op(0), in: block)
        case is StoreInst:      return StoreInst    (alloc: op(1), val: op(0), in: block)
        case is AllocaInst:     return AllocaInst   (forType: inst.type.getBase, in: block)
        case is CompareInst:    return CompareInst  (lhs: op(0), rhs: op(1), cmp: (inst as! CompareInst).cmp, in: block)
        case is BinaryInst:     return BinaryInst   (type: inst.type, operation: inst.operation, lhs: op(0), rhs: op(1), in: block)
        default:
            assert(false)
            return InstIR(name: "", type: .int, operation: .add, in: block)
        }
    }
    
    private func inline(f: IRFunction, in cur: IRFunction, for call: CallInst) {
        valueMap.removeAll()
        let domTree = DomTree(function: f)
        
        let retBlock = BlockIR(curfunc: cur)
        
        _ = PhiInst(type: f.type, in: retBlock)
        
        for (form, real) in zip(f.operands, call.operands) {
            valueMap[form] = real
        }
        for blk in f.blocks {
            valueMap[blk] = BlockIR(curfunc: cur)
        }
        
        func dfs(cur: DomTree.Node) {
            for i in cur.block!.insts {
                let newInst = copy(i, in: findValue(cur.block!) as! BlockIR , returnBlock: retBlock)
                valueMap[i] = newInst
            }
            for son in cur.domSons {
                dfs(cur: son)
            }
        }
        
        dfs(cur: domTree[f.blocks.first!])
        for blk in f.blocks {
            for i in blk.insts where i is PhiInst {
                let phi = valueMap[i]! as! PhiInst
                i.operands.forEach {phi.added(operand: findValue($0))}
            }
        }
        
        var nxt = call.nextInst
        while let cur = nxt {
            nxt = cur.nextInst
            cur.changeAppend(to: retBlock)
        }
        
        BrInst(des: findValue(f.blocks.first!), in: call.inBlock)
        for u in call.inBlock.users where u.user is PhiInst {
            u.reconnect(fromValue: retBlock)
        }
        if f.type is VoidT {
            retBlock.insts.first!.disconnect(delUsee: true, delUser: true)
            call.disconnect(delUsee: true, delUser: true)
        } else {
            call.replaced(by: retBlock.insts.first!)
        }
    }
    
    override func visit(v: Module) {
        
        var calling = [IRFunction: Int](), called = [IRFunction: Int]()
        for f in v.functions {
            called[f] = 0
            calling[f] = 0
        }
        for f in v.functions {
            for b in f.blocks {
                for i in b.insts {
                    if let c = i as? CallInst, !IRBuilder.Builtin.functions.values.contains(c.function) {
                        calling[f]! += 1
                        called[c.function]! += 1
                    }
                }
            }
        }
//        print("calling", calling)
        for toInline in v.functions where calling[toInline]! <= 1 {
            if toInline.blocks.isEmpty || toInline.name == "@main" {
                continue
            }
            let size = toInline.size
            if size.0 * called[toInline]! > 1000 || called[toInline]! == 0 {
                continue
            }
            print("TOINLINE", toInline.name, size.0, called[toInline]!)
            var calls = [CallInst]()
            for f in v.functions where f !== toInline {
                for b in f.blocks {
                    for i in b.insts {
                        if let c = i as? CallInst, c.function === toInline {
                            calls.append(c)
                        }
                    }
                }
            }
            for c in calls {
                inline(f: c.function, in: c.inBlock.inFunction, for: c)
            }

            if calling[toInline]! == 0 {
                for b in toInline.blocks {
                    for i in b.insts {
                        i.disconnect(delUsee: true, delUser: true)
                    }
                }
                v.functions.removeAll {$0 === toInline}
            }
            
        }
        
    }
    
}
