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

    override func visit(v: Function) {
        
        var changed = true
        while changed {
            changed = false
            
//            remember to maintain PREDS when operating in one iteration!!!
            
//            phase 1: unreachable blocks
            v.blocks.forEach {$0.preds = []}
            v.blocks.forEach { (b) in
                b.succs.forEach {($0 as! BasicBlock).preds.append(b)}
            }
            
            for b in v.blocks where b.preds.isEmpty{
                b.remove() {$0.disconnect(delUsee: true, delUser: true)}
                changed = true
            }
            
//            phase 2: merge return blocks
            for b in v.blocks where b.insts.last! is ReturnInst && b.insts.first! is PhiInst {
                if b.insts.last!.operands[0] === b.insts.first! {
                    
                }
                changed = true
            }
            
            for b in v.blocks {
                print(b.name, b.preds.count, b.insts.count, b.insts.joined() {"\($0.operation)"})
                
                if b.preds.count == 1 && b.preds[0].succs.count == 1 { // only route
                    let p = b.preds[0]
                    for i in b.insts {i.nodeInBlock?.moveAppendTo(newlist: p.insts)}
//                    for s in b.succs {(s as! BasicBlock).preds.re}
                    b.remove()
                    print("!! 1")
                    changed = true
                    continue
                }
                
                if b.preds.count == 1 && b.insts.first! is PhiInst {
                    for i in b.insts where i is PhiInst {
                        i.replacedBy(value: i.operands[0])
                    }
                    print("!! 2")
                    changed = true
                    continue
                }
                
                if b.insts.count == 1 && b.insts.last! is BrInst && b.insts.last!.operands.count == 1 { // only uncond br
                    let t = b.insts.last!.operands[0]
                    b.preds.forEach {
                        for o in $0.insts.last!.usees where o.value === b {
                            o.reconnect(fromValue: t)
                        }
                    }
                    print("!! 3")
                    changed = true
                    continue
                }
                
            }
            
        }
        
    }
    
}
