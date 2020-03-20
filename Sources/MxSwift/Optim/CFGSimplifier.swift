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
        func change() {
            changed = true
            blocksChanged += 1
        }
        while changed {
            changed = false
            v.blocks.forEach {$0.preds = []}
            v.blocks.forEach { (b) in
                b.succs.forEach {$0.preds.append(b)}
            }
            
            var emptyReturns = [BasicBlock]()
            for b in v.blocks where b.insts.last is ReturnInst {
                if b.insts.count == 1 || (b.insts.count == 2 && b.insts.first is PhiInst) {
                    emptyReturns.append(b)
                }
            }
            if emptyReturns.count > 1 {
                let ret = emptyReturns.removeFirst(), phi: PhiInst!
                if ret.insts.count > 1 {
                    phi = (ret.insts.first! as? PhiInst)!
                } else {
                    phi = PhiInst(name: "", type: ret.insts.last!.operands[0].type, in: ret, at: 0)
                    let oriVal = ret.insts.last!.operands[0]
                    ret.insts.last!.usees[0].reconnect(fromValue: phi)
                    for pred in ret.preds {
                        _ = phi.added(operand: oriVal)
                        _ = phi.added(operand: pred)
                    }
                }
                for blk in emptyReturns {
                    if blk.insts.count > 1 {
                        for op in blk.insts.first!.operands {
                            _ = phi.added(operand: op)
                        }
                    } else {
                        _ = phi.added(operand: blk.insts.last!.operands[0])
                        _ = phi.added(operand: blk)
                    }
                    for i in blk.insts {
                        i.disconnect(delUsee: true, delUser: true)
                    }
                    BrInst(name: "", des: ret, in: blk)
                }
                change()
            }
            
            for b in v.blocks where b.preds.isEmpty && b !== b.inFunction.blocks.first! {
                b.remove() {
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
                
                if b.preds.count > 0 && b.insts.count == 1 && b.insts.last! is BrInst && b.insts.last!.operands.count == 1 { // only uncond br
                    
                    let t = b.insts.last!.operands[0] as! BasicBlock
                    if t.insts.first! is PhiInst && b.preds[0].succs.count > 1 {
                        continue
                    }
                    for u in b.users {
                        u.reconnect(fromValue: u.user is PhiInst ? b.preds[0] : t)
                    }
                    b.remove() {
                        $0.disconnect(delUsee: false, delUser: false)
                    }
                    change()
                }
                
            }
            //            break
            
        }
        
    }
    
}
