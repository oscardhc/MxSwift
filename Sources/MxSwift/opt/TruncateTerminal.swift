//
//  TruncateTerminal.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/18.
//

import Foundation

class TruncateTerminal: FunctionPass {
    
    override func visit(v: Function) {
        for blk in v.blocks {
            var from: List<Inst>.Node? = nil
            for inst in blk.insts {
                if inst.isTerminate {
                    from = inst.nodeInBlock?.next
                    break
                }
            }
            while from?.next != nil {
                from?.value.disconnect(delUsee: true, delUser: true)
                from = from?.next
            }
        }
    }
}
