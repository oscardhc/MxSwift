//
//  Value.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/5.
//

import Foundation
    
class Counter {
    
    var count = [String: Int]()
    
    func tikInt(_ id: String = "") -> Int {
        if count[id] == nil {
            count[id] = -1
        }
        count[id]! += 1
        return count[id]!
    }
    func tik(_ id: String = "") -> String {"\(tikInt(id))"}
    func reset() {
        count = [:]
    }
    
}

let instNamingCounter = Counter()

struct Tuple<T: Hashable, U: Hashable>: Hashable {
    let a: T, b: T
}

class Value: HashableObject, CustomStringConvertible, Hashable {
    
    static func == (lhs: Value, rhs: Value) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
    var users = List<Use>()
    
    var type: Type
    var prefix: String {return "%"}
    
    var originName: String
    var basename = "*"
    func initName() {
        basename = (originName == "" || originName.hasSuffix("."))
            ? originName + instNamingCounter.tik(originName)
            : originName
    }
    
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
    
    func pairWithValue(_ value: Value) -> Tuple<Value, Value> {
        Tuple<Value, Value>(a: self, b: value)
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
//    func reconnect(toUser new: User) {
//
//    }
    
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
    
    var insts = List<Inst>()
    
    var inFunction: Function
//    var terminated = false
    
    var nodeInFunction: List<BasicBlock>.Node?
    
    init(name: String = "", type: Type = LabelT(), curfunc: Function) {
        self.inFunction = curfunc
        super.init(name: "b.", type: type)
        nodeInFunction = inFunction.append(self)
    }
    
    func added(_ i: Inst) -> List<Inst>.Node {
        return insts.append(i)
    }
    func inserted(_ i: Inst, at idx: Int) -> List<Inst>.Node {
        return insts.insert(i, at: idx)
    }
    
//    will delete all instructions and their uses
    func remove(dealWithInsts: ((Inst) -> Void) = {_ in }) {
        succs.forEach { (b) in
            (b as! BasicBlock).preds.removeAll(where: {$0 === b})
        }
        insts.forEach(dealWithInsts)
        nodeInFunction?.remove()
    }
    
//    *************** for domtree use ****************
    var succs: [Value] {
        if insts.last == nil {
            return []
        }
        switch insts.last! {
        case let v as BrInst:
            if v.operands.count > 1 {
                return [v.operands[1], v.operands[2]]
            } else {
                return [v.operands[0]]
            }
        default:
            return []
        }
    }
    var domNode: DomTree.Node? = nil
    var preds = [BasicBlock]()
    
    override func accept(visitor: IRVisitor) {visitor.visit(v: self)}
    
}
