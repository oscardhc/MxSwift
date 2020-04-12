//
//  Value.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/5.
//

import Foundation

let instNamingCounter = Counter()

class Value: HashableObject, CustomStringConvertible, Hashable {
    
    static func == (lhs: Value, rhs: Value) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
    public private(set) var users = List<Use>()
    
    var type: TypeIR
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
    
    init(name: String = "", type: TypeIR) {
        if name.unicodeScalars.filter({$0.isASCII}).count == name.count {
            self.originName = name
        } else {
            self.originName = "unicode." + instNamingCounter.tik()
        }
        self.basename = self.originName
        self.type = type
    }
    
    func accept(visitor: IRVisitor) {}
    
    var forceDoNotLoad: Bool = false
    var isAddress: Bool {
        !forceDoNotLoad && (self is AllocaInst || self is GEPInst || self is GlobalVariable)
    }
    func loadIfAddress(block: BlockIR) -> Value {
        self.isAddress ? LoadInst(name: "", alloc: self, in: block) : self
    }
    
    //    *************** for SCCP ****************
    struct CCPInfo {
        enum T {
            case int, unknown, variable
        }
        var type: T = .unknown
        var int: Int? = nil
        
        var constValue: Int? {
            type == .int ? int! : nil
        }
        
        func add(rhs: CCPInfo, f: ((CCPInfo, CCPInfo) -> CCPInfo?)) -> CCPInfo {
            switch (type, rhs.type) {
            case (_, .variable), (.variable, _):
                return CCPInfo(type: .variable)
            case (_, .unknown):
                return self
            case (.unknown, _):
                return rhs
            default:
                //                f: assume type is now equal
                return type != rhs.type
                    ? CCPInfo(type: .variable)
                    : (f(self, rhs) ?? CCPInfo(type: .variable))
            }
        }
        static func == (lhs: CCPInfo, rhs: CCPInfo) -> Bool {
            return lhs.type == rhs.type && lhs.int == rhs.int
        }
    }
    var ccpInfo = CCPInfo()
    var isVariable: Bool {ccpInfo.type == .variable}
    func propogate() {}
    
    var constInt: Int?
    
    //    **************** for VN ****************
    var rank = -1
    
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

class BlockIR: Value {
    
    public private(set) var insts = List<InstIR>()
    
    var inFunction: FunctionIR
    //    var terminated = false
    
    private var nodeInFunction: List<BlockIR>.Node?
    
    init(name: String = "", curfunc: FunctionIR) {
        self.inFunction = curfunc
        super.init(name: "b.", type: LabelT())
        nodeInFunction = inFunction.append(self)
    }
//    override var name: String {super.name + "|\(hashValue)"}
    
    func added(_ i: InstIR) -> List<InstIR>.Node {
        return insts.append(i)
    }
    func inserted(_ i: InstIR, at idx: Int) -> List<InstIR>.Node {
        return insts.insert(i, at: idx)
    }
    
    //    will delete all instructions and their uses
    func remove(dealWithInsts: ((InstIR) -> Void) = {_ in }) {
        print("remove BB!!!")
        succs.forEach { (s) in
            s.preds.removeAll(where: {$0 === self})
            for p in preds {
                s.preds.append(p)
            }
        }
        insts.forEach(dealWithInsts)
        nodeInFunction?.remove()
    }
    
    //    *************** for domtree use ****************
    var succs: [BlockIR] {
        if insts.last == nil {
            return []
        }
        switch insts.last! {
        case let v as BrInst:
            if v.operands.count > 1 {
                return [v[1] as! BlockIR, v[2] as! BlockIR]
            } else {
                return [v[0] as! BlockIR]
            }
        default:
            return []
        }
    }
    
    var preds = [BlockIR]()
    
    //    ************** for SCCP ***************
    var reachable: Bool = false
    
    override func accept(visitor: IRVisitor) {visitor.visit(v: self)}
    
//    *************** for VN **************
    struct Edge: Hashable {
        var from, to: BlockIR
//        var 
    }
    
}
