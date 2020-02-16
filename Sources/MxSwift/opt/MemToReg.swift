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
        print(users.joined(with: "\n", method: {$0.toPrint}))
        for _u in users {
            switch _u {
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
        
        for ai in toPromote {
            if ai.users.count == 0 {
                ai.node?.remove()
            }
        }
        
    }
    
}
