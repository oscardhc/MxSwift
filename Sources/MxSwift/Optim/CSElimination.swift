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
                    print(i.toPrint)
                    print(">", i.operands[0])
                    i.replaced(by: i.operands[0])
                    instRemoved += 1
                    continue
                }
                let exp = VNExpression(v: i, depth: 4)
                let str = exp.simplified().description
//                print(i.toPrint, str)
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
    
    private var rpo     = [BasicBlock]()
    private var domTree : DomTree!, pdomTree: PostDomTree!
    
    private var map     = [BasicBlock: [String: Inst]]()
    
    private var workList        = Set<Inst>(), blockList = Set<BasicBlock>()
    private var predicateEdge   = [BasicBlock.Edge: VNExpression]()
    private var visited         = Set<BasicBlock>()
    private var belongTo        = [Inst: String]()
    private var blockPredicate  = [BasicBlock: [VNExpression]]()
    
    override func visit(v: Function) {
        
        func getPredicate(at cur: BasicBlock) -> VNExpression? {
            let only = cur.preds.generated {
                $0.reachable ? BasicBlock.Edge(from: $0, to: cur) : nil
            }
            if only.count == 1, let p = predicateEdge[only[0]] {
                return p
            }
            return nil
        }
        func lookup(description str: String, in block: BasicBlock, for inst: Inst) -> (Inst?, String)? {
            var it  : DomTree.Node? = domTree[block]
            if Int(str) != nil {
                return (nil, str)
            }
            while let cur = it?.block {
                if let i = map[cur]![str], i !== inst {
                    return (i, str)
                }
                it = it?.idom
            }
            return nil
        }
        func evaluate(_ inst: Inst, in block: BasicBlock) -> (Inst?, String) {
            
            let exp     = VNExpression(v: inst)
            let idom    = domTree[block].idom?.block
            var fnl     = [VNExpression]()
            var reach   = Set<String>()
            
            if blockPredicate[block] == nil, let pres = getPredicate(at: block) {
                
                fnl = (idom == nil && idom!.reachable) ? [] : (blockPredicate[idom!] ?? [])
                
                let atomMap = RefDict<String, (Bool, VNExpression)>()
                pres.getAllBoolAtoms(to: atomMap)
                let keys    = [String](atomMap._s.keys)
                var preRes  = [String: Int?]()
                
                func findPredDomination(depth: Int) {
                    if depth >= keys.count {
                        let flag = pres.checkSatisfied(with: atomMap)
//                        print("find...", flag, atomMap._s)
                        if flag > 0 {
                            for key in keys {
                                if preRes[key] == nil || preRes[key]! == (atomMap[key]!.0 ? 1 : 0) {
                                    preRes[key] = (atomMap[key]!.0 ? 1 : 0)
                                } else {
                                    preRes[key] = 2
                                }
                            }
                        }
                        return
                    } else {
                        atomMap[keys[depth]]!.0 = true
                        findPredDomination(depth: depth + 1)
                        atomMap[keys[depth]]!.0 = false
                        findPredDomination(depth: depth + 1)
                    }
                }
                
                // the terrible 2^n procedure
                findPredDomination(depth: 0)
                for key in keys {
                    if let k = preRes[key], k != 2 {
                        let pred = atomMap[key]!.1
                        if k == 0 {
                            pred.negation()
                        }
                        fnl.append(pred.simplified())
                    }
                }
                
                blockPredicate[block] = fnl
                
            } else {
                fnl = blockPredicate[block] ?? []
            }
            
            func findAllCongruence(current: VNExpression) -> (Inst?, String)? {
//                print("find", current.description, current.description)
                if let i = lookup(description: current.description, in: block, for: inst) {
//                    print(">>>>>>", i)
                    return i
                }
                for pred in fnl {
                    let nexp = VNExpression(current)
                    if nexp.addedPredicate(predicate: pred) && !reach.contains(nexp.simplified().description) {
                        reach.insert(nexp.description)
                        if let i = findAllCongruence(current: nexp) {
                            return i
                        }
                    }
                }
                return nil
            }
            
            // another terrible 2^n procedure
            if let i = findAllCongruence(current: exp) {
                return i
            } else {
                return (nil, exp.simplified().description)
            }
            
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
        
        rpo.removeAll(); visited.removeAll();
        dfs(block: v.blocks.first!)
        rpo.reverse()
        map.removeAll()
        for blk in v.blocks {map[blk] = [String: Inst](); blk.reachable = false;}
        workList.removeAll(); blockList.removeAll(); predicateEdge.removeAll();
        belongTo.removeAll();
        for b in v.blocks {b.insts.forEach {$0.constInt = nil}}
        
        
        tryBlock(block: v.blocks.first!)
        while !workList.isEmpty || !blockList.isEmpty {
            blockPredicate.removeAll()
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
                        
                        if jump.operands.count > 1 {
                            var flag: Bool? = nil
                            if let ci = jump.operands[0] as? Inst {
                                let condition = evaluate(ci, in: blk)
                                if let n = Int(condition.1) {
                                    flag = n == 1
                                }
                            } else if let n = Int(VNExpression(v: jump.operands[0]).simplified().name) {
                                flag = n == 1
                            }
                            
                            if flag != false {
                                tryBlock(block: blk.succs[0])
                                let preTrue = VNExpression(v: jump.operands[0])
                                updatePredicate(edge: BasicBlock.Edge(from: blk, to: blk.succs[0]), exp: preTrue.simplified())
                                print("        branch T", preTrue.description)
                            }
                            if flag != true {
                                tryBlock(block: blk.succs[1])
                                let preFalse = VNExpression(v: jump.operands[0])
                                preFalse.negation()
                                updatePredicate(edge: BasicBlock.Edge(from: blk, to: blk.succs[1]), exp: preFalse.simplified())
                                print("        branch F", preFalse.description)
                            }
                            
                        } else {
                            tryBlock(block: blk.succs[0])
                        }
                        
                    } else if !i.isCritical {
                        
                        let res = evaluate(i, in: blk)
                        print(i.toPrint, res)
                        
                        if let x = map[blk]![res.1] {
                            if x.blockIndexBF > i.blockIndexBF {
                                map[blk]![res.1] = i
                            }
                        } else {
                            map[blk]![res.1] = i
                        }
                        
                        if let n = Int(res.1) {
                            i.constInt = n
                        } else {
                            i.constInt = nil
                        }
                        
                        if belongTo[i] != res.1 {
                            belongTo[i] = res.1
                            for u in i.users {
                                workList.insert(u.user as! Inst)
                            }
                        }
                        
                    }
                }
            }
        }
        
        blockPredicate.removeAll()
        for blk in rpo where blk.reachable {
            for i in blk.insts.reversed() where !i.isCritical {
                let str = belongTo[i]!
                if let n = Int(str) {
                    print(i.toPrint)
                    print(">", n)
                    i.replaced(by: IntC(name: "", type: .int, value: n))
                    instRemoved += 1
                } else if let (l, _) = lookup(description: str, in: blk, for: i) {
                    print(i.toPrint)
                    print(">", l!)
                    if l!.inBlock != i.inBlock {
                        map[blk]!.removeValue(forKey: str)
                    }
                    i.replaced(by: l!)
                    instRemoved += 1
                }
            }
            
            // phi with same value
            for i in blk.insts where i is PhiInst {
                
                var res: Value? = nil, flag = true
                for j in 0..<i.operands.count/2 {
                    if res == nil {
                        res = i.operands[j*2]
                    } else {
                        if res !== i.operands[j*2] {
                            flag = false
                        }
                    }
                }
                if flag && res != nil {
                    i.replaced(by: res!)
                }
            }
            
        }
        
        
    }
    
}

