//
//  Value.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/5.
//

import Foundation
    
class UnnamedCounter {
    var count = -1
    var tik: String {
        count += 1
        return "\(count)"
    }
    func reset() {
        count = -1
    }
}

let counter = UnnamedCounter()

class Value: HashableObject, CustomStringConvertible {
    
    var users = List<User>()
    var type: Type
    var prefix: String {return "%"}
    
    var originName: String
    var basename = "*"
    func initName() {basename = originName == "" ? counter.tik : originName}
    
    var name: String {return prefix + basename}
    var description: String {return "\(type) \(name)"}
    var toPrint: String {return "NOTHING"}
    
    init(name: String, type: Type) {
        self.originName = name
        self.basename = self.originName
        self.type = type
    }
    
    var isAddress: Bool {self is AllocaInst || self is GEPInst}
    var isTerminate: Bool {self is BrInst || self is ReturnInst}
    func accept(visitor: IRVisitor) {}
}

class Instant: Value {
    var value: Int
    init(name: String, type: Type, value: Int) {
        self.value = value
        super.init(name: name, type: type)
    }
    override func initName() {}
    override var name: String {return "\(value)"}
    override var description: String {return "\(type) \(value)"}
}
class VoidInstant: Value {
    override func initName() {}
    override var description: String {"void"}
}

class User: Value {
    
    var operands = List<Value>()
    func added(operand: Value) -> Self {
        operands.append(operand)
        return self
    }
    
}

class BasicBlock: Value {
    
    var inst = List<Inst>()
    var functions = List<Function>()
    var currentFunction: Function
    var terminated = false
    
    init(name: String, type: Type, curfunc: Function) {
        self.currentFunction = curfunc
        super.init(name: "", type: type)
    }
    
    func create(_ i: Inst) {
        if terminated == false {
            inst.append(i)
            if i.isTerminate {
                terminated = true
            }
        }
    }
    
    override func accept(visitor: IRVisitor) {visitor.visit(v: self)}
    
}
