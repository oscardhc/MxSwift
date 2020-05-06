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
    var workList = Set<Value>()
    var callers = [FunctionIR: Set<Value>]()
    var allVar = [Value]()
    
    func mayAlias(p: Value, q: Value) -> Bool {
        let uu = p.pts.intersection(q.pts)
        return !uu.isEmpty
    }
    
    func addEdge(from: Value, to: Value) {
        if !from.graph.contains(to) {
            from.graph.insert(to)
            workList.insert(from)
        }
    }
    
    override func visit(v: Module) {
        
        let counter = Counter()
        _ = counter.tik()
        func getNewAddr() -> IntC {
            let c = IntC(type: .int, value: -counter.tikInt())
            c.makeEmpty()
            allVar.append(c)
            return c
        }
        
        for g in v.globalVar {
            g.makeEmpty()
            allVar.append(g)
        }
        for f in v.functions {
            for o in f.operands {
                o.makeEmpty()
                allVar.append(o)
            }
            for b in f.blocks {
                for i in b.insts {
                    i.makeEmpty()
                    allVar.append(i)
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
                        i[0].loads.insert(i)
                    case is StoreInst:
                        if !(i[0] is ConstIR) {
                            i[1].stores.insert(i[0])
                        }
                    case is GEPInst, is CastInst:
//                        print("GEP/Cast", i[0], "->", i)
                        i[0].graph.insert(i)
                    case is PhiInst:
//                        print("PHI", i.operands.joined())
                        for j in 0..<i.operands.count/2 where !(i[j*2] is ConstIR) {
                            i[j*2].graph.insert(i)
                        }
                    case is AllocaInst:
                        i.pts.insert(getNewAddr())
                    case let c as CallInst:
                        if IRBuilder.Builtin.functions.values.contains(c.function) {
                            if c.function.basename == "malloc" {
                                i.pts.insert(getNewAddr())
                            }
                        } else {
                            for (formal, actual) in zip(c.function.operands, c.operands) where !(actual is ConstIR) {
                                print("CALL  ", actual, formal)
                                actual.graph.insert(formal)
                            }
                        }
                    case is ReturnInst:
                        if !(i[0] is ConstIR) {
                            for call in callers[i.inBlock.inFunction]! {
                                i[0].graph.insert(call)
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
            g.pts.insert(getNewAddr())
        }
        
        for v in allVar where !v.pts.isEmpty {
            workList.insert(v)
        }
        
        while let cur = workList.popFirst() {
//            print(workList.count, ">", cur, pts[cur]!, loads[cur]!, stores[cur]!)
            for a in cur.pts {
                cur.loads .forEach {addEdge(from: a, to: $0)}
                cur.stores.forEach {addEdge(from: $0, to: a)}
            }
            for q in cur.graph {
                var flag = false
                for nv in cur.pts where !q.pts.contains(nv) {
                    q.pts.insert(nv)
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
        
        var judgeType: ((InstIR) -> Bool)!
        var getAddr, getVal: ((InstIR) -> Value)!
        
        func lse(n: BaseDomTree.Node) {
            for i in n.block!.insts where judgeType(i) && i.operands.count > 0 {
                
                let stores = getAllDominated(from: i) {$0 is StoreInst}
                let loads = getAllDominated(from: i) {$0 is LoadInst && $0[0] == getAddr(i)}
                
//                print(i.toPrint, loads)
//                print("  ", stores.joined() {$0.toPrint})
                
                var unavai = Set<InstIR>(), workList = [InstIR]()
                for s in stores where aa.mayAlias(p: s[1], q: getAddr(i)) {
                    unavai.insert(s.nextInst!)
                    workList.append(s.nextInst!)
                }
                let dangerous = v.currentModule.functions.filter {
                    for blk in $0.blocks { for ins in blk.insts where ins is StoreInst {
                        if aa.mayAlias(p: ins[1], q: getAddr(i)) {
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
//                    print("   -", v.toPrint)
                    switch v {
                    case is ReturnInst:
                        break
                    case is BrInst:
                        for o in v.operands {
                            if let b = o as? BlockIR, domTree.checkBF(i.inBlock, dominates: b), i.inBlock !== b, !unavai.contains(b.insts.first!) {
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
//                    print(">", v.name, l.toPrint)
                    l.replaced(by: getVal(i))
                    instRemoved += 1
                }
            }
            for p in n.domSons {lse(n: p)}
        }
        
        (judgeType, getAddr, getVal) = ({$0 is StoreInst}, {$0[1]}, {$0[0]})
        lse(n: domTree.root)
        
        (judgeType, getAddr, getVal) = ({$0 is LoadInst}, {$0[0]}, {$0})
        lse(n: domTree.root)
        
    }
}
