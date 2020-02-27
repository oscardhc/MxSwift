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
    
    override func visit(v: Function) {
        //        each edge will only be evaluated ONCE, because the first time always have the highest lattice.
        
        var workList = [Inst](), blockList = [BasicBlock]()
        v.blocks.forEach {$0.executable = false}
        
        func tryExecute(t: BasicBlock) {
            if !t.executable {
//                print("EXE", t.name)
                t.executable = true
                blockList.append(t)
                for u in t.users where u.user is PhiInst {
                    workList.append(u.user as! Inst)
                }
            }
        }
        
        v.operands.forEach {$0.ccpInfo = Value.CCPInfo(type: .variable)}
        
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
                if !i.inBlock.executable {
                    continue
                }
//                print(">", i.inBlock.name, i.toPrint, i.ccpInfo)
                if let b = i as? BrInst {
                    if b.operands.count == 1 {
                        tryExecute(t: b.operands[0] as! BasicBlock)
                    } else {
                        if let v = b.operands[0].ccpInfo.constValue {
                            tryExecute(t: b.operands[v == 1 ? 1 : 2] as! BasicBlock)
                        } else {
                            tryExecute(t: b.operands[1] as! BasicBlock)
                            tryExecute(t: b.operands[2] as! BasicBlock)
                        }
                    }
                } else {
                    let last = i.ccpInfo
                    if last.type == .variable {
                        continue
                    }
                    i.propogate()
//                    print("  >", i.ccpInfo)
                    if !(last == i.ccpInfo) {
//                        for u in i.users where (u.user as! Inst).inBlock.executable {
                        for u in i.users {
//                            print("    >", u.user.name)
                            workList.append(u.user as! Inst)
                        }
                    }
                }
            }
        }
        
        for b in v.blocks {
            for i in b.insts where i.ccpInfo.type == .int {
                instRemoved += 1
                i.replaced(by: IntC(name: "", type: i.type, value: i.ccpInfo.int!))
            }
            if b.insts.last! is BrInst && b.insts.last!.operands[0] is IntC {
                branchChanged += 1
                let toDel = (b.insts.last!.operands[0] as! IntC).value == 0
                    ? b.insts.last!.usees[1]
                    : b.insts.last!.usees[2]
                for i in (toDel.value as! BasicBlock).insts {
                    if let p = i as? PhiInst {
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
                toDel.disconnect()
                b.insts.last!.usees[0].disconnect()
            }
        }
        
        for b in v.blocks { for i in b.insts where i is PhiInst && i.operands.count <= 2 {
            let v = i.operands[0]
            i.replaced(by: v)
        }}
        
    }
    
}
