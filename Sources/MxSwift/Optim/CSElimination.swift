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
                print(i.toPrint)
                let str = VNExpression(v: i, depth: -1).description
                print(i.toPrint, str)
                if let p = cseMap[str] {
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

class VNExpression: CustomStringConvertible {
    var op = Inst.OP.add // just nonsence init
    var name: String
    var neg = false
    var val = [VNExpression]() // be careful that there should be NO same expression references
    
    var unsigned: String {
        val.count > 0 ? ("(\(op) " + val.joined() + ")") : name
    }
    var description: String {
        (neg ? "-" : "") + unsigned
    }
    static func == (l: VNExpression, r: VNExpression) -> Bool {
        l.description == r.description
    }
    
    init(v: Value, depth: Int = 4) {
        name = v.name
        if let i = v as? Inst {
            if !(depth == 0 || i.isCritical) {
                op = i.operation
                if i is PhiInst {
                    for j in 0..<i.operands.count / 2 where (i.operands[j * 2 + 1] as! BasicBlock).executable {
                        val.append(VNExpression(v: i.operands[j * 2], depth: depth - 1))
                        val.append(VNExpression(v: i.operands[j * 2 + 1], depth: depth - 1))
                    }
                } else {
                    for o in i.operands {
                        val.append(VNExpression(v: o, depth: depth - 1))
                    }
                }
            }
        }
        simplify()
    }
    init(i: Int) {
        name = "\(i)"
    }
    
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
    
    private func simplify() { // can only be operated once
        val = val.generated {
            if $0.val.count != 0 {
                $0.simplify()
                if $0.val.count == 1 {
                    return $0.val[0]
                }
            }
            return $0
        }

        if let nop = VNExpression.opp[op] {
            val[1].neg = true
            op = nop
        }
        
        if VNExpression.commutative.contains(op) {
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
            
            if Inst.OP.map[op] != nil {
                for e in val where e.op == op && e.val.count > 0 {
                    for subE in e.val {
                        val.append(subE)
                    }
                    val.removeAll {$0 === e}
                }
            }
            
            sort()
        }
        
        while deleteOpp() {}
        
    }
}
