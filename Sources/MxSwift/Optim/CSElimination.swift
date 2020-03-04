//
//  CSElimination.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/26.
//

import Foundation

class CSElimination: FunctionPass {
    
    override func work(on v: Module) {
        IRNumberer().work(on: v)
        super.work(on: v)
    }
    
    private var instRemoved = 0
    override var resultString: String {super.resultString + "\(instRemoved) inst(s) removed."}
    
    override func visit(v: Function) {
        
        var cseMap = [String: Inst]()
        var cseReMap = [Inst: String]()
        
        let domTree = DomTree(function: v)
        
        func cse(n: BaseDomTree.Node) {
            for i in n.block!.insts where !i.isCritical {
                
                if i is CastInst && i.type == i.operands[0].type {
                    i.replaced(by: i.operands[0])
                    instRemoved += 1
                    continue
                }
                let exp = VNExpression(v: i, depth: -1)
                let str = exp.simplified().description
                if let p = cseMap[str] {
                    print(i.toPrint)
                    print(">", p.toPrint)
                    i.replaced(by: p)
                    instRemoved += 1
                } else {
                    cseMap[str] = i
                    cseReMap[i] = str
                }
            }
            for son in n.domSons {
                cse(n: son)
            }
            for i in n.block!.insts {
                if let str = cseReMap[i] {
                    cseMap.removeValue(forKey: str)
                    cseReMap.removeValue(forKey: i)
                }
            }
        }
        
        cse(n: domTree.root)
    }
    
}

class GVNumberer: FunctionPass {
    
    override func work(on v: Module) {
        IRNumberer().work(on: v)
        super.work(on: v)
    }
    
    private var instRemoved = 0
    override var resultString: String {super.resultString + "\(instRemoved) inst(s) removed."}
    
    private var rpo = [BasicBlock]()
    private var domTree: DomTree!, pdomTree: PostDomTree!
    
    private var map = [BasicBlock: [String: Inst]]()
    
    private var workList = Set<Inst>(), blockList = Set<BasicBlock>()
    private var predicateEdge = [BasicBlock.Edge: VNExpression]()
    
    private var visited = Set<BasicBlock>()
    
    
    
    override func visit(v: Function) {
        
        func getPredicate(from block: BasicBlock) -> [VNExpression] {
            var it: DomTree.Node? = domTree[block], pre = [VNExpression]()
            while let cur = it?.block {
                let only = cur.preds.generated {
                    $0.reachable ? BasicBlock.Edge(from: $0, to: cur) : nil
                }
                if only.count == 1 {
                    if let p = predicateEdge[only[0]] {
                        pre.append(p)
                    }
                }
                it = it?.idom
            }
            return pre
        }
        func evaluate(_ inst: Inst, in block: BasicBlock) -> Inst? {
            let str = VNExpression(v: inst).simplified().description
            let pre = getPredicate(from: block)
            var it: DomTree.Node? = domTree[block], atoms = [(String, Bool)]()
            let atm = RefSet<String>()
            for p in pre {
                p.getAllBoolAtoms(to: atm)
            }
            for a in atm._s {
                atoms.append((a, false))
            }
            func tryPredicate(depth: Int) {
                if depth >= atoms.count {
                    
                    return
                } else {
                    tryPredicate(depth: depth + 1)
                    atoms[depth].1 = true
                    tryPredicate(depth: depth + 1)
                }
            }
            print(inst.toPrint)
            print(str, atoms)
            while let cur = it?.block {
                if let i = map[cur]![str] {
                    if i !== inst {
                        print(inst.toPrint, str)
                        print(">", i.toPrint)
                        return i
                    }
                }
                it = it?.idom
            }
            map[block]![str] = inst
            return nil
        }
        func dfs(block: BasicBlock) {
            visited.insert(block)
            for son in block.succs where !visited.contains(son) {
                dfs(block: son)
            }
            rpo.append(block)
        }
        func changeIfNeeded(edge: BasicBlock.Edge, exp: VNExpression) -> Bool {
            if let p = predicateEdge[edge] {
                if p != exp {
                    predicateEdge[edge] = exp
                    return true
                }
                return false
            } else {
                predicateEdge[edge] = exp
                return true
            }
        }
        func updatePredicate(edge: BasicBlock.Edge, exp: VNExpression) {
            if changeIfNeeded(edge: edge, exp: exp) {
                for blk in v.blocks where blk.reachable && domTree.checkBF(edge.to, dominates: blk) {
                    for i in blk.insts {workList.insert(i)}
                }
                for blk in v.blocks where blk.reachable && pdomTree.checkBF(blk, dominates: edge.to) {
                    blockList.insert(blk)
                }
            }
        }
        func tryBlock(block: BasicBlock) {
            if !block.reachable {
                block.reachable = true
                domTree = DomTree(function: v, check: {$0.reachable})
                pdomTree = PostDomTree(function: v, check: {$0.reachable})
                for i in block.insts {workList.insert(i)}
            } else {
                for i in block.insts where i is PhiInst {workList.insert(i)}
            }
        }
        
        
        print("WORK!")
        rpo.removeAll(); visited.removeAll();
        dfs(block: v.blocks.first!)
        rpo.reverse()
        map.removeAll()
        for blk in v.blocks {map[blk] = [String: Inst](); blk.reachable = false;}
        workList.removeAll(); blockList.removeAll(); predicateEdge.removeAll();
        
        tryBlock(block: v.blocks.first!)
        
        while !workList.isEmpty || !blockList.isEmpty {
            for blk in rpo {
                blockList.remove(blk)
                for i in blk.insts where workList.contains(i) {
                    workList.remove(i)
                    if !blk.reachable {
                        continue
                    }
                    if i is CastInst && i.type == i.operands[0].type {
                        i.replaced(by: i.operands[0])
                        instRemoved += 1
                        continue
                    }
                    if let jump = i as? BrInst {
                        for s in blk.succs { tryBlock(block: s) }
                        if jump.operands.count > 1 {
                            let preTrue = VNExpression(v: jump.operands[0])
                            let preFalse = VNExpression(v: jump.operands[0])
                            preFalse.negation()
                            updatePredicate(edge: BasicBlock.Edge(from: blk, to: blk.succs[0]), exp: preTrue.simplified())
                            updatePredicate(edge: BasicBlock.Edge(from: blk, to: blk.succs[1]), exp: preFalse.simplified())
                        }
                    } else if !i.isCritical {
                        if let ninst = evaluate(i, in: blk) {
                            instRemoved += 1
                            i.replaced(by: ninst)
                        }
                    }
                }
            }
        }
    }
    
}

