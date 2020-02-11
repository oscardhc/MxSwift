//
//  Inst.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/5.
//

import Foundation

class Inst: User {
    enum OP {
        case add, sub, mul, sdiv, srem, shl, ashr, and, or, xor, icmp, ret, alloca, call, load, store, getelementptr, br, bitcast
    }
    let operation: OP
    var currentBlock: BasicBlock
    
    init(name: String, type: Type, operation: OP, in block: BasicBlock) {
        self.operation = operation
        self.currentBlock = block
        super.init(name: name, type: type)
        currentBlock.create(self)
    }
    
//    @discardableResult func addedTo(block: BasicBlock) -> Self {
//        block.create(self)
//        return self
//    }
}

class CastInst: Inst {
    init (name: String, val: Value, toType: Type, in block: BasicBlock) {
        super.init(name: name, type: toType, operation: .bitcast, in: block)
        self.operands.append(val)
    }
    override var toPrint: String {"\(name) = \(operation) \(operands[0]) to \(type)"}
    override func accept(visitor: IRVisitor) {visitor.visit(v: self)}
}
class BrInst: Inst {
    @discardableResult init(name: String, des: Value, in block: BasicBlock) {
        super.init(name: name, type: Type(), operation: .br, in: block)
        operands.append(des)
    }
    @discardableResult init(name: String, condition: Value, accept: Value, reject: Value, in block: BasicBlock) {
        super.init(name: name, type: Type(), operation: .br, in: block)
        operands.append(condition)
        operands.append(accept)
        operands.append(reject)
    }
    override func initName() {}
    override var toPrint: String {"\(operation) " + operands.joined()}
    override func accept(visitor: IRVisitor) {visitor.visit(v: self)}
}
class GEPInst: Inst {
    let needZero: Bool
    init(name: String, type: Type, base: Value, needZero: Bool, val: Value, in block: BasicBlock) {
        self.needZero = needZero
        super.init(name: name, type: type, operation: .getelementptr, in: block)
        operands.append(base)
        operands.append(val)
    }
    override var toPrint: String {"\(name) = \(operation) \((type as! IRPointer).baseType), \(operands[0]), \(operands[1])"}
    override func accept(visitor: IRVisitor) {visitor.visit(v: self)}
}
class ReturnInst: Inst {
    @discardableResult init(name: String, val: Value, in block: BasicBlock) {
        super.init(name: name, type: IRVoid(), operation: .ret, in: block)
        operands.append(val)
    }
    override func initName() {}
    override var toPrint: String {"\(operation) \(operands[0])"}
    override func accept(visitor: IRVisitor) {visitor.visit(v: self)}
}
class LoadInst: Inst {
    init(name: String, alloc: Value, in block: BasicBlock) {
        super.init(name: name, type: (alloc.type as! IRPointer).baseType, operation: .load, in: block)
        operands.append(alloc)
    }
    override var toPrint: String {"\(name) = \(operation) \(type), \(operands[0]), align \((operands[0].type as! IRPointer).baseType.align)"}
    override func accept(visitor: IRVisitor) {visitor.visit(v: self)}
}
class StoreInst: Inst {
    @discardableResult init(name: String, alloc: Value, val: Value, in block: BasicBlock) {
        super.init(name: name, type: Type(), operation: .store, in: block)
        operands.append(val)
        operands.append(alloc)
    }
    override func initName() {}
    override var toPrint: String {"\(operation) " + operands.joined() + ", align \((operands[1].type as! IRPointer).baseType.align)"}
    override func accept(visitor: IRVisitor) {visitor.visit(v: self)}
}
class CallInst: Inst {
    var function: Function
    init(name: String, function: Function, arguments: [Value] = [], in block: BasicBlock) {
        self.function = function
        super.init(name: name, type: function.type, operation: .call, in: block)
        arguments.forEach {self.operands.append($0)}
    }
    override var toPrint: String {"\(name) = \(operation) \(type) \(function.name)(\(operands))"}
    override func accept(visitor: IRVisitor) {visitor.visit(v: self)}
}
class AllocaInst: Inst {
    init(name: String, forType: Type, in block: BasicBlock) {
        super.init(name: name, type: IRPointer(base: forType), operation: .alloca, in: block)
    }
    override var toPrint: String {"\(name) = \(operation) \((type as! IRPointer).baseType.withAlign)"}
    override func accept(visitor: IRVisitor) {visitor.visit(v: self)}
}
class UnaryInst: Inst {
    
}
class BinaryInst: Inst {
    init(name: String, type: Type, operation: Inst.OP, lhs: Value, rhs: Value, in block: BasicBlock) {
        super.init(name: name, type: type, operation: operation, in: block)
        operands.append(lhs)
        operands.append(rhs)
    }
    override var toPrint: String {return "\(name) = \(operation) \(type) " + operands.joined() {"\($0.name)"}}
    override func accept(visitor: IRVisitor) {visitor.visit(v: self)}
}

class CompareInst: BinaryInst {
    enum CMP {
        case eq, ne, sgt, sge, slt, sle
    }
    let cmp: CMP
    init(name: String, operation: Inst.OP, lhs: Value, rhs: Value, cmp: CMP, in block: BasicBlock) {
        self.cmp = cmp
        super.init(name: name, type: IRInt.bool, operation: operation, lhs: lhs, rhs: rhs, in: block)
    }
    override var toPrint: String {return "\(name) = \(operation) \(cmp) \(operands[0].type) " + operands.joined() {"\($0.name)"}}
    override func accept(visitor: IRVisitor) {visitor.visit(v: self)}
}

