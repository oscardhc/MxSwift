//
//  RAllocator.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/4/14.
//

import Foundation

class RAllocator {
    
    class N {
        var (precolored, initial, simplifyList, freezeList, spillList, spilled, coalesced, colored)
            = (Set<Register>(), Set<Register>(), Set<Register>(), Set<Register>(), Set<Register>(), Set<Register>(), Set<Register>(), Set<Register>())
        var stack = [Register]()
        var stackSet = Set<Register>()
    }
    
    class M {
        var (coalesced, constrained, frozen, worklist, active)
            = (Set<InstRV>(), Set<InstRV>(), Set<InstRV>(), Set<InstRV>(), Set<InstRV>())
    }
    
    var prog: Assmebly!
    let K = RV32.normal.count
    var n: N!, m: M!
    var adj = [Register: Set<Register>]()
    var f: FunctionRV!
    
    func work(on v: Assmebly) {
        prog = v
        for f in v.functions where !f.blocks.isEmpty {
            visit(v: f)
        }
    }
    func add(_ u: Register, _ v: Register) {
        if !RV32.regs.values.contains(u) {
            u.itr.insert(v)
            u.deg += 1
        }
    }
    func addEdge(_ u: Register, _ v: Register) {
        if u !== v && !adj[u]!.contains(v) {
            adj[u]!.insert(v)
            adj[v]!.insert(u)
            add(u, v)
            add(v, u)
        }
    }
    func visit(v: FunctionRV) {
        f = v
        n = N(); m = M(); adj.removeAll()

        let instList = v.blocks.reduce([InstRV](), {$0 + [InstRV]($1.insts)})
        for i in instList {
            for d in i.def {
                n.initial.insert(d)
            }
            for s in i.use {
                n.initial.insert(s)
            }
        }
        for r in n.initial where RV32.regs.values.contains(r) {
//            print("precolored", r, r.color)
            n.initial.remove(r)
            n.precolored.insert(r)
        }
        allocate(v: v)
        
    }
    
    func allocate(v: FunctionRV) {
        
        LAnalysis.analysis(v: v)
        adj.removeAll()
        
        let instList = v.blocks.reduce([InstRV](), {$0 + [InstRV]($1.insts)})
        for i in instList {
            for d in i.def {
                d.clear()
                adj[d] = []
            }
            for s in i.use {
                s.clear()
                adj[s] = []
            }
        }
        for b in v.blocks {
            var live = b.oo
            for i in b.insts.reversed() {
                if i.op == .mv {
                    live.subtract(i.use)
                    for o in i.def.union(i.use) {
                        o.mov.insert(i)
                    }
                    m.worklist.insert(i)
                }
                live.formUnion(i.def)
//                print("build", i, i.def)
                for d in i.def {
                    for o in live {
                        addEdge(d, o)
                    }
                }
                live = i.use.union(live.subtracting(i.def))
            }
        }
        for r in n.precolored where adj[r] == nil {adj[r] = []}
        for r in n.initial where adj[r] == nil {adj[r] = []}
        for r in n.precolored {r.deg = 100000}
//        print(n.precolored)
//        print(n.initial)
        while let r = n.initial.popFirst() {
            if r.deg >= K {
                n.spillList.insert(r)
            } else if !r.mov.isEmpty {
                n.freezeList.insert(r)
            } else {
                n.simplifyList.insert(r)
            }
        }
//        print("")
//        print(n.spillList)
//        print(n.freezeList)
//        print(n.simplifyList)
        
        while true {
            if !n.simplifyList.isEmpty {
                simplify()
            } else if !m.worklist.isEmpty {
                coalesce()
            } else if !n.freezeList.isEmpty {
                freeze()
            } else if !n.spillList.isEmpty {
                selectSpill()
            } else {
                break
            }
        }
        assert(n.simplifyList.isEmpty && m.worklist.isEmpty && n.freezeList.isEmpty && n.spillList.isEmpty)
//        print("stack", n.stack)
        assignColors()
        print("after assign", n.spilled)
        
//        RVPrinter(filename: "/Users/oscar/Documents/Classes/1920_Spring/Compiler/tmp/test.s").work(on: prog)
        if !n.spilled.isEmpty {
            rewrite()
            allocate(v: v)
        }
    }

    func adjacent(_ r: Register) -> Set<Register> {r.itr.subtracting(n.coalesced).subtracting(n.stack)}
    func moves(_ r: Register) -> Set<InstRV> {r.mov.intersection(m.active.union(m.worklist))}
    
