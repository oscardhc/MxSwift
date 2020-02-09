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
        self.basename = name
        self.type = type
    }
    
    var isAddress: Bool {self is AllocaInst}
    var isTerminate: Bool {self is BrInst || self is ReturnInst}
    func accept(visitor: IRVisitor) {}
}

class Instant: Value {
    var value: Int
    init(name: String, type: Type, value: Int) {
        self.value = value
        super.init(name: name, type: type)
    }
    override var name: String {return "\(value)"}
    override var description: String {return "\(type) \(value)"}
}

class User: Value {
    
    var operands = List<Value>()
    
}

class BasicBlock: Value {
    
    var inst = List<Inst>()
    var functions = List<Function>()
    var currentFunction: Function
    var terminated = false
    
    init(name: String, type: Type, curfunc: Function) {
        self.currentFunction = curfunc
        super.init(name: name, type: type)
    }
    
    func create(_ i: Inst) -> Inst {
        inst.append(i)
        return i
    }
    
    override func accept(visitor: IRVisitor) {visitor.visit(v: self)}
    
}
