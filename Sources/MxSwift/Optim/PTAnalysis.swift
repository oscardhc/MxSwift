//
//  PTAnalysis.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/3/12.
//

import Foundation

class PTAnalysis: FunctionPass {
    
    private var instRemoved = 0
    override var resultString: String {super.resultString + "\(instRemoved) inst(s) removed."}
    
    var graph   = [Value: Set<Value>]()
    var pts     = [Value: Set<Value>]()
    var loads   = [Value: Set<Value>]()
    var stores  = [Value: Set<Value>]()
    var workList = [Value]()
    
    private func getAllPointing(cur: Value) -> Set<Value> {
        var ret = Set<Value>()
        for t in graph[cur]! {
            ret.formUnion(getAllPointing(cur: t))
        }
        return ret
    }
    
    func mayAlias(p: Value, q: Value) -> Bool {
        let pp = getAllPointing(cur: p)
        let qq = getAllPointing(cur: q)
        let uu = pp.intersection(qq)
        return uu.count > 0
    }
    
    override func visit(v: Function) {
        graph   .removeAll()
        pts     .removeAll()
        loads   .removeAll()
        stores  .removeAll()
        workList.removeAll()
        
        for b in v.blocks {
            for i in b.insts {
                switch i {
                case is LoadInst:
                    loads[i.operands[0]]!.insert(i)
                case is StoreInst:
                    stores[i.operands[1]]!.insert(i.operands[0])
                case is GEPInst:
                    graph[i.operands[0]]!.insert(i)
                default:
                    break
                }
            }
        }
        
        while let cur = workList.popLast() {
            for a in pts[cur]! {
                loads[cur]! .forEach {graph[a]!.insert($0)}
                stores[cur]!.forEach {graph[$0]!.insert(a)}
            }
            for q in graph[cur]! {
                pts[q]! = pts[q]!.union(pts[v]!)
            }
        }
        
    }
    
}