    func decreseDeg(_ r: Register) {
        r.deg -= 1
        if r.deg == K - 1 {
            (adjacent(r) + [r]).forEach {enableMoves($0)}
            n.spillList.remove(r)
            if !r.mov.isEmpty {
                n.freezeList.insert(r)
            } else {
                n.simplifyList.insert(r)
            }
        }
    }
    func enableMoves(_ r: Register) {
        for x in moves(r) {
            if m.active.contains(x) {
                m.active.remove(x)
                m.worklist.insert(x)
            }
        }
    }
    func alias(_ r: Register) -> Register {
        if n.coalesced.contains(r) {
            return alias(r.alias!)
        }
        return r
    }
    func addWorkList(_ r: Register) {
        if !n.precolored.contains(r) && r.mov.isEmpty && r.deg < K {
            n.freezeList.remove(r)
            n.simplifyList.insert(r)
        }
    }
    func ok(_ t: Register, _ r: Register) -> Bool {
        t.deg < K || n.precolored.contains(t) || adj[t]!.contains(r)
    }
    func conservative(_ s: Set<Register>) -> Bool {
//        print("conservative", s.map({"\($0): \($0.deg)"}))
        return s.reduce(0, {$0 + ($1.deg >= K ? 1 : 0)}) < K
    }
    func checkOK(_ u: Register, _ v: Register) -> Bool {
//        return !adjacent(v).contains{!ok($0, u)}
//        for r in v.itr where !n.coalesced.contains(r) && !n.stackSet.contains(r) && !ok(r, u) {
//            return false
//        }
//        for r in adjacent(v) {
        for r in v.itr where !n.coalesced.contains(r) && !n.stackSet.contains(r) {
            if !ok(r, u) {
                return false
            }
        }
        return true
    }
    func conservative(_ u: Register, _ v: Register) -> Bool {
//        conservative(adjacent(u).union(adjacent(v)))
        var res = 0
        for r in u.itr where !n.coalesced.contains(r) && !n.stackSet.contains(r) && r.deg >= K {
            res += 1
        }
        for r in v.itr where !n.coalesced.contains(r) && !n.stackSet.contains(r) && r.deg >= K {
            res += 1
        }
        return res < K
    }
    func combine(_ u: Register, _ v: Register) {
//        print("-", u, v)
        if n.freezeList.contains(v) {
            n.freezeList.remove(v)
        } else {
            n.spillList.remove(v)
        }
        n.coalesced.insert(v)
        v.alias = u
        u.mov.formUnion(v.mov)
        enableMoves(v)
//        print("     ", adj[v]!, adjacent(v))
//        print("     ", n.coalesced, n.stack)
        for t in adjacent(v) {
            addEdge(t, u)
            decreseDeg(t)
        }
        if u.deg >= K && n.freezeList.contains(u) {
            n.freezeList.remove(u)
            n.spillList.insert(u)
//            print("into spill list", u)
        }
    }
    func freezeMoves(_ u: Register) {
        for mv in u.mov {
            let (x, y) = (mv.dst!, mv[0] as! Register)
            var v: Register!
            if alias(y) == alias(u) {
                v = alias(x)
            } else {
                v = alias(y)
            }
            m.active.remove(mv)
            m.frozen.insert(mv)
            if n.freezeList.contains(v) && v.mov.isEmpty {
                n.freezeList.remove(v)
                n.simplifyList.insert(v)
            }
        }
    }
    
    func simplify() {
        let r = n.simplifyList.popFirst()!
        n.stack.append(r)
        n.stackSet.insert(r)
        for a in adjacent(r) {
            decreseDeg(a)
        }
    }
    func coalesce() {
        let mv = m.worklist.popFirst()!
        let (x, y) = (alias(mv.dst), alias(mv[0] as! Register))
        let (u, v) = n.precolored.contains(y) ? (y, x) : (x, y)
        if u === v {
            m.coalesced.insert(mv)
            addWorkList(u)
        } else if n.precolored.contains(v) || adj[u]!.contains(v) {
            m.constrained.insert(mv)
            addWorkList(u)
            addWorkList(v)
        } else if (n.precolored.contains(u) && checkOK(u, v))
            || (!n.precolored.contains(u) && conservative(u, v)) {
            m.coalesced.insert(mv)
            combine(u, v)
            addWorkList(u)
        } else {
            m.active.insert(mv)
        }
    }
    func freeze() {
        let u = n.freezeList.popFirst()!
        n.simplifyList.insert(u)
        freezeMoves(u)
    }
    func selectSpill() {
        let u = n.spillList.min{$0.cost/Double($0.deg) < $1.cost/Double($1.deg)}!
//        print("select spill", u, u.cost, u.deg)
        n.spillList.remove(u)
        n.simplifyList.insert(u)
        freezeMoves(u)
    }
    func assignColors() {
        while let r = n.stack.popLast() {
            n.stackSet.remove(r)
            var colors = RV32.normal
            for w in adj[r]! {
                let h = alias(w)
                if n.precolored.contains(h) || n.colored.contains(h) {
                    colors.removeAll(where: {$0 == h.color})
                }
            }
            if colors.isEmpty {
                n.spilled.insert(r)
            } else {
                n.colored.insert(r)
                r.color = colors.first!
//                print("COLOR", r)
            }
        }
        for r in n.coalesced {
            r.color = alias(r).color
        }
    }
    func rewrite() {
        var tmp = [Register]()
        for s in n.spilled {
//            let reg = Register()
//            print("rewrite", s, adj[s]!)
            let pos = f.newVar()
            for d in s.defs {
                let reg = Register()
//                print("     ", d, reg)
                d.newDst(reg)
                InstRV(.sw, in: d.inBlock, at: d.nodeInBlock.indexBF, reg, pos)
                tmp.append(reg)
            }
            for u in s.uses {
                let reg = Register()
//                print("     ", u, reg)
                u.newSrc(reg, at: u.src.firstIndex(where: {$0.getReg === s})!)
                InstRV(.lw, in: u.inBlock, at: u.nodeInBlock.indexBF - 1, to: reg, pos)
                tmp.append(reg)
            }
        }
//        print("after rewrite", tmp)
        n.spilled.removeAll()
        n.initial = n.colored.union(n.coalesced.union(tmp))
//        print(n.initial)
        n.colored.removeAll()
        n.coalesced.removeAll()
    }
    
}
