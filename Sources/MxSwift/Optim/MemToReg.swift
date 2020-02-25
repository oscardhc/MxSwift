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
                if i.operands[0] === self {
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
    
    override func visit(v: Function) {
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
        
        let domTree = DomTree(function: v)
        var allocToPhi = [Tuple<Value, Value>: PhiInst](), phiToAlloc = [PhiInst: AllocaInst]()
        
        for ai in toPromote {
            
            if ai.users.count == 0 {
                ai.disconnect(delUsee: true, delUser: true)
                toPromote.removeNodeBF(where: {$0 === ai})
                continue
            }
            
            let loads = List<Use>(), stores = List<Use>()
            var allBlock: BasicBlock? = nil
            var allInOneBlock = false
            
//            prepare for loads and stores
            for use in ai.users {
                let block = (use.user as! Inst).inBlock
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
                    } else if !domTree.checkBF(s.inBlock.domNode!, dominates: l.inBlock.domNode!) {
                        // not in the dominated block, cannot handle
                        canNotHandleLoads.append(a2l)
                        continue
                    }
                    assert(v !== l, "load from itself!")
                    l.replacedBy(value: v)
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
                        $0 is StoreInst && $0.operands[1] === ai
                    }
                    
                    if let s = nearestStore?.value as? StoreInst {
                        let v = s.operands[0]
                        l.replacedBy(value: v)
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
            
            var oriBlocks = Set<BasicBlock>(), workList = Set<BasicBlock>(), phiBlocks = Set<BasicBlock>()
            stores.forEach {oriBlocks.insert(($0.user as! StoreInst).inBlock)}
            oriBlocks.forEach {workList.insert($0)}
            
//            warning: complexity N^2
            while !workList.isEmpty {
                let cur = workList.popFirst()!
                
                for frontier in cur.domNode!.domFrontiers {
                    let frt = frontier.block!
                    if !phiBlocks.contains(frt) {
                        phiBlocks.insert(frt)
                        let phi = PhiInst(name: ai.originName + ".", type: ai.type.getBase, in: frt, at: 0)
                        allocToPhi[ai.pairWithValue(frt)] = phi
                        phiToAlloc[phi] = ai
                        
                        for pre in frt.domNode!.antiEdge {
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

        domTree.variableRenaming(aiList: toPromote, phiToAlloc: phiToAlloc)
        for ai in toPromote {
            ai.disconnect(delUsee: true, delUser: false)
        }
        
    }
}

