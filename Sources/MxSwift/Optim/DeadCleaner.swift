//
//  TruncateTerminal.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/18.
//

import Foundation

class DeadCleaner: FunctionPass {
    
    override func work(on v: Module) {
        visit(v: v)
    }
    
    override func visit(v: Function) {
        
        for blk in v.blocks {
            var term = false
            for i in blk.insts {
                if term {
                    i.disconnect(delUsee: true, delUser: true)
                } else if i.isTerminate {
                    term = true
                }
            }
        }
        
        v.blocks.forEach {$0.preds = []}
        v.blocks.forEach { (b) in
            b.succs.forEach {$0.preds.append(b)}
        }
        
        for blk in v.blocks {
            if blk.insts.count == 0 && blk.preds.isEmpty {
                blk.remove()
            } else if blk.insts.isEmpty || !blk.insts.last!.isTerminate {
                if v.type is VoidT {
                    ReturnInst(name: "", val: VoidC(), in: blk)
                } else if v.name == "main" {
                    ReturnInst(name: "", val: IntC.zero(), in: blk)
                } else {
                    error.noReturn(name: v.name)
                    break
                }
            }
        }
        
    }
}
