//
//  PTAnalysis.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/3/12.
//

import Foundation

class PTAnalysis: ModulePass {
    
    override func work(on v: Module) {
        IRNumberer().work(on: v)
        super.work(on: v)
    }
    
    var graph   = [Value: Set<Value>]()
    var pts     = [Value: Set<Value>]()
    var loads   = [Value: Set<Value>]()
    var stores  = [Value: Set<Value>]()
    var workList = Set<Value>()
    var callers = [FunctionIR: Set<Value>]()
    
    func mayAlias(p: Value, q: Value) -> Bool {
        let pp = pts[p]!
        let qq = pts[q]!
        let uu = pp.intersection(qq)
        return !uu.isEmpty
    }
    
    func makeEmpty(v: Value) {
        graph[v]    = Set<Value>()
        pts[v]      = Set<Value>()
        loads[v]    = Set<Value>()
        stores[v]   = Set<Value>()
    }
    
    func addEdge(from: Value, to: Value) {
        if !graph[from]!.contains(to) {
            graph[from]!.insert(to)
            workList.insert(from)
        }
    }
    
    override func visit(v: Module) {
        
        let counter = Counter()
        _ = counter.tik()
        func getNewAddr() -> IntC {
            let c = IntC(type: .int, value: -counter.tikInt())
            makeEmpty(v: c)
            return c
        }
        
        for g in v.globalVar {
            makeEmpty(v: g)
        }
        for f in v.functions {
            for o in f.operands {
                makeEmpty(v: o)
            }
            for b in f.blocks {
                for i in b.insts {
                    makeEmpty(v: i)
                }
            }
        }
        
        for f in v.functions {
            callers[f] = []
        }
        for f in v.functions {
            for b in f.blocks {
                for i in b.insts {
                    if let c = i as? CallInst {
                        callers[c.function]!.insert(c)
                    }
                }
            }
        }
        
        for f in v.functions {
            for b in f.blocks {
                for i in b.insts {
                    switch i {
                    case is LoadInst:
                        loads[i[0]]!.insert(i)
                    case is StoreInst:
                        if !(i[0] is ConstIR) {
                            stores[i[1]]!.insert(i[0])
                        }
                    case is GEPInst, is CastInst:
//                        print("GEP/Cast", i[0], "->", i)
                        graph[i[0]]!.insert(i)
                    case is PhiInst:
//                        print("PHI", i.operands.joined())
                        for j in 0..<i.operands.count/2 where !(i[j*2] is ConstIR) {
                            graph[i[j*2]]!.insert(i)
                        }
                    case is AllocaInst:
                        pts[i]!.insert(getNewAddr())
                    case let c as CallInst:
                        if IRBuilder.Builtin.functions.values.contains(c.function) {
                            if c.function.basename == "malloc" {
                                pts[i]!.insert(getNewAddr())
                            }
                        } else {
                            for (formal, actual) in zip(c.function.operands, c.operands) where !(actual is ConstIR) {
                                print("CALL  ", actual, formal)
                                graph[actual]!.insert(formal)
                            }
                        }
                    case is ReturnInst:
                        if !(i[0] is ConstIR) {
                            for call in callers[i.inBlock.inFunction]! {
                                graph[i[0]]!.insert(call)
                                print("RETURN", i.inBlock.inFunction, i[0], call)
                            }
                        }
                    default:
                        break
                    }
                }
            }
        }
        for g in v.globalVar {
            pts[g]!.insert(getNewAddr())
        }
        
        for (key, val) in pts where !val.isEmpty {
//            print("worklist", key, val)
            workList.insert(key)
        }
        
        while let cur = workList.popFirst() {
//            print(workList.count, ">", cur, pts[cur]!, loads[cur]!, stores[cur]!)
            for a in pts[cur]! {
                loads[cur]! .forEach {addEdge(from: a, to: $0)}
                stores[cur]!.forEach {addEdge(from: $0, to: a)}
            }
            for q in graph[cur]! {
                var flag = false
                for nv in pts[cur]! where !pts[q]!.contains(nv) {
                    pts[q]!.insert(nv)
                    flag = true
                }
                if flag {
                    workList.insert(q)
                }
            }
        }
        
    }
    
}

class LSElimination: FunctionPass {
    
    let aa: PTAnalysis
    var domTree: DomTree!
    var reachable = [InstIR: Set<InstIR>]()
    
    private var instRemoved = 0
    override var resultString: String {super.resultString + "\(instRemoved) inst(s) removed."}
    
    init(_ aa: PTAnalysis) {
        self.aa = aa
    }
    
    func getAllDominated(from: InstIR, where check: (InstIR) -> Bool) -> [InstIR] {
        var ret = [InstIR]()
        for i in from.inBlock.insts where check(i) && i.blockIndexBF > from.blockIndexBF {
            ret.append(i)
        }
        func dfs(n: BaseDomTree.Node) {
            for i in n.block!.insts where check(i) {
                ret.append(i)
            }
            for p in n.domSons {dfs(n: p)}
        }
        for p in domTree[from.inBlock].domSons {dfs(n: p)}
        return ret
    }
    
    override func visit(v: FunctionIR) {
        
        domTree = DomTree(function: v)
        
        func lse(n: BaseDomTree.Node) {
            for i in n.block!.insts where i is LoadInst && i.operands.count > 0 {
                let stores = getAllDominated(from: i) {$0 is StoreInst}
                let loads = getAllDominated(from: i) {$0 is LoadInst && $0[0] == i[0]}
                var unavai = Set<InstIR>(), workList = [InstIR]()
                for s in stores where aa.mayAlias(p: s[1], q: i[0]) {
                    unavai.insert(s.nextInst!)
                    workList.append(s.nextInst!)
                }
                let dangerous = v.currentModule.functions.filter {
                    for blk in $0.blocks { for ins in blk.insts where ins is StoreInst {
                        if aa.mayAlias(p: ins[1], q: i[0]) {
                            return true
                        }
                    }}
                    return false
                }
                for c in getAllDominated(from: i, where: {
                    $0 is CallInst && dangerous.contains(($0 as! CallInst).function)
                }) {
                    unavai.insert(c.nextInst!)
                    workList.append(c.nextInst!)
                }
                while let v = workList.popLast() {
                    switch v {
                    case is ReturnInst:
                        break
                    case is BrInst:
                        for o in v.operands {
                            if let b = o as? BlockIR, domTree.checkBF(i.inBlock, dominates: b), !unavai.contains(b.insts.first!) {
                                unavai.insert(b.insts.first!)
                                workList.append(b.insts.first!)
                            }
                        }
                    default:
                        if !unavai.contains(v.nextInst!) {
                            unavai.insert(v.nextInst!)
                            workList.append(v.nextInst!)
                        }
                    }
                }
                for l in loads where !unavai.contains(l) {
                    print(">", v.name, l.toPrint)
                    l.replaced(by: i)
                    instRemoved += 1
                }
            }
            for p in n.domSons {lse(n: p)}
        }
        
        lse(n: domTree.root)
        
    }
}
