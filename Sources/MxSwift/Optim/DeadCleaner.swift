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
        
        var live = Set<BasicBlock>([v.blocks.first!]), workList = [v.blocks.first!]
        
        while let b = workList.popLast() {
            for s in b.succs where !live.contains(s) {
                live.insert(s)
                workList.append(s)
            }
        }
        
        for b in v.blocks where !live.contains(b) {
            b.remove {
                $0.disconnect(delUsee: true, delUser: true)
            }
        }
        
    }
}
