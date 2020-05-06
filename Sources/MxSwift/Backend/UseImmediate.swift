//
//  UseImmediate.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/4/17.
//

import Foundation

extension Int {
    func getPower(of v: Int) -> Int? {
        var x = 1, p = 0
        while self >= x {
            if self == x {
                return p
            }
            x = x * v
            p = p + 1
        }
        return nil
    }
}

class UseImmediate {
    
    func work(on v: Assmebly) {
        for f in v.functions where !f.blocks.isEmpty {
            visit(v: f)
        }
    }
    
    let op: [InstRV.OP: InstRV.OP] = {
        var ret = [InstRV.OP: InstRV.OP]()
        for (a, b) in InstSelect.aop.values where b != nil {
            ret[a] = b!
        }
        for (a, b) in InstSelect.cop.values where b != nil {
            ret[a] = b!
        }
        return ret
    }()
    
    private func pro(_ i: InstRV) {
        if i.dst != nil && i.dst.con == nil {
            i.propogate()
            if i.dst.con != nil {
                for n in i.dst.uses {
                    pro(n)
                }
            }
        }
    }
    
    func visit(v: FunctionRV) {
        
        for reg in allRegs {
            reg.resetConst()
        }
        for b in v.blocks {
            for i in b.insts {
                pro(i)
            }
        }
        
//        let myzero = InstRV(.addi, in: v.blocks.first!, at: 1, to: Register(), RV32["zero"] ,Imm(0)).dst!
        for reg in allRegs where reg.con != nil && !RV32.regs.values.contains(reg) && InstSelect.immInBound(reg.con!) {
            assert(reg.defs.count <= 1)
            for u in reg.uses {
                print("   ", u, op[u.op], u.src)
                if (reg.con!) == 0 {
                    if u[0] === reg {
                        assert(u[0] === reg)
                        u.newSrc(RV32["zero"], at: 0)
                    } else {
                        assert(u[1] === reg)
                        u.newSrc(RV32["zero"], at: 1)
                    }
                }
                else
                    if let iver = op[u.op], u[1] === reg {
                    u.op = iver
                    u.newSrc(Imm(reg.con!), at: 1)
                }
                else if u.op == .mul, let p = reg.con!.getPower(of: 2) {
                    if u[0] === reg {
                        u.swapSrc()
                    }
                    assert(u[1] === reg)
                    u.op = .slli
                    u.newSrc(Imm(p), at: 1)
                }
            }
        }
        
        var workList = [InstRV]()
        for b in v.blocks {
            for i in b.insts where i.dst != nil && i.dst.uses.isEmpty {
                print("dead", i, i.dst, i.dst.uses)
                workList.append(i)
            }
        }
        while let i = workList.popLast() {
//            print("DEAD", v.name, i.inBlock.name, i)
//            print("            before", i.inBlock.insts.count, i.inBlock.insts.joined() {"\($0.op)"})
            i.disconnectUseDef()
            i.nodeInBlock.remove()
//            print("            after ", i.inBlock.insts.count, i.inBlock.insts.joined() {"\($0.op)"})
            for s in i.use where s.uses.isEmpty {
                for d in s.defs where d.inBlock.inFunction === v {
//                    print("NEW DEAD", d)
                    workList.append(d)
                }
            }
        }
        
//        for b in v.blocks {
//            for i in b.insts where i.op == .addi && i[0] === RV32["zero"] {
//                let val = (i[1] as! Imm).value
//                print("UseImm", val, i.dst, i.dst.uses)
//                for u in i.dst!.uses {
//                    if let iver = op[u.op] {
//                        if u[1] === i.dst {
//                            u.op = iver
//                            u.newSrc(Imm(val), at: 1)
//                        }
//                    } else if u.op == .mul, let p = val.getPower(of: 2) {
//                        if u[0] === i.dst {
//                            u.swapSrc()
//                        }
//                        assert(u[1] === i.dst)
//                        u.op = .slli
//                        u.newSrc(Imm(p), at: 1)
//                    }
//                }
//                print("   after", i.dst.uses)
//            }
//        }
    }
    
}
