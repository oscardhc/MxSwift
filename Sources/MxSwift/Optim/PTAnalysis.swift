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
    var workList = [Value]()
    
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
            workList.append(from)
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
                        print("GEP/Cast", i.operands[0], "->", i)
                        graph[i.operands[0]]!.insert(i)
                    case is PhiInst:
                        print("PHI", i.operands.joined())
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
            print("worklist", key, val)
            workList.append(key)
        }
        
        while let cur = workList.popLast() {
            print(">", cur, pts[cur]!, loads[cur]!, stores[cur]!)
            for a in pts[cur]! {
                loads[cur]! .forEach {addEdge(from: a, to: $0)}
                stores[cur]!.forEach {addEdge(from: $0, to: a)}
            }
            for q in graph[cur]! {
                let prevCount = pts[q]!.count
                pts[q]!.formUnion(pts[cur]!)
                if pts[q]!.count > prevCount {
                    workList.append(q)
                }
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
    
    init(aa: PTAnalysis) {
        self.aa = aa
    }
    
    func getPreviousLoad(in block: BasicBlock, for load: Inst) -> Inst? {
        
        var flag = false
        for i in block.insts.reversed() {
            if !flag {
                if i === load {
                    flag = true
                }
            } else if i is LoadInst && i.operands[0] === load.operands[0] {
                return i
            }
        }
        
        var it = domTree[block].idom
        while let cur = it?.block {
            for i in cur.insts.reversed() {
                if i is LoadInst && i.operands[0] == load.operands[0] {
                    return i
                }
            }
            it = it?.idom
        }
        return nil
        
    }
    
    func getAllDominatedStores(from: Inst) -> [Inst] {
        var ret = [Inst]()
        for i in from.inBlock.insts where i is StoreInst && i.blockIndexBF > from.blockIndexBF {
            ret.append(i)
        }
        func dfs(n: BaseDomTree.Node) {
            for i in n.block!.insts where i is StoreInst {
                ret.append(i)
            }
            for p in n.domSons {dfs(n: p)}
        }
        for p in domTree[from.inBlock].domSons {dfs(n: p)}
        return ret
    }
    
    func getAllReachable(from: Inst) {
        var vis = Set<Inst>(), book = Set<BasicBlock>()
        for i in from.inBlock.insts where i.blockIndexBF > from.blockIndexBF {
            vis.insert(i)
        }
        func dfs(n: BasicBlock) {
            book.insert(n)
            for i in n.insts {
                vis.insert(i)
            }
            for p in n.succs where !book.contains(p) {dfs(n: p)}
        }
        for p in from.inBlock.succs {dfs(n: p)}
        reachable[from] = vis
    }
    
    override func visit(v: Function) {
        
        domTree = DomTree(function: v)
        for b in v.blocks {
            for i in b.insts {
                getAllReachable(from: i)
            }
        }
        
        func lse(n: BaseDomTree.Node) {
            for i in n.block!.insts where i is LoadInst {
                if let pre = getPreviousLoad(in: n.block!, for: i) {
                    
                    let stores = getAllDominatedStores(from: pre)
                    print(">>>>>", i.toPrint, stores.count)
                    print(stores.joined() {"[\($0.operands[0]) \($0.operands[1]) \(reachable[$0]!.contains(i))]"})
                    var flag = true
                    for s in stores where reachable[s]!.contains(i) && aa.mayAlias(p: s.operands[1], q: i.operands[0]) {
                        flag = false
                    }
                    if flag {
                        print(i.toPrint, aa.pts[i.operands[0]]!)
                        print(">", pre.toPrint)
                        i.replaced(by: pre)
                        instRemoved += 1
                    }
                    print("")
                    
                }
            }
            for p in n.domSons {lse(n: p)}
        }
        
        lse(n: domTree.root)
        
    }
}
