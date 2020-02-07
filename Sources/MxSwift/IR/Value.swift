//
//  Value.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/5.
//

import Foundation
    
var nameCount = 0

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
            _name = "\(nameCount)"
            nameCount += 1
        }
        return _name
    }
    
    var description: String {
        return "\(type) %\(name)"
    }
    
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
