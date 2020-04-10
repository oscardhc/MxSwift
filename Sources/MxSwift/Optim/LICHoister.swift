//
//  LICHoister.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/27.
//

import Foundation

class LICHoister: FunctionPass {
    
    let aa: PTAnalysis
    var tree: DomTree!
    private var instRemoved = 0
    override var resultString: String {super.resultString + "\(instRemoved) inst(s) removed."}
    
    init(_ aa: PTAnalysis) {
        self.aa = aa
    }
    
    class Loop {
        var header: BlockIR
        var blocks = Set<BlockIR>()
        
        init (h: BlockIR) {
            self.header = h
        }
    }
    
    func hoist(ins: [BlockIR: [InstIR]], in loop: Loop) {
        let preds = loop.header.preds.filter({!loop.blocks.contains($0)})
        if preds.count == 1 {
            print("hoist", ins, loop.header, preds)
            let p = preds[0]
            func hoist(cur: DomTree.Node) {
                if var ii = ins[cur.block!] {
                    ii.sort(by: {$0.blockIndexBF < $1.blockIndexBF})
                    instRemoved += ii.count
                    print("|||", ii.joined() {$0.toPrint})
                    for i in ii {
                        i.changeAppend(to: p)
                        i.prevInst?.changeAppend(to: p)
                    }
                }
                for son in cur.domSons where loop.blocks.contains(son.block!) {
                    hoist(cur: son)
                }
            }
            hoist(cur: tree[loop.header])
        } else {
            print("FAILED!!!!")
        }
    }
    
    override func visit(v: IRFunction) {
//        print("=", v.name)
        
        tree = DomTree(function: v)
        v.calPreds()
        
        var loops = [Loop]()
        for b in v.blocks {
            for pred in b.preds {
                if tree.checkBF(b, dominates: pred) {
                    let loop = Loop(h: b)
                    loop.blocks.insert(pred)
                    var queue = [pred]
                    while let cur = queue.popLast() {
                        if cur !== b {
                            for pr in cur.preds where !loop.blocks.contains(pr) {
                                loop.blocks.insert(pr)
                                queue.append(pr)
                            }
                        }
                    }
                    
                    loops.append(loop)
                }
            }
        }
        
        loops.sort(by: {$0.blocks.count > $1.blocks.count})
        
        for loop in loops {
//            print("--- loop", loop.blocks)
            var invariable = Set<InstIR>()
            
            func check(_ inst: InstIR) -> Bool {
                if !inst.isCritical && !(inst is PhiInst) || inst is LoadInst {
                    let ret = inst.operands.filter({ (op) in
                        if let i = op as? InstIR {
                            return loop.blocks.contains(i.inBlock) && !invariable.contains(i)
                        } else {
                            return false
                        }
                    }).isEmpty
//                    print("check", inst.toPrint, ret)
                    if inst is LoadInst {
                        for blk in loop.blocks {
                            for i in blk.insts {
                                if i is CallInst {
                                    let f = (i as! CallInst).function
                                    if !IRBuilder.Builtin.functions.values.contains(f) {
                                        return false
                                    }
                                } else if i is StoreInst && aa.mayAlias(p: inst[0], q: i[1]) {
//                                    print("check load", inst, i.toPrint)
                                    return false
                                }
                            }
                        }
                    }
                    return ret
                } else {
                    return false
                }
            }
            
            for blk in loop.blocks {
//                print(" ", blk.name, blk.insts.count)
                for inst in blk.insts where check(inst) {
                    invariable.insert(inst)
                }
            }
            
            var workList = invariable
            while let cur = workList.popFirst() {
                for u in cur.users {
                    if let inst = u.user as? InstIR, check(inst) {
                        if !invariable.contains(inst) {
                            workList.insert(inst)
                            invariable.insert(inst)
                        }
                    }
                }
            }
            
            var toHoist = [BlockIR: [InstIR]]()
            for inv in invariable {
                if !inv.isCritical {
                    if toHoist[inv.inBlock] == nil {
                        toHoist[inv.inBlock] = []
                    }
                    toHoist[inv.inBlock]!.append(inv)
                } else if inv is LoadInst {
                    var flag = true
                    for blk in loop.blocks {
                        for i in blk.insts where i is StoreInst && aa.mayAlias(p: inv[0], q: i[1]) {
                            flag = false
                        }
                    }
                    if flag {
                        if toHoist[inv.inBlock] == nil {
                            toHoist[inv.inBlock] = []
                        }
                        toHoist[inv.inBlock]!.append(inv)
                    }
                }
            }
            
            if !toHoist.isEmpty {
//                print("LOOP", loop.header, loop.blocks)
                hoist(ins: toHoist, in: loop)
            }
            
        }
        
    }
    
}
