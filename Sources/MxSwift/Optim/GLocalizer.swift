//
//  GLocalizer.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/5/1.
//

import Foundation

class GLocalizer: ModulePass {

    var usedFunc = [GlobalVariable: Set<FunctionIR>]()
    
    override func visit(v: Module) {
        
        for g in v.globalVar {usedFunc[g] = Set<FunctionIR>()}
        
        for f in v.functions {
            for b in f.blocks {
                for i in b.insts {
                    for o in i.operands where o is GlobalVariable {
                        usedFunc[o as! GlobalVariable]!.insert(f)
                    }
                }
            }
        }
        for (val, fs) in usedFunc where fs.count == 1 {
            if val.type.getBase is IntT {
                let f = fs.first!
                let a = AllocaInst(name: val.basename + "_promoted", forType: .int, in: f.blocks.first!, at: 0)
                for u in val.users {
                    u.reconnect(fromValue: a)
                }
                v.globalVar.removeAll(where: {$0 === val})
                assert(val.users.isEmpty)
            }
            
        }
        
        for f in v.functions {
            for b in f.blocks {
                for i in b.insts {
                    if let c = i as? CallInst {
                        if c.function === IRBuilder.Builtin.functions["print"]!, let cc = c[0] as? CallInst {
                            if cc.function === IRBuilder.Builtin.functions["toString"]! {
                                c.function = IRBuilder.Builtin.functions["printInt"]!
                                c.usees[0].reconnect(fromValue: cc[0])
                            } else if cc.function === IRBuilder.Builtin.functions["_str_add"]! {
                                CallInst(function: IRBuilder.Builtin.functions["print"]!, in: b, at: c.blockIndexBF - 1).added(operand: cc[0])
                                cc.replaced(by: cc[1])
                            }
                        } else if c.function === IRBuilder.Builtin.functions["println"]!, let cc = c[0] as? CallInst {
                            if cc.function === IRBuilder.Builtin.functions["toString"]! {
                                c.function = IRBuilder.Builtin.functions["printlnInt"]!
                                c.usees[0].reconnect(fromValue: cc[0])
                            } else if cc.function === IRBuilder.Builtin.functions["_str_add"]! {
                                CallInst(function: IRBuilder.Builtin.functions["print"]!, in: b, at: c.blockIndexBF - 1).added(operand: cc[0])
                                cc.replaced(by: cc[1])
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    
}
