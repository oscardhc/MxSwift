//
//  MemToReg.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/16.
//

import Foundation

extension AllocaInst {
    func promotable() -> Bool {
        for _u in users {
            switch _u.user {
            case is LoadInst:
                break
            case let i as StoreInst:
                if i[0] === self {
                    return false
                }
            default:
                return false
            }
        }
        return true
    }
}

class MemToReg: FunctionPass {
    
    override init() {
        super.init()
    }
    
    var instRemoved = 0
    override var resultString: String {super.resultString + "\(instRemoved) inst(s) removed."}
    
    override func visit(v: IRFunction) {
        let toPromote = List<AllocaInst>()
        let insts = v.blocks.first!.insts
        
        for inst in insts {
            if let ai = inst as? AllocaInst {
                if ai.promotable() {
                    _ = toPromote.append(ai)
                }
            }
        }
        instRemoved += toPromote.count
        
        let tree = DomTree(function: v)
        var phiToAlloc = [PhiInst: AllocaInst]()
        
        for ai in toPromote {
            
            if ai.users.count == 0 {
                ai.disconnect(delUsee: true, delUser: true)
                toPromote.removeNodeBF(where: {$0 === ai})
                continue
            }
            
            let loads = List<Use>(), stores = List<Use>()
            var allBlock: BlockIR? = nil
            var allInOneBlock = false
            
//            prepare for loads and stores
            for use in ai.users {
                let block = (use.user as! InstIR).inBlock
                if allBlock == nil {
                    allBlock = block
                    allInOneBlock = true
                } else if allBlock !== block {
                    allInOneBlock = false
                }
                switch use.user {
                case is LoadInst:
                    _ = loads.append(use)
                case is StoreInst:
                    _ = stores.append(use)
                default:
                    assert(false, "????????????")
                    break
                }
            }
            
//            S: [0]value [1]address
//            a: alloc  s: store  v: value to Store  l: load  u: use load value
            if stores.count == 1 {
                let a2s = stores[0], s = a2s.user as! StoreInst, v2s = s.usees[0], v = v2s.value
                let sIndex = s.inBlock.insts.findNodeBF(where: {$0 === s})!
                // check for usage domination
                var canNotHandleLoads = [Use]()
                for a2l in loads {
                    let l = a2l.user as! LoadInst
//                    print("CHECKING LOADS....", l.inBlock, s.inBlock)
                    if v is GlobalVariable {
                        
                    } else if l.inBlock === s.inBlock {
                        // in the same block
                        if sIndex.1 > l.inBlock.insts.findNodeBF(where: {$0 === l})!.1 {
                            canNotHandleLoads.append(a2l)
                            continue
                        }
                    } else if !tree.checkBF(s.inBlock, dominates: l.inBlock) {
                        // not in the dominated block, cannot handle
                        canNotHandleLoads.append(a2l)
                        continue
                    }
                    assert(v !== l, "load from itself!")
                    l.replaced(by: v)
                }
                
                if canNotHandleLoads.isEmpty {
                    s.disconnect(delUsee: true, delUser: false)
                    ai.disconnect(delUsee: true, delUser: false)
                    toPromote.removeNodeBF(where: {$0 === ai})
                    continue
                }
            }
            
            if allInOneBlock {
                
                var success = true
                for a2l in loads {
                    let l = a2l.user as! LoadInst, linfo = allBlock!.insts.findNodeBF(where: {$0 === l})!
                    let nearestStore = allBlock!.insts.findPrevBF(from: linfo.0) {
                        $0 is StoreInst && $0[1] === ai
                    }
                    
                    if let s = nearestStore?.value as? StoreInst {
                        let v = s[0]
                        l.replaced(by: v)
                    } else {
                        // undefined loads, should not occur, just in case
                        success = false
                        break
                    }
                    
                }
                
                if success {
                    for a2s in stores {
                        (a2s.user as! StoreInst).disconnect(delUsee: true, delUser: false)
                    }
                    ai.disconnect(delUsee: true, delUser: false)
                    toPromote.removeNodeBF(where: {$0 === ai})
                }
            }
            
            var oriBlocks = Set<BlockIR>(), workList = Set<BlockIR>(), phiBlocks = Set<BlockIR>()
            stores.forEach {oriBlocks.insert(($0.user as! StoreInst).inBlock)}
            oriBlocks.forEach {workList.insert($0)}
            
//            warning: complexity N^2
            while !workList.isEmpty {
                let cur = workList.popFirst()!
                
                for frontier in tree[cur].domFrontiers {
                    let frt = frontier.block!
                    if !phiBlocks.contains(frt) {
                        phiBlocks.insert(frt)
                        let phi = PhiInst(name: ai.originName == "" ? "" : ai.originName + ".", type: ai.type.getBase, in: frt, at: 0)
                        phiToAlloc[phi] = ai
                        
                        for pre in tree[frt].antiEdge {
                            phi.added(operand: IntC.zero())
                            phi.added(operand: pre.block!)
                        }
                        
                        if !oriBlocks.contains(frt) {
                            workList.insert(frt)
                        }
                    }
                }
            }
            
        }

        var stack = [Value: [Value]]() // 1st is actually AllocInst, 2nd is actually Phi or value to Store
        for ai in toPromote {
            stack[ai] = [ai.type.getBase is IntT ? IntC.minusOne() : NullC()]
        }
        
        func rename(cur: DomTree.Node) {
            var changed = [Value]()
            for i in cur.block!.insts {
                switch i {
                case let l as LoadInst:
                    if let v = stack[l[0]]?.last {
                        l.replaced(by: v) // promotable
                    }
                case let s as StoreInst:
                    if stack[s[1]] != nil {
                        changed.append(s[1])
                        stack[s[1]]!.append(s[0])
                        s.disconnect(delUsee: true, delUser: true)
                    }
                case let p as PhiInst:
                    let ai = phiToAlloc[p]!
                    changed.append(ai)
                    stack[ai]!.append(p)
                default:
                    break
                }
            }
            for suc in cur.edge {
                let idx = suc.antiEdge.findNodeBF(where: {$0 === cur})!.1
                for i in suc.block!.insts {
                    if let p = i as? PhiInst {
                        p.usees[idx * 2].reconnect(fromValue: stack[phiToAlloc[p]!]!.last!)
                    }
                }
            }
            for son in cur.domSons {
                rename(cur: son)
            }
            for chg in changed {
                _ = stack[chg]!.popLast()
            }
        }
        rename(cur: tree.root)
        
        for ai in toPromote {
            ai.disconnect(delUsee: true, delUser: false)
        }
        
    }
}

