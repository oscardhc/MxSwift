//
//  RegToMem.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/4/8.
//

import Foundation

class RegToMem: FunctionPass {
    
    override func visit(v: Function) {
        
        v.calPreds()
        for b in v.blocks where b.insts.first! is PhiInst {
            for p in b.preds where p.succs.count > 1 {
                print("!!!", b.name, p.name)
                let split = BasicBlock(curfunc: v)
                
                b.users.filter({
                    if let br = $0.user as? BrInst {
                        return br.inBlock === p
                    }
                    return false
                })[0].reconnect(fromValue: split)
                
                BrInst(des: b, in: split)
                
                b.insts.first!.usees.filter({
                    $0.value === p
                })[0].reconnect(fromValue: split)
            }
        }
        
        v.calPreds()
        for b in v.blocks where b.insts.first! is PhiInst {
            let phis = b.insts.filter({$0 is PhiInst})
            
            for p in b.preds {
                
            }
            
        }
    
    }
    
}
