//
//  EmptyBlockRemover.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/19.
//

import Foundation

class EmptyBlockRemover: FunctionPass {
    
    override func visit(v: Function) {
        for blk in v.blocks {
            if blk.insts.count == 0 {
                blk.remove()
            }
        }
    }
    
}
