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
            if blk.insts.count == 0 {
                blk.remove()
            }
        }
        
        for blk in v.blocks {
            
            var from: List<Inst>.Node = blk.insts.tail.prev!
            
            while from.prev!.value != nil && from.prev!.value.isTerminate {
                from.value.disconnect(delUsee: true, delUser: true)
                from = from.prev!
            }
            
        }
    }
}
