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
    
    var users = List<Use>()
    
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

class Use: CustomStringConvertible {
    
    var deleted: Bool = false
    var value: Value
    var user: User
    var nodeInValue: List<Use>.Node!
    var nodeInUser: List<Use>.Node!
    var nodeAsOperand: List<Value>.Node!
    
    func connect(toInsert: Int) {
        nodeInValue = value.users.append(self)
        if toInsert < 0 {
            nodeInUser = user.usees.append(self)
            nodeAsOperand = user.operands.append(value)
        } else {
            nodeInUser = user.usees.insert(self, at: toInsert)
            nodeAsOperand = user.operands.insert(value, at: toInsert)
        }
    }
    
    func disconnect() {
        if !deleted {
            nodeInUser.remove()
            nodeInValue.remove()
            nodeAsOperand.remove()
            deleted = true
        }
    }
    
    // Value -> User
    func reconnect(fromValue new: Value) {
        nodeAsOperand.value = new
        value = new
        nodeInValue.remove()
        nodeInValue = new.users.append(self)
    }
    func reconnect(toUser new: User) {
        
    }
    
    init(value: Value, user: User, toInsert: Int = -1) {
        self.value = value
        self.user = user
        connect(toInsert: toInsert)
    }
    
    var description: String {value.description}
    
}

class User: Value {
    
    var usees = List<Use>()
    var operands = List<Value>()
    
    @discardableResult func added(operand: Value) -> Self {
        _ = Use(value: operand, user: self)
        return self
    }
    @discardableResult func inserted(operand: Value) -> Self {
        _ = Use(value: operand, user: self, toInsert: 0)
        return self
    }
    
    // directly subscript can get certain operand(Value, not Use)
    subscript(index: Int) -> Value {
        return operands[index]
    }
    
}

class BasicBlock: Value {
    
    var inst = List<Inst>()
    var currentFunction: Function
    var terminated = false
    
    var nodeInFunction: List<BasicBlock>.Node?
    
    init(name: String = "", type: Type = LabelT(), curfunc: Function) {
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
//        print("WARNING: Inserting into a terminated block!")
        return nil
    }
    
    override func accept(visitor: IRVisitor) {visitor.visit(v: self)}
    
}
