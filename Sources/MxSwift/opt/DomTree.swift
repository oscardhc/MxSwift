//
//  DomTree.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/17.
//

import Foundation

class BaseDomTree {
    
    let f: Function
    var root: Node!
    let dfnCounter = Counter()
    var dfnList = [Node]()
    
    class Node {
        
        let block: BasicBlock?
        var dfn = -1
        var father: Node?
        var edge = [Node]()
        var antiEdge = [Node]()
        var depth = 0
        
        var belInDSet: Node?
        
        var minDfn: Node?
        var sdom: Node?
        var idom: Node?
        
        var bucket = [Node]()
        var name = ""
        
        var domSons = [Node]()
        var domFrontiers = [Node]()
        
        init(block: BasicBlock?) {
            self.block = block
            self.minDfn = self
            self.sdom = self
            self.name = block?.name ?? "exit"
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
        
    }
    
    init(function: Function) {
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
                if m.dfn < u.sdom!.dfn {
                    u.sdom = m
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
            u.idom?.domSons.append(u)
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
            son.antiEdge.append(cur)
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
    
    func checkBF(_ x: Node, dominates y: Node) -> Bool {
        var c = y
        if x.depth < c.depth {
            while x.depth < c.depth {
                c = c.idom!
            }
        }
        return x === c
    }
    
}

class DomTree: BaseDomTree {
    
    override init(function: Function) {
        
        super.init(function: function)
        
        for blk in function.blocks {
            blk.domNode = Node(block: blk)
        }
        for blk in function.blocks {
            blk.sons.forEach {
                blk.domNode?.edge.append(($0 as! BasicBlock).domNode!)
            }
        }
        root = function.blocks.first!.domNode!
        build()
        
    }
    
}

class PostDomTree: BaseDomTree {
    
    override init(function: Function) {
        
        super.init(function: function)
        
        for blk in function.blocks {
            blk.postDomNode = Node(block: blk)
        }
        
        root = Node(block: nil)
        
        for blk in function.blocks {
            blk.sons.forEach {
                ($0 as! BasicBlock).postDomNode!.edge.append(blk.postDomNode!)
            }
            if blk.sons.isEmpty {
                root.edge.append(blk.postDomNode!)
            }
        }
        
        build()
        
    }
    
}
