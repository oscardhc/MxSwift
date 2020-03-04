//
//  DCElimination.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/19.
//

import Foundation

class DCElimination: FunctionPass {
    
    private var instRemoved = 0
    override var resultString: String {super.resultString + "\(instRemoved) inst(s) removed."}
    
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
            if let p = i as? PhiInst {
                for o in p.operands where o is BasicBlock {
                    insertIntoList(i: (o as! BasicBlock).insts.last!)
                }
            }
            for o in i.operands where o is Inst {
                insertIntoList(i: o as! Inst)
            }
            if !liveBlocks.contains(i.inBlock) {
                liveBlocks.insert(i.inBlock)
                for df in tree[i.inBlock].domFrontiers where df.block != nil {
                    insertIntoList(i: df.block!.insts.last!)
                }
            }
        }
        
        for i in deadInsts {
            if i is BrInst {
                if i.operands.count != 1 {
                    let to = tree[i.inBlock].idom!.findDomFatherBF {
                        $0.block != nil && liveBlocks.contains($0.block!)
                    }
//                    print("changed [\(i.inBlock) \(liveBlocks.contains(i.inBlock)) -> \(to!.block!)]:", i.toPrint)
                    BrInst(name: "",
                           des: to!.block!,
                           in: i.inBlock)
                    i.disconnect(delUsee: true, delUser: true)
                }
            } else {
                instRemoved += 1
                i.disconnect(delUsee: true, delUser: true)
            }
        }
        
    }
    
}
