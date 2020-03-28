//
//  TruncateTerminal.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/18.
//

import Foundation

class DeadCleaner: FunctionPass {
    
    override func work(on v: Module) {
        visit(v: v)
    }
    
    override func visit(v: Function) {
        
        for blk in v.blocks {
            var term = false
            for i in blk.insts {
                if term {
                    i.disconnect(delUsee: true, delUser: true)
                } else if i.isTerminate {
                    term = true
                }
            }
        }
        
        var live = Set<BasicBlock>([v.blocks.first!]), workList = [v.blocks.first!]
        
//        print("_____", v.name, "_____")
        while let b = workList.popLast() {
            for s in b.succs where !live.contains(s) {
//                print(b.name, "->", s.name)
                live.insert(s)
                workList.append(s)
            }
        }
        
        for b in v.blocks {
            if !live.contains(b) {
                print(">>>>>>", b.name, b.users.joined() {$0.user.name})
                for u in b.users {
                    if u.user is PhiInst {
                        for i in 0..<u.user.operands.count/2 where u.user[i*2+1] === b {
                            u.user.usees[i*2+1].disconnect()
                            u.user.usees[i*2].disconnect()
                            break
                        }
                    } else if u.user.operands.count > 1 {
                        if u.user[1] === b {
                            u.user.usees[1].disconnect()
                        } else {
                            u.user.usees[2].disconnect()
                        }
                        u.user.usees[0].disconnect()
                    }
                }
                b.remove {
                    $0.disconnect(delUsee: true, delUser: true)
                }
            } else if b.insts.isEmpty || !b.insts.last!.isTerminate {
                let a = AllocaInst(name: "", forType: v.type, in: b)
                let l = LoadInst(name: "", alloc: a, in: b)
                ReturnInst(name: "", val: l, in: b)
            }
        }
        
    }
}
