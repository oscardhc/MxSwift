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

    init(name: String, type: Type) {
        self._name = name
        self.type = type
    }
    
    var _name: String
    var basename: String {
        if _name == "" {
            _name = counter.tik
        }
        return _name
    }
    var name: String {return prefix + basename}
    
    var description: String {return "\(type) \(name)"}
    var toPrint: String {return "NOTHING"}
    
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
    var currentFunction: Function?
    override var prefix: String {return ""}
    
    override var description: String {
        return super.description + "\n>>>" + inst.description + "<<<"
    }
    
    init(name: String, type: Type, curfunc: Function?) {
        self.currentFunction = curfunc
        super.init(name: name, type: type)
    }
    
    func create(_ i: Inst) -> Inst {
        inst.append(i)
        return i
    }
    
    func create(_ f: (() -> Inst)) -> Inst {
        let i = f()
        inst.append(i)
        return i
    }
    
//    override var name: String {return }
    override func accept(visitor: IRVisitor) {visitor.visit(v: self)}
    
}
