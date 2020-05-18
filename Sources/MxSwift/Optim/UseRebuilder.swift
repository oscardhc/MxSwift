//
//  UseRebuilder.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/4/8.
//

import Foundation

class UseRebuilder: ModulePass {
    
    override func work(on v: Module) {
        visit(v: v)
    }
    
    override func visit(v: Module) {
        
        for g in v.globalVar {
            g.users.removeAll()
        }
        for f in v.functions {
            for b in f.blocks {
                b.users.removeAll()
                for i in b.insts {
                    i.users.removeAll()
                }
            }
        }
        for f in v.functions {
            for b in f.blocks {
                for i in b.insts {
//                    print("assert", f.name, i.toPrint, i.usees.count, i.operands.count, i.operands.joined())
                    assert(i.usees.count == i.operands.count)
                    let ops = [Value](i.operands)
                    i.usees.removeAll()
                    i.operands.removeAll()
                    for op in ops {
                        i.added(operand: op)
                    }
                }
            }
        }
        
    }
    
}
