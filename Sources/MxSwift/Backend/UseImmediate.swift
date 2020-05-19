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
            immToReg(v: f)
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
                if (reg.con!) == 0 {
                    if u.op == .add {
                        if u[0] === reg {
                            assert(u[0] === reg)
                            u.delSrc(at: 0)
                        }
                        else {
                            assert(u[1] === reg)
                            u.delSrc(at: 1)
                        }
                        u.op = .mv
                    }
                    else if u.op != .mv {
                        print("const zero", reg, u)
                        if u[0] === reg {
                            assert(u[0] === reg)
                            u.newSrc(RV32["zero"], at: 0)
                        }
                        else {
                            assert(u[1] === reg)
                            u.newSrc(RV32["zero"], at: 1)
                        }
                        print("          ", u)
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
        
    }
    
    func immToReg(v: FunctionRV) {
        var immRegs = [Int: (Double, Set<Register>)]()
        
        for b in v.blocks {
            for i in b.insts where i.op == .li && i.dst!.defs.count == 1 {
                let val = (i[0] as! Imm).value
                if immRegs[val] == nil {
                    immRegs[val] = (0.0, [])
                }
                immRegs[val]!.0 += pow(10.0, Double(i.inBlock.loopDepth))
                immRegs[val]!.1.insert(i.dst!)
            }
        }
        
        for (val, regs) in immRegs where regs.0 >= 100.0 {
            print(val, regs.0, regs.1)
            let r = InstRV(.li, in: v.blocks.first!, at: 14, to: Register(), Imm(val)).dst!
            for old in regs.1 {
                for u in old.uses {
                    for idx in 0..<10 where u[idx] === old {
                        u.newSrc(r, at: idx)
                        break
                    }
                }
            }
        }
        
    }
    
}
