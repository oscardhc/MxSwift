//
//  DomTree.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/17.
//

import Foundation

class BaseDomTree {
    
    var root: Node!
    private let f: IRFunction, dfnCounter = Counter()
    private var dfnList = [Node](), map = [BlockIR: Node]()
    
    class Node: CustomStringConvertible {
        var description: String {block?.description ?? ""}
        
        let block: BlockIR?
        var dfn = -1
        var father: Node?
        var edge = List<Node>()
        var antiEdge = List<Node>()
        var depth = 0
        
        var belInDSet: Node?
        
        var minDfn: Node?
        var sdom: Node?
        var idom: Node?
        
        var bucket = [Node]()
        var name = ""
        
        var domSons = [Node]()
        var domFrontiers = [Node]()
        
        init(block: BlockIR?) {
            self.block = block
            self.minDfn = self
            self.sdom = self
            self.name = block?.name ?? "."
        }
        
        func find() -> Node {
            if belInDSet == nil {
                return self
            }
            belInDSet = belInDSet!.find()
            if belInDSet!.minDfn!.sdom!.dfn < minDfn!.sdom!.dfn {
                minDfn = belInDSet!.minDfn
            }
            return belInDSet!
        }
        
        func findDomFatherBF(where check: ((Node) -> Bool)) -> Node? {
            var cur: Node? = self
            while cur != nil {
                if check(cur!) {
                    return cur
                }
                cur = cur!.idom
            }
            return nil
        }
        
    }
    
    init(function: IRFunction) {
        self.f = function
    }
    
    private func eval(_ u: Node) -> Node {
        if u.belInDSet == nil {
            return u
        } else {
            _ = u.find()
            return u.minDfn!
        }
    }
    
    func build() {
        dfs(cur: root)
        for u in dfnList.reversed() {
            for v in u.antiEdge {
                let m = eval(v)
                if m.sdom!.dfn < u.sdom!.dfn {
                    u.sdom = m.sdom
                }
            }
            u.belInDSet = u.father
            u.sdom!.bucket.append(u)
            for v in u.father!.bucket {
                let m = eval(v)
                v.idom = m.sdom!.dfn < v.sdom!.dfn ? m : u.father
            }
            u.father!.bucket.removeAll()
        }
        for u in dfnList {
            if u.idom !== u.sdom {
                u.idom = u.idom!.idom
            }
        }
        for u in dfnList {
            u.idom!.domSons.append(u)
        }
        buildDepth(cur: root)
        for u in dfnList {
            for v in u.antiEdge {
                var runner: Node? = v
                while runner != nil && runner !== u.idom {
                    runner!.domFrontiers.append(u)
                    runner = runner!.idom
                }
            }
        }
    }
    
    func dfs(cur: Node) {
        if cur !== root {
            dfnList.append(cur)
        }
        for son in cur.edge {
            _ = son.antiEdge.append(cur)
            if son.dfn == -1 {
                son.dfn = dfnCounter.tikInt()
                son.father = cur
                dfs(cur: son)
            }
        }
    }
    func buildDepth(cur: Node) {
        for son in cur.domSons {
            son.depth = cur.depth + 1
            buildDepth(cur: son)
        }
    }
    
    func checkBF(_ _x: BlockIR, dominates _y: BlockIR) -> Bool {
        let x = self[_x], y = self[_y]
        return x === y.findDomFatherBF() {
            $0.depth == x.depth
        }
    }
    
    subscript(b: BlockIR) -> Node {
        get {
            map[b]!
        }
        set(new) {
            map[b] = new
        }
    }
    
}

class DomTree: BaseDomTree {
    
    init(function: IRFunction, check: (BlockIR) -> Bool = {_ in true}) {
        
        super.init(function: function)
        
        for blk in function.blocks.filter(check) {
            self[blk] = Node(block: blk)
        }
        for blk in function.blocks.filter(check) {
            blk.succs.filter(check).forEach {
                _ = self[blk].edge.append(self[$0])
            }
        }
        root = self[function.blocks.first!]
        build()
        
    }
    
}

class PostDomTree: BaseDomTree {
    
    init(function: IRFunction, check: (BlockIR) -> Bool = {_ in true}) {
        
        super.init(function: function)
        
        for blk in function.blocks.filter(check) {
            self[blk] = Node(block: blk)
        }
        
        let entryPoint = Node(block: nil) // note: this is the virtual root
        root = Node(block: nil) // note: this is actually the exit
        
        _ = self[function.blocks.first!].edge.append(entryPoint)
        _ = root.edge.append(entryPoint)
        
        for blk in function.blocks.filter(check){
            blk.succs.filter(check).forEach {
                _ = self[$0].edge.append(self[blk])
            }
            if blk.succs.filter(check).isEmpty {
                _ = root.edge.append(self[blk])
            }
        }
        build()
        
    }
    
}
