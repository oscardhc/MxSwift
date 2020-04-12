//
//  InstRV.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/4/8.
//

import Foundation

protocol OperandConvertable {
    var getOP: OperandRV {get}
}

extension Int: OperandConvertable {
    var getOP: OperandRV {Imm(self)}
}

class OperandRV: CustomStringConvertible, OperandConvertable {
    var description: String {"?"}
    var getOP: OperandRV {self}
}

class Imm: OperandRV {
    var value: Int
    override var description: String {"\(value)"}
    init(_ v: Int) {
        value = v
    }
}

class OffsetReg: OperandRV {
    var reg: Register
    var offset: Int
    init(_ reg: Register, offset: Int) {
        self.reg = reg
        self.offset = offset
    }
}

class InstRV: CustomStringConvertible, OperandConvertable {
    
    enum OP {
        case lui, auipc, jal, jalr, beq, bne, blt, bge, bltu, bgeu
        case lb, lh, lw, lbu, lhu, sb, sh, sw
        case addi, slti, sltiu, xori, ori, andi, slli, srli, srai
        case add, sub, sll, slt, sltu, xor, srl, sra, or, and
        case mul, mulh, mulhsu, mulhu, div, divu, rem, remu
        // pseudo
        case bgt, ble, j, ret, sgt, mv, call
        // not even pseudo MUST BE ADJUSTED WHEN OUTPUT!
        case subi
    }
    
    var description: String {
        "\(op)"
    }
    
    var op: OP
    private(set) var dst : Register!
    private(set) var src = List<OperandRV>()
    var getOP: OperandRV {dst}
    subscript(idx: Int) -> OperandRV {src[idx]}
    
    var inBlock: BlockRV
    var nodeInBlock: List<InstRV>.Node!
    
    @discardableResult init(op: OP, in block: BlockRV, at index: Int = -1) {
        self.op = op
        self.inBlock = block
        if index == -1 {
            self.nodeInBlock = block.inst.append(self)
        } else {
            self.nodeInBlock = block.inst.insert(self, at: index)
        }
    }
    
    @discardableResult func d(_ d: Register) -> Self {dst = d; return self;}
    @discardableResult func s(_ s: OperandConvertable) -> Self {src.append(s.getOP); return self;}
    
}

class BlockRV: CustomStringConvertible {
    
    var inst = List<InstRV>()
    var description: String {""}
    var inFunction: FunctionRV
    
    init(in f: FunctionRV) {
        inFunction = f
        inFunction.blocks.append(self)
    }

}

class FunctionRV: OperandRV {
    
    var blocks = List<BlockRV>()
    override var description: String {"[function sp \(stackSize)]"}
    
    var stackSize: Int = 0
    
    func newVar() -> OffsetReg {
        stackSize += 4
        return OffsetReg(RV32["sp"], offset: stackSize-4)
    }
    
}
