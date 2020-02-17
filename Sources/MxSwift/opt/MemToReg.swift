//
//  MemToReg.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/16.
//

import Foundation

extension AllocaInst {
    func promotable() -> Bool {
        print("")
        print(toPrint, ":")
        print(users.joined(with: "\n", method: {$0.user.toPrint}))
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
        print("ok!")
        return true
    }
}

class MemToReg: FunctionPass {
    
    override init() {
        super.init()
    }
    
    private func analyze(ai: AllocaInst) {
        
    }
    
    override func visit(v: Function) {
        
        let toPromote = List<AllocaInst>()
        let insts = v.blocks.first!.inst
        
        for inst in insts {
            if let ai = inst as? AllocaInst {
                if ai.promotable() {
                    _ = toPromote.append(ai)
                }
            }
        }
        

        let domTree = DomTree(function: v)
        let postTree = PostDomTree(function: v)
        
        return
        
        for ai in toPromote {
            
            if ai.users.count == 0 {
                ai.disconnect(delUsee: true, delUser: true)
                toPromote.removeNodeBF(where: {$0 === ai})
            }
            
            let loads = List<Use>()
            let stores = List<Use>()
            
            for use in ai.users {
                switch use.user {
                case is LoadInst:
                    _ = loads.append(use)
                case is StoreInst:
                    _ = stores.append(use)
                default:
                    break
                }
            }
            
            // S: [0]value [1]address
            
            // a: alloc  s: store  v: value to Store  l: load  u: use load value
            if stores.count == 1 {
                
                
                
                let a2s = stores[0], s = a2s.user as! StoreInst, v2s = s.usees[0], v = v2s.value
                for a2l in loads {
                    let l = a2l.user as! LoadInst
                    for l2u in l.users {
                        l2u.reconnect(fromValue: v)
                    }
                    l.disconnect(delUsee: true, delUser: false)
                }
                s.disconnect(delUsee: true, delUser: false)
                ai.disconnect(delUsee: true, delUser: false)
            }
            
            if loads.count == 1 {
                
            }
            
        }
        
    }
    
}
