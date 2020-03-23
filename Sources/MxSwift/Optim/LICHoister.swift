//
//  LICHoister.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/27.
//

import Foundation

class LICHoister: FunctionPass {
    
    override func visit(v: Function) {
        
        let tree = DomTree(function: v)
        v.blocks.forEach {$0.preds = []}
        v.blocks.forEach { (b) in
            b.succs.forEach {$0.preds.append(b)}
        }
        for b in v.blocks {
            var loop = [BasicBlock](), exits = [BasicBlock.Edge](), entries = [BasicBlock]()
            for pred in b.preds {
                if tree.checkBF(b, dominates: pred) {
                    
                }
            }
        }
        
    }
    
}
