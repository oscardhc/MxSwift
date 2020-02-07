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

    init(name: String, type: Type) {
        self._name = name
        self.type = type
    }
    
    private var _name: String
    var name: String {
        if _name == "" {
            _name = counter.tik
        }
        return _name
    }
    
    var description: String {return "\(type) %\(name)"}
    var toPrint: String {return "NOTHING"}
    
    func accept(visitor: IRVisitor) {}
}

class User: Value {
    
    var operands = List<Value>()
    
}

class BasicBlock: Value {
    
    var inst = List<Inst>()
    var functions = List<Function>()
    var currentFunction: Function?
    override var description: String {
        return super.description + "\n>>>" + inst.description + "<<<"
    }
    
    init(name: String, type: Type, curfunc: Function?) {
        self.currentFunction = curfunc
        super.init(name: name, type: type)
    }
    
    override func accept(visitor: IRVisitor) {visitor.visit(v: self)}
    
}
