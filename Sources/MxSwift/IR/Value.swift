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
    var toPrint: String {return "??????????????"}
    
    init(name: String, type: Type) {
        self.originName = name
        self.basename = self.originName
        self.type = type
    }
    
    var isAddress: Bool {self is AllocaInst || self is GEPInst || self is GlobalVariable}
    var isTerminate: Bool {self is BrInst || self is ReturnInst}
    func accept(visitor: IRVisitor) {}
    
    func loadIfAddress(block: BasicBlock) -> Value {
        self.isAddress ? LoadInst(name: "", alloc: self, in: block) : self
    }
}

//class Use {
//
//    let usee: Value
//    let user: User
//
//    init(usee: Value, user: User) {
//        self.usee = usee
//        self.user = user
//    }
//
//}

class User: Value {
    
    var operands = List<Value>()
    
    @discardableResult func added(operand: Value) -> Self {
        _ = operands.append(operand)
        _ = operand.users.append(self)
        return self
    }
    @discardableResult func inserted(operand: Value) -> Self {
        _ = operands.insert(operand, at: 0)
        _ = operand.users.insert(self, at: 0)
        return self
    }
    
}

class BasicBlock: Value {
    
    var inst = List<Inst>()
    var currentFunction: Function
    var terminated = false
    
    var nodeInFunction: List<BasicBlock>.Node?
    
    init(name: String = "", type: Type = IRLabel(), curfunc: Function) {
        self.currentFunction = curfunc
        super.init(name: "", type: type)
        nodeInFunction = currentFunction.append(self)
    }
    
    func added(_ i: Inst) -> List<Inst>.Node? {
        if terminated == false {
            if i.isTerminate {
                terminated = true
            }
            return inst.append(i)
        }
        return nil
    }
    
    override func accept(visitor: IRVisitor) {visitor.visit(v: self)}
    
}
