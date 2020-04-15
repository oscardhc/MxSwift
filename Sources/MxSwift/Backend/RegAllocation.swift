//
//  RAllocator.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/4/14.
//

import Foundation

class RAllocator {
    
    class N {
        var (precolored, initial, simplifyList, freezeList, spillList, spilled, coalesced, stack)
            = (Set<Register>(), Set<Register>(), Set<Register>(), Set<Register>(), Set<Register>(), Set<Register>(), Set<Register>(), [Register]())
    }
    
    class M {
        var (coalesced, constrained, frozen, worklist, active)
            = (Set<InstRV>(), Set<InstRV>(), Set<InstRV>(), Set<InstRV>(), Set<InstRV>())
    }
    
    let K = 25
    let n = N(), m = M()
    var adj = [Register: Set<Register>]()
    
    func work(on v: Assmebly) {
        for f in v.functions where !f.blocks.isEmpty {
            visit(v: f)
        }
    }
    func add(_ u: Register, _ v: Register) {
        if u.color == nil {
            n.initial.insert(u)
            u.itr.insert(v)
            u.deg += 1
        } else {
            n.precolored.insert(u)
        }
    }
    func addEdge(_ u: Register, _ v: Register) {
        if u !== v {
            if adj[u] == nil {adj[u] = []}
            if adj[v] == nil {adj[v] = []}
            adj[u]!.insert(v)
            adj[v]!.insert(u)
            add(u, v)
            add(v, u)
        }
    }
    func visit(v: FunctionRV) {
        let instList = v.blocks.reduce([InstRV](), {$0 + [InstRV]($1.insts)})
        for i in instList {
            if i.dst != nil {
                i.dst.clear()
            }
            for s in i.src where s is Register {
                (s as! Register).clear()
            }
        }
        for i in instList where i.dst != nil {
            if i.op == .mv {
                for o in i.oo where o !== i[0] {
                    addEdge(o, i.dst)
                }
                i.dst.mov.insert(i)
                (i[0] as! Register).mov.insert(i)
                m.worklist.insert(i)
            } else {
                for o in i.oo {
                    addEdge(o, i.dst)
                }
            }
        }
        print(n.precolored)
        print(n.initial)
        while let r = n.initial.popFirst() {
            print(r, r.itr)
            if r.deg >= K {
                n.spillList.insert(r)
            } else if !r.mov.isEmpty {
                n.freezeList.insert(r)
            } else {
                n.simplifyList.insert(r)
            }
        }
        print("")
        print(n.spillList)
        print(n.freezeList)
        print(n.simplifyList)
        
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
    }

    func adjacent(_ r: Register) -> Set<Register> {r.itr.subtracting(n.coalesced.union(n.stack))}
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
        s.reduce(0, {$0 + $1.deg >= K ? 1 : 0}) < K
    }
    func combine(_ u: Register, _ v: Register) {
        if n.freezeList.contains(v) {
            n.freezeList.remove(v)
        } else {
            n.spillList.remove(v)
        }
        n.coalesced.insert(v)
        v.alias = u
        u.mov.formUnion(v.mov)
        u.defs += v.defs
        u.uses += v.uses
        enableMoves(v)
        for t in adjacent(v) {
            addEdge(t, u)
            decreseDeg(t)
        }
        if u.deg >= K && n.freezeList.contains(u) {
            n.freezeList.remove(u)
            n.spillList.insert(u)
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
        } else if (n.precolored.contains(u) && adjacent(v).filter({!ok($0, u)}).isEmpty)
            || (!n.precolored.contains(u) && conservative(adjacent(u).union(adjacent(v)))) {
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
        n.spillList.remove(u)
        n.simplifyList.insert(u)
        freezeMoves(u)
    }
    
}
