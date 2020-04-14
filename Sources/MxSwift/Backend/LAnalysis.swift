//
//  LAnalysis.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/4/13.
//

import Foundation

class LAnalysis {
    
    func work(on v: Assmebly) {
        for f in v.functions {
            visit(v: f)
        }
    }
    
    func visit(v: FunctionRV) {
        for b in v.blocks {
            for i in b.insts {
                i.ii.removeAll()
                i.oo.removeAll()
            }
        }
        var changed = true
        var instList = [InstRV]()
        for b in v.blocks.reversed() {
            for i in b.insts.reversed() {
                instList.append(i)
            }
        }
        while changed {
            changed = false
//            print("LA iteration")
            for i in instList {
                for s in i.succs {
                    for tmp in s.ii where !i.oo.contains(tmp) {
                        changed = true
                        i.oo.insert(tmp)
                    }
                }
                for tmp in i.oo.subtracting(i.def).union(i.use) where !i.ii.contains(tmp) {
                    changed = true
                    i.ii.insert(tmp)
                }
            }
        }
        for b in v.blocks {
            for i in b.insts {
                print(i, ":")
                print("   in", i.ii)
                print("  out", i.oo)
            }
        }
    }
//    func visit(v: FunctionRV) {
//        for b in v.blocks {
//            b.gen.removeAll()
//            b.kill.removeAll()
//            for i in b.insts {
//                b.gen.formUnion(Set<Register>(i.use).subtracting(b.kill))
//                b.kill.formUnion(i.def)
//            }
//        }
//        var changed = true
//        while changed {
//            changed = false
//            print("LA iteration")
//            for b in v.blocks {
//                for s in b.succs {
//                    for tmp in s.ii where !b.oo.contains(tmp) {
//                        changed = true
//                        b.oo.insert(tmp)
//                    }
//                }
//                for tmp in b.oo.subtracting(b.kill).union(b.gen) where !b.ii.contains(tmp) {
//                    changed = true
//                    b.ii.insert(tmp)
//                }
//            }
//        }
//        for b in v.blocks {
//            print(b, b.ii, b.oo)
//        }
//    }
}
