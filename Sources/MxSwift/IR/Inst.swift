//
//  Inst.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/5.
//

import Foundation

class Inst: User {
    enum OP {
        case add, sub, mul, sdiv, srem, shl, ashr, and, or, xor, icmp, ret, alloca, call, load, store
    }
    let operation: OP
    var currentBlock: BasicBlock?
    
    init(name: String, type: Type, operation: OP) {
        self.operation = operation
        super.init(name: name, type: type)
    }
}

class ReturnInst: Inst {
    init(name: String, type: Type, val: Value) {
        super.init(name: name, type: type, operation: .ret)
        operands.append(val)
    }
    override var toPrint: String {return "\(operation) \(operands[0])"}
    override func accept(visitor: IRVisitor) {visitor.visit(v: self)}
}
class LoadInst: Inst {
    init(name: String, alloc: Value) {
        super.init(name: name, type: (alloc.type as! PointerT).baseType, operation: .load)
        operands.append(alloc)
    }
    override var toPrint: String {return "%\(name) = \(operation) \(type), \(operands[0]), align \((operands[0].type as! PointerT).baseType.align)"}
    override func accept(visitor: IRVisitor) {visitor.visit(v: self)}
}
class StoreInst: Inst {
    init(name: String, alloc: Value, val: Value) {
        super.init(name: name, type: (alloc.type as! PointerT).baseType, operation: .load)
        operands.append(val)
        operands.append(alloc)
    }
    override var toPrint: String {return super.toPrint + ", align \((operands[1].type as! PointerT).baseType.align)"}
    override func accept(visitor: IRVisitor) {visitor.visit(v: self)}
}
class CallInst: Inst {
    var function: Function
    init(name: String, type: Type, function: Function, arguments: [Value]) {
        self.function = function
        super.init(name: name, type: type, operation: .call)
        arguments.forEach {self.operands.append($0)}
    }
    override var toPrint: String {return "%\(name) = \(operation) \(type) @\(function.name)(\(operands))"}
    override func accept(visitor: IRVisitor) {visitor.visit(v: self)}
}
class AllocaInst: Inst {
    init(name: String, forType: Type) {
        super.init(name: name, type: PointerT(base: forType), operation: .alloca)
    }
    override var toPrint: String {return "%\(name) = \(operation) \((type as! PointerT).baseType.withAlign)"}
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
    override var toPrint: String {
        return "%\(name) = \(operation) \(type) " + operands.joined() {return "%\($0.name)"}
    }
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

