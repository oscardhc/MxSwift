//
//  Value.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/5.
//

import Foundation
    
class Value {
    
    var users = List<User>()
    var name: String
    var type: Type
    
    init(name: String, type: Type) {
        self.name = name
        self.type = type
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
    
    init(name: String, type: Type, curfunc: Function?) {
        self.currentFunction = curfunc
        super.init(name: name, type: type)
    }
    
}
