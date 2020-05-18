//
//  CESplit.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/4/8.
//

import Foundation

class CESplit: FunctionPass {
    
    let removePhi: Bool
    init(removePhi: Bool) {self.removePhi = removePhi}
    
    static func createSingleFather(block b: BlockIR, father p: BlockIR) {
        let split = BlockIR(curfunc: b.inFunction)
        
        b.users.filter({
            if let br = $0.user as? BrInst {
                return br.inBlock === p
            }
            return false
        })[0].reconnect(fromValue: split)
        
        BrInst(des: b, in: split)
        
        for i in b.insts where i is PhiInst {
            i.usees.filter({
                $0.value === p
            })[0].reconnect(fromValue: split)
        }
    }
    
    override func visit(v: FunctionIR) {
        
        v.calPreds()
        for b in v.blocks where b.insts.first! is PhiInst {
            for p in b.preds where p.succs.count > 1 {
//                print("!!!", b.name, p.name)
                Self.createSingleFather(block: b, father: p)
            }
        }
        
        if removePhi {
            v.calPreds()
            for b in v.blocks where b.insts.first! is PhiInst {
                let phis = b.insts.filter({$0 is PhiInst})
                for p in phis {
                    let pos = AllocaInst(forType: p.type, in: v.blocks.first!, at: 0)
                    for i in 0..<p.operands.count/2 {
                        StoreInst(alloc: pos, val: p[i*2], in: p[i*2+1] as! BlockIR)
                    }
                    p.replaced(by: LoadInst(alloc: pos, in: b, at: 0))
                }
                for pred in b.preds {
                    pred.insts.filter({$0 is BrInst})[0].changeAppend(to: pred)
                }
            }
        }
        
    }
    
}
