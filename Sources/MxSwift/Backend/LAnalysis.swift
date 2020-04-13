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
//    var ii = [InstRV: Set<Register>]()
//    var oo = [InstRV: Set<Register>]()
//    func visit(v: FunctionRV) {
//        ii.removeAll()
//        oo.removeAll()
//        for b in v.blocks {
//            for i in b.insts {
//                ii[i] = []
//                oo[i] = []
//            }
//        }
//        var changed = true
//        while changed {
//            changed = false
//            print("LA iteration")
//            for b in v.blocks {
//                for i in b.insts {
//                    for s in i.succs {
//                        for tmp in ii[s]! where !oo[i]!.contains(tmp) {
//                            changed = true
//                            oo[i]!.insert(tmp)
//                        }
//                    }
//                    for tmp in oo[i]!.subtracting(i.def).union(i.use) where !ii[i]!.contains(tmp) {
//                        changed = true
//                        ii[i]!.insert(tmp)
//                    }
//                }
//            }
//        }
//        for b in v.blocks {
//            for i in b.insts {
//                print(i, ":", ii[i]!, oo[i]!)
//                print("   succs", i.succs)
//            }
//        }
//    }
    func visit(v: FunctionRV) {
        
        for b in v.blocks {
            b.gen.removeAll()
            b.kill.removeAll()
            for i in b.insts {
                b.gen.formUnion(Set<Register>(i.use).subtracting(b.kill))
                b.kill.formUnion(i.def)
            }
        }
        var changed = true
        while changed {
            changed = false
            print("LA iteration")
            for b in v.blocks {
                for s in b.succs {
                    for tmp in s.ii where !b.oo.contains(tmp) {
                        changed = true
                        b.oo.insert(tmp)
                    }
                }
                for tmp in b.oo.subtracting(b.kill).union(b.gen) where !b.ii.contains(tmp) {
                    changed = true
                    b.ii.insert(tmp)
                }
            }
        }
        for b in v.blocks {
            print(b, b.ii, b.oo)
        }
    }
}
