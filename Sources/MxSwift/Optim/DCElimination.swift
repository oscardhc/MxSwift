//
//  DCElimination.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/19.
//

import Foundation

class DCElimination: FunctionPass {
    
    let aa: PTAnalysis?
    private var instRemoved = 0
    override var resultString: String {super.resultString + "\(instRemoved) inst(s) removed."}
    
    init(_ aa: PTAnalysis? = nil) {
        self.aa = aa
    }
    
    override func visit(v: FunctionIR) {
        
        let tree = PostDomTree(function: v, needFrontier: true)
        
        var deadInsts = Set<InstIR>(), workList = Set<InstIR>(), liveBlocks = Set<BlockIR>(), livePos = Set<Value>()
        
        for b in v.blocks {
            for i in b.insts {
                switch i {
                case is StoreInst, is ReturnInst:
                    workList.insert(i)
                case let c as CallInst :
                    if !c.function.noSideEffect {
                        workList.insert(c)
                    } else {
                        fallthrough
                    }
                default:
                    deadInsts.insert(i)
                }
            }
        }
        
        if aa != nil {
            for para in v.operands {
                livePos.formUnion(para.pts)
            }
            for glob in v.currentModule.globalVar {
                livePos.formUnion(glob.pts)
            }
        }
        
        func insertIntoList(i: InstIR) {
            if deadInsts.contains(i) {
                workList.insert(i)
                deadInsts.remove(i)
            }
        }
        
        while !workList.isEmpty {
            let i = workList.popFirst()!
            if let p = i as? PhiInst {
                for o in p.operands where o is BlockIR {
                    insertIntoList(i: (o as! BlockIR).insts.last!)
                }
            }
            for o in i.operands {
                if let oo = o as? InstIR {
                    insertIntoList(i: oo)
                }
                if aa != nil {
                    livePos.formUnion(o.pts)
                }
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
        
        if aa != nil {
            for b in v.blocks {
                for i in b.insts where i is StoreInst && i[1].pts.intersection(livePos).isEmpty {
                    instRemoved += 1
//                    print("DCE", i.toPrint, i[1], aa!.pts[i[1]]!)
                    i.disconnect(delUsee: true, delUser: true)
                }
            }
        }
        
    }
    
}
