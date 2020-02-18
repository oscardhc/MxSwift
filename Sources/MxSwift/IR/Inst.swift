//
//  Inst.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/5.
//

import Foundation

class Inst: User {
    
    enum OP {
        case add, sub, mul, sdiv, srem, shl, ashr, and, or, xor, icmp, ret, alloca, call, load, store, getelementptr, br, bitcast, sext, phi
    }
    let operation: OP
    var inBlock: BasicBlock
    
    var nodeInBlock: List<Inst>.Node? = nil
    
    func disconnect(delUsee: Bool, delUser: Bool) {
        nodeInBlock?.remove()
        if delUsee {
            for usee in usees {
                usee.disconnect()
            }
        }
        if delUser {
            for user in users {
                user.disconnect()
            }
        }
    }
    
    func replacedBy(value: Value) {
        for use in users {
            use.reconnect(fromValue: value)
        }
        disconnect(delUsee: true, delUser: false)
    }
    
    init(name: String, type: Type, operation: OP, in block: BasicBlock, at index: Int = -1) {
        self.operation = operation
        self.inBlock = block
        super.init(name: name, type: type)
        if index == -1 {
            self.nodeInBlock = inBlock.added(self)
        } else {
            self.nodeInBlock = inBlock.inserted(self, at: index)
        }
    }
}

class PhiInst: Inst {
    init (name: String, type: Type, in block: BasicBlock, at index: Int = -1) {
        super.init(name: name, type: type, operation: .phi, in: block, at: index)
    }
    override var toPrint: String {
        var ret = "\(name) = \(operation) \(type) ", idx = 0
        while idx < operands.count {
            if idx != 0 {
                ret += ", "
            }
            ret += "[\(operands[idx].name), \(operands[idx + 1].name)]"
            idx += 2
        }
        return ret
    }
    override func accept(visitor: IRVisitor) {visitor.visit(v: self)}
}
class SExtInst: Inst {
    init (name: String, val: Value, toType: Type, in block: BasicBlock) {
        super.init(name: name, type: toType, operation: .sext, in: block)
        added(operand: val)
    }
    override var toPrint: String {"\(name) = \(operation) \(operands[0]) to \(type)"}
    override func accept(visitor: IRVisitor) {visitor.visit(v: self)}
}
class CastInst: Inst {
    init (name: String, val: Value, toType: Type, in block: BasicBlock) {
        super.init(name: name, type: toType, operation: .bitcast, in: block)
        added(operand: val)
    }
    override var toPrint: String {"\(name) = \(operation) \(operands[0]) to \(type)"}
    override func accept(visitor: IRVisitor) {visitor.visit(v: self)}
}
class BrInst: Inst {
    @discardableResult init(name: String, des: Value, in block: BasicBlock) {
        super.init(name: name, type: Type(), operation: .br, in: block)
        added(operand: des)
    }
    @discardableResult init(name: String, condition: Value, accept: Value, reject: Value, in block: BasicBlock) {
        super.init(name: name, type: Type(), operation: .br, in: block)
        added(operand: condition)
        added(operand: accept)
        added(operand: reject)
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
        added(operand: base)
        added(operand: val)
    }
    override var toPrint: String {"\(name) = \(operation) \((operands[0].type as! PointerT).baseType), \(operands[0]),\(needZero ? " i32 0," : "") \(operands[1])"}
    override func accept(visitor: IRVisitor) {visitor.visit(v: self)}
}
class ReturnInst: Inst {
    @discardableResult init(name: String, val: Value, in block: BasicBlock) {
        super.init(name: name, type: VoidT(), operation: .ret, in: block)
        added(operand: val)
    }
    override func initName() {}
    override var toPrint: String {"\(operation) \(operands[0])"}
    override func accept(visitor: IRVisitor) {visitor.visit(v: self)}
}
class LoadInst: Inst {
    init(name: String, alloc: Value, in block: BasicBlock) {
        super.init(name: name, type: (alloc.type as! PointerT).baseType, operation: .load, in: block)
        added(operand: alloc)
    }
    override var toPrint: String {"\(name) = \(operation) \(type), \(operands[0]), align \((operands[0].type as! PointerT).baseType.space)"}
    override func accept(visitor: IRVisitor) {visitor.visit(v: self)}
}
class StoreInst: Inst {
    @discardableResult init(name: String, alloc: Value, val: Value, in block: BasicBlock) {
        super.init(name: name, type: Type(), operation: .store, in: block)
        added(operand: val)
        added(operand: alloc)
    }
    override func initName() {}
    override var toPrint: String {"\(operation) " + operands.joined() + ", align \((operands[1].type as! PointerT).baseType.space)"}
    override func accept(visitor: IRVisitor) {visitor.visit(v: self)}
}
class CallInst: Inst {
    var function: Function
    init(name: String, function: Function, arguments: [Value] = [], in block: BasicBlock) {
        self.function = function
        super.init(name: name, type: function.type, operation: .call, in: block)
        arguments.forEach {self.added(operand: $0)}
    }
    override func initName() {
        if !(type is VoidT) {
            super.initName()
        }
    }
    override var toPrint: String {"\(type is VoidT ? "" : "\(name) = ")\(operation) \(type) \(function.name)(\(operands))"}
    override func accept(visitor: IRVisitor) {visitor.visit(v: self)}
}
class AllocaInst: Inst {
    init(name: String, forType: Type, in block: BasicBlock) {
        super.init(name: name, type: forType.pointer, operation: .alloca, in: block)
    }
    override var toPrint: String {"\(name) = \(operation) \((type as! PointerT).baseType.withAlign)"}
    override func accept(visitor: IRVisitor) {visitor.visit(v: self)}
}
class UnaryInst: Inst {
    
}
class BinaryInst: Inst {
    init(name: String, type: Type, operation: Inst.OP, lhs: Value, rhs: Value, in block: BasicBlock) {
        super.init(name: name, type: type, operation: operation, in: block)
        added(operand: lhs)
        added(operand: rhs)
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
        super.init(name: name, type: IntT.bool, operation: operation, lhs: lhs, rhs: rhs, in: block)
    }
    override var toPrint: String {return "\(name) = \(operation) \(cmp) \(operands[0].type) " + operands.joined() {"\($0.name)"}}
    override func accept(visitor: IRVisitor) {visitor.visit(v: self)}
}

