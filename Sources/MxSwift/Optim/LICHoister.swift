//
//  LICHoister.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/27.
//

import Foundation

class Loop {
    var header: BlockIR
    var blocks = Set<BlockIR>()
    
    init (h: BlockIR) {
        self.header = h
    }
}

class LoopInfo {
    
    var tree: DomTree!
    var loops = [Loop]()
    
    init(v: FunctionIR) {
        tree = DomTree(function: v)
        v.calPreds()
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
    }
    
    func getDepth(for b: BlockIR) -> Int {
        loops.filter({$0.blocks.contains(b)}).count
    }
    
}

class LICHoister: FunctionPass {
    
    let aa: PTAnalysis
    var tree: DomTree!
    var loops: [Loop]!
    var toSplit = [(BlockIR, BlockIR)]()
    var toCreateHeader = [(BlockIR, [BlockIR])]()
    
    private var instRemoved = 0
    override var resultString: String {super.resultString + "\(instRemoved) inst(s) removed."}
    
    init(_ aa: PTAnalysis) {
        self.aa = aa
    }
    
    func hoist(ins: [BlockIR: [InstIR]], in loop: Loop) {
        let preds = loop.header.preds.filter({!loop.blocks.contains($0)})
        if preds.count == 1 {
            let p = preds[0]
            if p.succs.count > 1 {
                toSplit.append((loop.header, p))
            } else {
                print("hoist", ins, loop.header, preds)
                print("     ", p, "~~~", loop.blocks)
                func hoist(cur: DomTree.Node) {
                    if var ii = ins[cur.block!] {
                        ii.sort(by: {$0.blockIndexBF < $1.blockIndexBF})
                        instRemoved += ii.count
                        for i in ii {
                            print(">>>", i.toPrint, p, p.insts.joined() {"\($0.operation)"})
                            i.changeAppend(to: p)
                            i.prevInst?.changeAppend(to: p)
                            print("<<<", p, p.insts.joined() {"\($0.operation)"})
                        }
                    }
                    for son in cur.domSons where loop.blocks.contains(son.block!) {
                        hoist(cur: son)
                    }
                }
                hoist(cur: tree[loop.header])
            }
        } else {
            print("FAILED!!!!", loop.header, preds)
            print("          ", loop.blocks)
            toCreateHeader.append((loop.header, preds))
        }
    }
    
    override func visit(v: FunctionIR) {
        
        let info = LoopInfo(v: v)
        (tree, loops) = (info.tree, info.loops)
            
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
                hoist(ins: toHoist, in: loop)
            }
            
        }
        
        if !toSplit.isEmpty || !toCreateHeader.isEmpty {
            for (b, p) in toSplit {
                CESplit.createSingleFather(block: b, father: p)
            }
            var done = Set<BlockIR>()
            for (b, outp) in toCreateHeader {
                if done.contains(b) {
                    continue
                } else {
                    done.insert(b)
                }
                v.calPreds()
                let header = BlockIR(curfunc: v)
                for p in outp {
                    print(p, p.succs, b)
                    b.users.filter({
                        if let br = $0.user as? BrInst {
                            return br.inBlock === p
                        }
                        return false
                    })[0].reconnect(fromValue: header)
                }
                BrInst(des: b, in: header)
            }
            toCreateHeader.removeAll()
            toSplit.removeAll()
            visit(v: v)
        }
        
    }
    
}
