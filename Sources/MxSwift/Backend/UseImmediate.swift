//
//  UseImmediate.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/4/17.
//

import Foundation

class UseImmediate {
    
    func work(on v: Assmebly) {
        for f in v.functions where !f.blocks.isEmpty {
            visit(v: f)
        }
    }
    
    let op: [InstRV.OP: InstRV.OP] = {
        var ret = [InstRV.OP: InstRV.OP]()
        for (a, b) in InstSelect.aop.values where b != nil {
            ret[a] = b!
        }
        for (a, b) in InstSelect.cop.values where b != nil {
            ret[a] = b!
        }
        return ret
    }()
    
    func visit(v: FunctionRV) {
        for b in v.blocks {
            for i in b.insts where i.op == .addi && i[0] === RV32["zero"] {
                let val = (i[1] as! Imm).value
                for u in i.dst!.uses {
                    if let iver = op[u.op] {
                        if u[1] === i.dst {
//                            print(i, u, iver)
                            u.op = iver
                            u.newSrc(Imm(val), at: 1)
                        }
                    }
                }
            }
        }
    }
    
}
