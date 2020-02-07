//
//  Inst.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/5.
//

import Foundation

class Inst: User {
    
    enum OP {
        case add, sub, mul, sdiv, srem, shl, ashr, and, or, xor, icmp, ret, alloca
    }
    let operation: OP
    var currentBlock: BasicBlock?
    
    init(name: String, type: Type, operation: OP) {
        self.operation = operation
        super.init(name: name, type: type)
    }
    override var description: String {
        var ret = "%\(name) = \(operation) \(type)"
        operands.forEach {ret += " %\($0.name)"}
        return ret
    }
    
}

class ReturnInst: Inst {
    init(name: String, type: Type, val: Value) {
        super.init(name: name, type: type, operation: .ret)
        operands.append(val)
    }
    override func accept(visitor: IRVisitor) {visitor.visit(v: self)}
    override var description: String {return "return \(operands[0])"}
}

class AllocaInst: Inst {
    init(name: String, forType: Type) {
        super.init(name: name, type: PointerT(base: forType), operation: .alloca)
    }
    override func accept(visitor: IRVisitor) {visitor.visit(v: self)}
}

class UnaryInst: Inst {
    
}

class BinaryInst: Inst {
    init(name: String, type: Type, operation: Inst.OP, lhs: Value, rhs: Value) {
        super.init(name: name, type: type, operation: operation)
        operands.append(lhs)
        operands.append(rhs)
    }
    override func accept(visitor: IRVisitor) {visitor.visit(v: self)}
}

class CompareInst: BinaryInst {
    enum CMP {
        case eq, ne, sgt, sge, slt, sle
    }
    let cmp: CMP
    init(name: String, type: Type, operation: Inst.OP, lhs: Value, rhs: Value, cmp: CMP) {
        self.cmp = cmp
        super.init(name: name, type: type, operation: operation, lhs: lhs, rhs: rhs)
    }
    override func accept(visitor: IRVisitor) {visitor.visit(v: self)}
}