class VNExpression: CustomStringConvertible {
    var op      = Inst.OP.add, sop = CompareInst.CMP.eq // just nonsence init
    var name    : String
    var neg     = false
    var vals    = [VNExpression]() // be careful that there should be NO same expression references
    
    var unsigned: String {
        vals.count > 0 ? ("(" + (op == .icmp ? "\(sop)" : "\(op)") + " " + vals.joined() + ")") : name
    }
    var description: String {(neg ? "-" : "") + unsigned}
    static func == (l: VNExpression, r: VNExpression) -> Bool {l.description == r.description}
    static func != (l: VNExpression, r: VNExpression) -> Bool {!(l == r)}
    
    static var maxInit = 4
    
    init(_ a: VNExpression) {
        op      = a.op
        sop     = a.sop
        name    = a.name
        neg     = a.neg
        for v in a.vals {
            vals.append(VNExpression(v))
        }
    }
    init(o: Inst.OP, from vs: [VNExpression]) {
        op      = o
        vals    = vs
        name    = "_"
    }
    init(v: Value, depth: Int = VNExpression.maxInit) {
        name = v.name
        if let i = v as? Inst {
            if depth != VNExpression.maxInit && v.constInt != nil {
                name = "\(v.constInt!)"
            } else if !(depth == 0 || i.isCritical) {
                op = i.operation
                if i is PhiInst {
                    for j in 0..<i.operands.count/2 where (i.operands[j*2 + 1] as! BasicBlock).reachable {
                        vals.append(VNExpression(v: i.operands[j*2], depth: depth - 1))
                    }
                } else {
                    if let c = i as? CompareInst {
                        sop = c.cmp
                        vals.append(VNExpression(n: "_", o: .sub))
                        for o in i.operands {
                            vals[0].vals.append(VNExpression(v: o, depth: depth - 1))
                        }
                    } else {
                        for o in i.operands {
                            vals.append(VNExpression(v: o, depth: depth - 1))
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
        vals.sort {"\($0)" < "\($1)"}
    }
    
    static let commutative: Set<Inst.OP> = [.add, .mul, .xor]
    static let opp = [Inst.OP.sub: Inst.OP.add]
    static let normalCompare = [CompareInst.CMP.sle: CompareInst.CMP.sgt, .slt: .sge, .ne: .eq]
    static let comparisons = [CompareInst.CMP.eq, .ne, .sle, .sge, .slt, .sgt]
    
    func deleteOpp() -> Bool {
        for l in vals { for r in vals where l.neg != r.neg && l.unsigned == r.unsigned {
            vals.removeAll {$0 === l}
            vals.removeAll {$0 === r}
            return true
            }}
        return false
    }
    
    func inverse(i: Int, with _op: Inst.OP) -> Int {
        switch _op {
        case .add:
            return -i
        default:
            return 1 - i
        }
    }
    
    func getInt(with _op: Inst.OP) -> Int? {
        if let n = Int(name) {
            return neg ? inverse(i: n, with: _op) : n
        }
        return nil
    }
    
    func negation() {
        neg = neg == false
    }
    
    func getAllBoolAtoms(to dict: RefDict<String, (Bool, VNExpression)>) {
        if op == .icmp {
            if vals.count > 0 {
                dict[description] = (false, self)
            }
        } else {
            for v in vals {
                v.getAllBoolAtoms(to: dict)
            }
        }
    }
    
    func checkSatisfied(with dict: RefDict<String, (Bool, VNExpression)>) -> Int {
        if vals.isEmpty {
            return getInt(with: .icmp) ?? 0
        } else if op == .icmp {
            if vals.count > 0 {
                return dict[description]!.0 ? 1 : 0
            } else {
                return getInt(with: .icmp)!
            }
        } else if op == .xor {
            return vals[0].checkSatisfied(with: dict) ^ 1
        } else if op == .phi {
            return 1
        } else {
            var ret: Int? = nil
            for v in vals {
                ret = ret == nil ? v.checkSatisfied(with: dict) : Inst.OP.map[op]!(ret!, v.checkSatisfied(with: dict))
            }
            return ret ?? 1
        }
    }
    
    func addedPredicate(predicate: VNExpression) -> Bool {
        if predicate.op == .icmp && predicate.sop == .eq && !predicate.neg {
            let v = predicate.vals[0]
            switch v.op {
            case .add:
                for use in v.vals {
                    for j in 0..<vals.count where vals[j].name == use.name && Int(use.name) == nil {
                        let old = vals[j]
//                        print("|", description, predicate.description, terminator: " --[\(old.name), \(use.name)]-> ")
                        let _des = description
                        let replaced = VNExpression(o: .add, from: [])
                        for _new in v.vals where _new !== use {
                            let new = VNExpression(_new)
                            new.neg = (new.neg == old.neg) != use.neg
                            replaced.vals.append(new)
                        }
                        vals.insert(replaced, at: j)
                        vals.removeAll {$0 === old}
//                        print(description)
                        return description != _des
                    }
                }
            default:
                break
            }
        }
        for v in vals where v.vals.count > 0 && v.addedPredicate(predicate: predicate) {
            return true
        }
        return false
    }
    
    @discardableResult func simplified(toFold: Bool = true) -> Self {
        
        if vals.isEmpty {
            return self
        }
        
        vals = vals.generated {
            if $0.vals.count > 0 {
                $0.simplified(toFold: toFold)
                if $0.vals.count == 1 && Inst.OP.map[$0.op] != nil {
                    return $0.vals[0]
                }
            }
            return $0
        }
        
        if let nop = VNExpression.normalCompare[sop] {
            neg = neg != true
            sop = nop
        }
        
        if let nop = VNExpression.opp[op] {
            vals[1].neg = vals[1].neg != true
            op = nop
        }
        if op == .phi {
            
            if toFold {
                var res: Int? = nil, flag = true
                for v in vals {
                    if let n = v.getInt(with: op) {
                        if res == nil {
                            if flag {
                                res = n
                            }
                        } else if res! != n {
                            flag = false
                            res = nil
                        }
                    } else {
                        flag = false
                    }
                }
                if flag && res != nil {
                    vals = []
                    name = "\(res!)"
                }
            }
            
        } else if VNExpression.commutative.contains(op) {
            if Inst.OP.map[op] != nil {
                for e in vals where e.op == op && e.vals.count > 0 {
                    for subE in e.vals {
                        subE.neg = subE.neg != e.neg
                        vals.append(subE)
                    }
                    vals.removeAll {$0 === e}
                }
            }
            
            if toFold {
                var res: Int? = nil
                vals = vals.generated {
                    if let n = $0.getInt(with: op) {
                        res = res == nil ? n : Inst.OP.map[op]!(res!, n)
                        return nil
                    }
                    return $0
                }
                if let n = res {
                    if vals.isEmpty {
                        name = "\(n)"
                    } else {
                        vals.append(VNExpression(i: n))
                    }
                }
            }
            
            sort()
            
        } else if op == .icmp && VNExpression.comparisons.contains(sop) {
            if let n = vals[0].getInt(with: .add) {
                print(">", description)
                name = "\((CompareInst.CMP.map[sop]!(n, 0) != neg) ? 1 : 0)"
                vals = []
                neg  = false
                print("simplify", sop, n, name, description)
            }
            
        }
        
        while deleteOpp() {}
        
        return self
    }
}
