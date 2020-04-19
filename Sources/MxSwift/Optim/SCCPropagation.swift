//
//  SCCPropagation.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/25.
//

import Foundation

class SCCPropagation: FunctionPass {
    
    var instRemoved = 0, branchChanged = 0
    override var resultString: String {super.resultString + "\(instRemoved) inst(s) removed, \(branchChanged) branch(es) changed."}
    
    var workList = [InstIR](), blockList = [BlockIR]()
    
    override func work(on v: Module) {
        visit(v: v)
        DeadCleaner().work(on: v)
        print(resultString)
    }
    
    override func visit(v: FunctionIR) {
        //        each edge will only be evaluated ONCE, because the first time always have the highest lattice.
        
        workList.removeAll(); blockList.removeAll();
        
        func tryExecute(t: BlockIR) {
            if !t.reachable {
                t.reachable = true
                blockList.append(t)
                for u in t.users where u.user is PhiInst {
                    workList.append(u.user as! InstIR)
                }
            }
        }
        
        v.operands.forEach {$0.ccpInfo = Value.CCPInfo(type: .variable)}
        for blk in v.blocks {
            blk.reachable = false
            blk.insts.forEach {$0.ccpInfo = Value.CCPInfo()}
        }
        
        tryExecute(t: v.blocks.first!)
        
        while !workList.isEmpty || !blockList.isEmpty {
            if !blockList.isEmpty {
                let b = blockList.removeFirst()
                for i in b.insts {
                    workList.append(i)
                }
            }
            if !workList.isEmpty {
                let i = workList.removeFirst()
                if !i.inBlock.reachable {
                    continue
                }
                if let b = i as? BrInst {
                    if b.operands.count == 1 {
                        tryExecute(t: b[0] as! BlockIR)
                    } else {
                        if let v = b[0].ccpInfo.constValue {
                            tryExecute(t: b[v == 1 ? 1 : 2] as! BlockIR)
                        } else {
                            tryExecute(t: b[1] as! BlockIR)
                            tryExecute(t: b[2] as! BlockIR)
                        }
                    }
                } else {
                    let last = i.ccpInfo
                    if last.type == .variable {
                        continue
                    }
                    i.propogate()
                    if !(last == i.ccpInfo) {
                        for u in i.users {
                            workList.append(u.user as! InstIR)
                        }
                    }
                }
            }
        }
        
        for b in v.blocks {
            for i in b.insts where i.ccpInfo.type == .int {
                instRemoved += 1
                i.replaced(by: IntC(type: i.type, value: i.ccpInfo.int!))
            }
            if b.insts.last! is BrInst && b.insts.last!.operands[0] is IntC {
                
                branchChanged += 1
                let toDel = (b.insts.last!.operands[0] as! IntC).value == 0
                    ? b.insts.last!.usees[1]
                    : b.insts.last!.usees[2]
                
                print(">", b.name, b.insts.last!.toPrint, "|", toDel.value.name, "|", b.insts.last!.usees)
                for i in (toDel.value as! BlockIR).insts {
                    if let p = i as? PhiInst {
                        print(">>", p.toPrint)
                        for i in 0..<p.operands.count/2 {
                            if p.operands[i*2 + 1] === b {
                                p.usees[i*2 + 1].disconnect()
                                p.usees[i*2].disconnect()
                                break
                            }
                        }
                    } else {
                        break
                    }
                }
                print("toDEL", toDel.value, toDel.user.toPrint, toDel.user === b.insts.last!)
                toDel.disconnect()
                print("toDEL", b.insts.last!.usees[0].value, b.insts.last!.usees[0].user.toPrint)
                b.insts.last!.usees[0].disconnect()
            }
        }
        
        for b in v.blocks { for i in b.insts where i is PhiInst && i.operands.count <= 2 {
            i.replaced(by: i[0])
        }}
        
    }
    
}
