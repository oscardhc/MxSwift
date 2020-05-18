//
//  CFGSimplifier.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/21.
//

import Foundation

class CFGSimplifier: FunctionPass {
    
    private var blocksChanged = 0
    override var resultString: String {super.resultString + "\(blocksChanged) block(s) changed."}
    var noPhi: Bool
    
    init(_ noPhi: Bool) {
        self.noPhi = noPhi
    }
    
    override func visit(v: FunctionIR) {
        var changed = true
        func change() {
            changed = true
            blocksChanged += 1
        }
        while changed && !noPhi {
            changed = false
            
            v.calPreds()
            var emptyReturns = [BlockIR]()
            for b in v.blocks where b.insts.last is ReturnInst {
                if b.insts.count == 1 || (b.insts.count == 2 && b.insts.first is PhiInst) {
                    emptyReturns.append(b)
                }
            }
//            print(v.name, emptyReturns)
            if !(v.type is VoidT) && emptyReturns.count > 1 {
                let ret = emptyReturns.removeFirst(), phi: PhiInst!
//                print("empty!!!", ret.name)
                if ret.insts.count > 1 {
                    phi = (ret.insts.first! as? PhiInst)!
                } else {
                    phi = PhiInst(name: "", type: ret.insts.last![0].type, in: ret, at: 0)
                    let oriVal = ret.insts.last![0]
                    ret.insts.last!.usees[0].reconnect(fromValue: phi)
                    for pred in ret.preds {
                        _ = phi.added(operand: oriVal)
                        _ = phi.added(operand: pred)
                    }
                }
                for blk in emptyReturns {
//                    print("merge!!!", blk.name)
                    print(phi.toPrint)
                    if blk.insts.count > 1 {
                        for op in blk.insts.first!.operands {
                            _ = phi.added(operand: op)
                        }
                    } else {
                        _ = phi.added(operand: blk.insts.last![0])
                        _ = phi.added(operand: blk)
                    }
                    print(phi.toPrint)
                    for i in blk.insts {
                        i.disconnect(delUsee: true, delUser: true)
                    }
                    BrInst(name: "", des: ret, in: blk)
                }

                changed = true
            }
            
            v.calPreds()
            
            for b in v.blocks where b.preds.isEmpty && b !== b.inFunction.blocks.first! {
                b.remove {
                    $0.disconnect(delUsee: true, delUser: true)
                }
                change()
            }
            
            // possible users of a basic block: PHI inst or BR inst
            
            for b in v.blocks {
                
                if b.preds.count == 1 && b.preds[0].succs.count == 1 {
                    let v = b.preds[0]
                    v.insts.last?.disconnect(delUsee: true, delUser: true)
                    for u in b.users {
                        u.reconnect(fromValue: v)
                    }
                    b.remove() {
                        $0.changeAppend(to: v)
                    }
                    change()
                }
                
                if b.preds.count > 0 && b.insts.count == 1 && b.insts.last! is BrInst && b.insts.last!.operands.count == 1 {
                    // only uncond br

                    let t = b.insts.last![0] as! BlockIR
//                    print(b.preds)
                    if t.insts.first! is PhiInst {
                        var flag = false
                        for pp in b.preds where pp.succs.count > 1 {
                            flag = true
                        }
                        if flag {
                            continue
                        }
                    }
//                    print(">>>", b.name)
                    for u in b.users {
                        if let p = u.user as? PhiInst {
                            let v = u.nodeInUser.prev!.value!
                            u.disconnect()
                            v.disconnect()
                            for pp in b.preds {
                                _ = p.added(operand: v.value)
                                _ = p.added(operand: pp)
                            }
                        } else {
                            u.reconnect(fromValue: t)
                        }
                    }
                    b.remove {
                        $0.disconnect(delUsee: false, delUser: false)
                    }
                    change()
                }
                
            }
            //            break
            
        }
        
    }
    
}
