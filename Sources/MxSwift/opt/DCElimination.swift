//
//  DCElimination.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/19.
//

import Foundation

class DCElimination: FunctionPass {
    
    override func visit(v: Function) {
        
        let tree = PostDomTree(function: v)
        
        var deadInsts = Set<Inst>(), workList = Set<Inst>(), liveBlocks = Set<BasicBlock>()
        for b in v.blocks {
            for i in b.insts {
                switch i {
                case is StoreInst, is ReturnInst, is CallInst:
                    workList.insert(i)
                default:
                    deadInsts.insert(i)
                }
            }
        }
        
        func insertIntoList(i: Inst) {
            if deadInsts.contains(i) {
                workList.insert(i)
                deadInsts.remove(i)
            }
        }
        
        while !workList.isEmpty {
            let i = workList.popFirst()!
            for o in i.operands where o is Inst {
                insertIntoList(i: o as! Inst)
            }
            if !liveBlocks.contains(i.inBlock) {
                liveBlocks.insert(i.inBlock)
                for df in i.inBlock.domNode!.domFrontiers where df.block != nil {
                    insertIntoList(i: df.block!.insts.last!)
                }
            }
        }
        
        for i in deadInsts {
            if i is BrInst {
                if i.operands.count != 1 {
                    let to = i.inBlock.domNode!.findDomFatherBF {
                        $0.block != nil && liveBlocks.contains($0.block!)
                    }
                    BrInst(name: "",
                           des: to!.block!,
                           in: i.inBlock)
                    i.disconnect(delUsee: true, delUser: true)
                }
            } else {
                i.disconnect(delUsee: true, delUser: true)
            }
        }
        
    }
    
}
