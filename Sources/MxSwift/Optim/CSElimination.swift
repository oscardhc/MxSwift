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
    
    private var rpo     = [BasicBlock]()
    private var domTree : DomTree!, pdomTree: PostDomTree!
    
    private var map     = [BasicBlock: [String: Inst]]()
    
    private var workList        = Set<Inst>(), blockList = Set<BasicBlock>()
    private var predicateEdge   = [BasicBlock.Edge: VNExpression]()
    private var visited         = Set<BasicBlock>()
    private var belongTo        = [Inst: String]()
    private var leader          = [String: Inst]()
    
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
        func evaluate(_ inst: Inst, in block: BasicBlock) -> (Inst?, String) {
            let exp     = VNExpression(v: inst)
            let pres    = VNExpression(o: .and, from: getPredicate(from: block))
            let atomMap = RefDict<String, (Bool, VNExpression)>()
            pres.getAllBoolAtoms(to: atomMap)
            let keys    = [String](atomMap._s.keys)
            var preRes  = [String: Int?]()
            var reach   = Set<String>()
            
            func lookup(expression: VNExpression) -> (Inst?, String)? {
                let str = expression.simplified().description
                var it  : DomTree.Node? = domTree[block]
                print("=", str)
                if Int(str) != nil {
                    return (nil, str)
                }
                while let cur = it?.block {
                    if let i = map[cur]![str] {
                        if i !== inst {
                            print(inst.toPrint, str)
                            print(">>>>>>", i.toPrint)
                            return (i, str)
                        }
                    }
                    it = it?.idom
                }
                return nil
            }
            func tryPredicate(depth: Int) {
                if depth >= keys.count {
                    let flag = pres.checkSatisfied(with: atomMap)
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
                    tryPredicate(depth: depth + 1)
                    atomMap[keys[depth]]!.0 = false
                    tryPredicate(depth: depth + 1)
                }
            }
            func findSubsets(current: VNExpression) -> (Inst?, String)? {
                let expression = VNExpression(current)
                if let i = lookup(expression: expression) {
                    return i
                }
                for (pred, _) in preRes {
                    let nexp = VNExpression(current)
                    if nexp.addedPredicate(predicate: atomMap[pred]!.1) && !reach.contains(nexp.description) {
                        reach.insert(nexp.description)
                        if let i = findSubsets(current: nexp) {
                            return i
                        }
                    }
                }
                return nil
            }
            
            // the terrible 2^n procedure
            tryPredicate(depth: 0)
            
            print("")
            print(inst.toPrint, "           ", exp.description)
            // another terrible 2^n procedure
            
            if let i = findSubsets(current: exp.simplified()) {
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
        
        v.operands.forEach {$0.ccpInfo = Value.CCPInfo(type: .variable)}
        for blk in v.blocks {
            blk.insts.forEach {$0.ccpInfo = Value.CCPInfo()}
        }
        
        rpo.removeAll(); visited.removeAll();
        dfs(block: v.blocks.first!)
        rpo.reverse()
        map.removeAll()
        for blk in v.blocks {map[blk] = [String: Inst](); blk.reachable = false;}
        workList.removeAll(); blockList.removeAll(); predicateEdge.removeAll();
        belongTo.removeAll(); leader.removeAll();
        
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

                        let res = evaluate(i, in: blk)
                        // how to deal with conflicts between propogation predicted value and predicatedly predicted value?
                        // answer: there should be no conflicts...
                        map[blk]![res.1] = i
                        
                        if belongTo[i] != res.1 {
                            belongTo[i] = res.1
                            for u in i.users {
                                workList.insert(u.user as! Inst)
                            }
                        }
                        print(">", res.1)
                    }
                }
            }
        }
        
        for blk in rpo {
            for i in blk.insts where !i.isCritical {
                let str = belongTo[i]!
                if let n = Int(str) {
                    i.replaced(by: IntC(name: "", type: .int, value: n))
                    instRemoved += 1
                } else if let l = leader[str] {
                    i.replaced(by: l)
                    instRemoved += 1
                } else {
                    leader[str] = i
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
    init(v: Value, depth: Int = 4) {
        name = v.name
        if let i = v as? Inst {
            if let n = v.ccpInfo.constValue {
                name = "\(n)"
            } else if !(depth == 0 || i.isCritical) {
                op = i.operation
                if i is PhiInst {
                    for j in 0..<i.operands.count/2 where (i.operands[j*2 + 1] as! BasicBlock).reachable {
                        vals.append(VNExpression(v: i.operands[j*2], depth: depth - 1))
                        vals.append(VNExpression(v: i.operands[j*2 + 1], depth: depth - 1))
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
        vals.forEach {$0.sort()}
        vals.sort {"\($0)" < "\($1)"}
    }
    
    static let commutative: Set<Inst.OP> = [.add, .mul]
    static let opp = [Inst.OP.sub: Inst.OP.add]
    func deleteOpp() -> Bool {
        for l in vals { for r in vals where l.neg != r.neg && l.unsigned == r.unsigned {
            vals.removeAll {$0 === l}
            vals.removeAll {$0 === r}
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
        if op == .icmp {
            if vals.count > 0 {
                return dict[description]!.0 ? 1 : 0
            } else {
                return Int(name)!
            }
        } else if op == .xor {
            return vals[0].checkSatisfied(with: dict) ^ 1
        } else {
            var ret: Int? = nil
            for v in vals {
                ret = ret == nil ? v.checkSatisfied(with: dict) : Inst.OP.map[op]!(ret!, v.checkSatisfied(with: dict))
            }
            return ret ?? 1
        }
    }
    
    func addedPredicate(predicate: VNExpression) -> Bool {
        if predicate.op == .icmp && predicate.sop == .eq {
            let v = predicate.vals[0]
            switch v.op {
            case .add:
                for use in v.vals {
                    for old in vals where old.name == use.name {
                        print("|", description, predicate.description, terminator: " -> ")
                        let _des = description
                        for _new in v.vals where _new !== use {
                            let new = VNExpression(_new)
                            new.neg = (new.neg == old.neg) != use.neg
                            vals.append(new)
                        }
                        vals.removeAll {$0 === old}
                        print(description)
                        return description != _des
                    }
                }
            default:
                break
            }
        }
        return false
    }
    
    @discardableResult func simplified() -> Self {
        vals = vals.generated {
            if $0.vals.count > 0 {
                $0.simplified()
                if $0.vals.count == 1 && Inst.OP.map[$0.op] != nil {
                    return $0.vals[0]
                }
            }
            return $0
        }
        
        if let nop = VNExpression.normalCompare[sop] {
            vals[0].neg = vals[0].neg != true
            sop = nop
        }
        
        if let nop = VNExpression.opp[op] {
            vals[1].neg = vals[1].neg != true
            op = nop
        }
        if op == .phi {
            
            var res: Int? = nil, flag = true
            for j in 0..<vals.count/2 {
                if let n = getSubInt(v: vals[j]) {
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
            
            var res: Int? = nil
            vals = vals.generated {
                if let n = getSubInt(v: $0) {
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
            
            sort()
        }
        
        while deleteOpp() {}
        
        return self
    }
}
