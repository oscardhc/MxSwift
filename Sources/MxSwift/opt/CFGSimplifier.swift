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

    var changed = true
    func change() {
        changed = true
        blocksChanged += 1
    }
    
    override func visit(v: Function) {
        while changed {
            changed = false
            
//            print("_____________________________")
            
//            remember to maintain PREDS when operating in one iteration!!!
            
//            phase 1: unreachable blocks
            v.blocks.forEach {$0.preds = []}
            v.blocks.forEach { (b) in
                b.succs.forEach {($0 as! BasicBlock).preds.append(b)}
            }
            
            for b in v.blocks where b.preds.isEmpty && b !== b.inFunction.blocks.first! {
                b.remove() {
                    $0.disconnect(delUsee: true, delUser: true)
                }
                changed = true
            }
//
////            phase 2: merge return blocks
//            for b in v.blocks where b.insts.last! is ReturnInst && b.insts.first! is PhiInst {
//                if b.insts.last!.operands[0] === b.insts.first! {
//
//                }
//                changed = true
//            }
            
            for b in v.blocks {
//                print(b.name, b.preds.count, b.insts.count, b.insts.joined() {"\($0.operation)"}, b.insts.last?.operation)
                
                if b.preds.count == 1 && b.preds[0].succs.count == 1 { // only route
                    let p = b.preds[0]

                    p.insts.last?.disconnect(delUsee: true, delUser: true)
                    b.remove() {
                        $0.nodeInBlock?.moveAppendTo(newlist: p.insts)
                    }
//                    print("!! 1")
                    change()
                    continue
                }
//
//                if b.preds.count == 1 && b.insts.first! is PhiInst {
//                    for i in b.insts where i is PhiInst {
//                        i.replacedBy(value: i.operands[0])
//                    }
//                    print("!! 2")
//                    continue
//                }
                
                if b.insts.count == 1 && b.insts.last! is BrInst && b.insts.last!.operands.count == 1 { // only uncond br
                    let t = b.insts.last!.operands[0] as! BasicBlock
                    
                    if t.insts.first! is PhiInst {
                        continue
                    }
                    
                    for u in b.users {
                        u.reconnect(fromValue: u.user is PhiInst ? b.preds[0] : t)
                    }
                    b.remove() {
//                        print($0.users.count, $0.usees.count)
                        $0.disconnect(delUsee: false, delUser: false)
                    }
//                    print("!! 3", b.name, t.name)
                    change()
                    continue
                }
                
            }
//            break
            
        }
        
    }
    
}
