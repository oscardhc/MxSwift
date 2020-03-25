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
            let c = IntC(name: "", type: .int, value: -counter.tikInt())
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
            for b in f.blocks {
                for i in b.insts {
                    switch i {
                    case is LoadInst:
                        loads[i.operands[0]]!.insert(i)
                    case is StoreInst:
                        if !(i.operands[0] is Const) {
                            stores[i.operands[1]]!.insert(i.operands[0])
                        }
                    case is GEPInst, is CastInst:
//                        print("GEP/Cast", i.operands[0], "->", i)
                        graph[i.operands[0]]!.insert(i)
                    case is PhiInst:
//                        print("PHI", i.operands.joined())
                        for j in 0..<i.operands.count/2 where !(i.operands[j*2] is Const) {
                            graph[i.operands[j*2]]!.insert(i)
                        }
                    case is AllocaInst:
                        pts[i]!.insert(getNewAddr())
                    case let c as CallInst:
                        if IRBuilder.Builtin.functions.values.contains(c.function) {
                            if c.function.basename == "malloc" {
                                pts[i]!.insert(getNewAddr())
                            }
                        } else {
                            for (formal, actual) in zip(c.function.operands, c.operands) where !(actual is Const) {
                                graph[actual]!.insert(formal)
                            }
                        }
                    case is ReturnInst:
                        for u in i.users {
                            let call = u.user as! CallInst
                            graph[i]!.insert(call)
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
//                let prevCount = pts[q]!.count
//                pts[q]!.formUnion(pts[cur]!)
//                if pts[q]!.count > prevCount {
//                    workList.insert(q)
//                }
            }
        }
        
    }
    
}

class LSElimination: FunctionPass {
    
    let aa: PTAnalysis
    var domTree: DomTree!
    var reachable = [Inst: Set<Inst>]()
    
    private var instRemoved = 0
    override var resultString: String {super.resultString + "\(instRemoved) inst(s) removed."}
    
    init(_ aa: PTAnalysis) {
        self.aa = aa
    }
    
    func getAllDominated(from: Inst, where check: (Inst) -> Bool) -> [Inst] {
        var ret = [Inst]()
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
    
    override func visit(v: Function) {
        
        domTree = DomTree(function: v)
        
        func lse(n: BaseDomTree.Node) {
            for i in n.block!.insts where i is LoadInst && i.operands.count > 0 {
//                print("check", i.toPrint)
                let stores = getAllDominated(from: i) {$0 is StoreInst}
                let loads = getAllDominated(from: i) {$0 is LoadInst && $0.operands[0] == i.operands[0]}
                var unavai = Set<Inst>(), workList = [Inst]()
                for s in stores where aa.mayAlias(p: s.operands[1], q: i.operands[0]) {
                    unavai.insert(s.nextInst)
                    workList.append(s.nextInst)
                }
                while let v = workList.popLast() {
                    switch v {
                    case is ReturnInst:
                        break
                    case is BrInst:
                        for o in v.operands {
                            if let b = o as? BasicBlock, domTree.checkBF(i.inBlock, dominates: b), !unavai.contains(b.insts.first!) {
                                unavai.insert(b.insts.first!)
                                workList.append(b.insts.first!)
                            }
                        }
                    default:
                        if !unavai.contains(v.nextInst) {
                            unavai.insert(v.nextInst)
                            workList.append(v.nextInst)
                        }
                    }
                }
                for l in loads where !unavai.contains(l) {
                    print(">", l.toPrint)
                    l.replaced(by: i)
                    instRemoved += 1
                }
            }
            for p in n.domSons {lse(n: p)}
        }
        
        lse(n: domTree.root)
        
    }
}