class VNExpression: CustomStringConvertible {
    var op = Inst.OP.add, sop = CompareInst.CMP.eq // just nonsence init
    var name: String
    var neg = false
    var val = [VNExpression]() // be careful that there should be NO same expression references
    
    var unsigned: String {
        name + (val.count > 0 ? ("=(" + (op == .icmp ? "\(sop)" : "\(op)") + " " + val.joined() + ")") : "")
    }
    var description: String {(neg ? "-" : "") + unsigned}
    static func == (l: VNExpression, r: VNExpression) -> Bool {l.description == r.description}
    static func != (l: VNExpression, r: VNExpression) -> Bool {!(l == r)}
    
    init(_ a: VNExpression) {
        op      = a.op
        sop     = a.sop
        name    = a.name
        neg     = a.neg
        for v in a.val {
            val.append(VNExpression(v))
        }
    }
    
    init(v: Value, depth: Int = 4) {
        name = v.name
        if let i = v as? Inst {
            if !(depth == 0 || i.isCritical) {
                op = i.operation
                if i is PhiInst {
//                    for j in 0..<i.operands.count / 2 where (i.operands[j * 2 + 1] as! BasicBlock).executable {
//                        val.append(VNExpression(v: i.operands[j * 2], depth: depth - 1))
//                        val.append(VNExpression(v: i.operands[j * 2 + 1], depth: depth - 1))
//                    }
                } else {
                    if let c = i as? CompareInst {
                        if c.cmp == .eq || c.cmp == .ne { // now only consider equations
                            sop = c.cmp
                            val.append(VNExpression(n: "_", o: .sub))
                            for o in i.operands {
                                val[0].val.append(VNExpression(v: o, depth: depth - 1))
                            }
                        } else {
                            name = "1"
                        }
                    } else {
                        for o in i.operands {
                            val.append(VNExpression(v: o, depth: depth - 1))
                        }
                    }
                }
            } else {
                name = i.toPrint
            }
        }
    }
    init(i: Int) {name = "\(i)"}
    init(n: String, o: Inst.OP) {name = n; op = o}
    
    func sort() {
        val.forEach {$0.sort()}
        val.sort {"\($0)" < "\($1)"}
    }
    
    static let commutative: Set<Inst.OP> = [.add, .mul]
    static let opp = [Inst.OP.sub: Inst.OP.add]
    func deleteOpp() -> Bool {
        for l in val { for r in val where l.neg != r.neg && l.unsigned == r.unsigned {
            val.removeAll {$0 === l}
            val.removeAll {$0 === r}
            return true
            }}
        return false
    }
    
    func inverse(i: Int) -> Int {
        switch op {
        case .add:
            return -i
        default:
            return 0
        }
    }
    func getSubInt(v: VNExpression) -> Int? {
        if let n = Int(v.name) {
            return v.neg ? inverse(i: n) : n
        }
        return nil
    }
    
    static let normalCompare = [CompareInst.CMP.sle: CompareInst.CMP.sge, .slt: .sgt]
    static let notCompare = [CompareInst.CMP.sle: CompareInst.CMP.sgt, .sgt: .sle, .sge: .slt, .slt: .sge, .eq: .ne, .ne: .eq]
    
//    !(a < 0) -> a >= 0 -> -a <= 0
    func negation() {
        sop = VNExpression.notCompare[sop]!
    }
    
    func getAllBoolAtoms(to dict: RefSet<String>) {
        if op == .icmp {
            dict.insert(description)
        } else {
            for v in val {
                v.getAllBoolAtoms(to: dict)
            }
        }
    }
    
    @discardableResult func addedPredicate(predicate: VNExpression) -> Self {
        
        return simplified()
    }
    
    @discardableResult func simplified() -> Self {
        val = val.generated {
            if $0.val.count > 0 {
                $0.simplified()
                if $0.val.count == 1 && Inst.OP.map[$0.op] != nil {
                    return $0.val[0]
                }
            }
            return $0
        }
        
        if let nop = VNExpression.normalCompare[sop] {
            val[0].neg = val[0].neg != true
            sop = nop
        }

        if let nop = VNExpression.opp[op] {
            val[1].neg = val[1].neg != true
            op = nop
        }
        
        if VNExpression.commutative.contains(op) {
            if Inst.OP.map[op] != nil {
                for e in val where e.op == op && e.val.count > 0 {
                    for subE in e.val {
                        subE.neg = subE.neg != e.neg
                        val.append(subE)
                    }
                    val.removeAll {$0 === e}
                }
            }
            
            // no phi yet, but there is one in SCCP
            var res: Int? = nil
            val = val.generated {
                if let n = getSubInt(v: $0) {
                    res = res == nil ? n : Inst.OP.map[op]!(res!, n)
                    return nil
                }
                return $0
            }
            if let n = res {
                val.append(VNExpression(i: n))
            }
            
            sort()
        }
        
        while deleteOpp() {}
        
        return self
    }
}
