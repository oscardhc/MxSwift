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
                let str = "[\(i.operation) " + i.operands.joined() {
                    $0 is Inst ? "<\($0.toPrint)>" : "<\($0)>"
                } + "]"
                if let p = cseMap[str] {
//                    print(">", i.toPrint, str)
//                    print("  <", p.toPrint)
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
    
    func valueNumbering(f: Function) {
        
        func getCanonical(v: Value, depth: Int) -> [String] {
            if depth == 0 || (v is Inst && (v as! Inst).isCritical) || !(v is User) {
                return ["\(v)"]
            } else {
                let i = v as! User
                var ops = [[String]]()
                for op in i.operands {
                    ops.append(getCanonical(v: op, depth: depth - 1))
                }
                return []
            }
        }
        
    }
    
}
