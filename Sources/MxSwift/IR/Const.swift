//
//  Const.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/6.
//

import Foundation

class Const: User {
    
}

class IntConst: Const {
    var value: Int
    init(name: String, type: Type, value: Int) {
        self.value = value
        super.init(name: name, type: type)
    }
    override func initName() {}
    override var name: String {return "\(value)"}
    override var description: String {return "\(type) \(value)"}
}
class VoidConst: Const {
    override func initName() {}
    override var description: String {"void"}
}
class NullConst: Const {
    override func initName() {}
    override var name: String {"null"}
}

class Global: Const {
    
    var currentModule: Module
    override var prefix: String {return "@"}
    
    init(name: String, type: Type, module: Module) {
        self.currentModule = module
        super.init(name: name, type: type)
    }
    
}

class Function: Global {
    
    var blocks = List<BasicBlock>()
    var attribute: String
    
    override func accept(visitor: IRVisitor) {visitor.visit(v: self)}
    
    override var toPrint: String {
        "\(blocks.count > 0 ? "define" : "declare") \(type) \(name)(\(operands.joined {blocks.count > 0 ? "\($0)" : "\($0.type)"})) \(attribute) \(blocks.count > 0 ? "{" : "")"
    }
    override var description: String {return "\(type) \(name)"}
    
    init(name: String, type: Type, module: Module, attr: String = "ssp uwtable") {
        self.attribute = attr
        super.init(name: name, type: type, module: module)
        module.add(self)
    }
    
    func append(_ b: BasicBlock) -> List<BasicBlock>.Node {
        blocks.append(b)
    }
    
}

class Class: Global {
    
    var subNames = [String]()
    var subTypes = [Type]()
    func added(subType: (String, Type)) -> Self {
        self.subNames.append(subType.0)
        self.subTypes.append(subType.1)
        return self
    }
    
    override init(name: String, type: Type, module: Module) {
        super.init(name: name, type: type, module: module)
        _ = module.add(self)
    }
    
    var getSize: Int {
        var size = 0.0
        subTypes.forEach {
//            size +=
            let space = Double($0.space)
            size = ceil(size / space) * space + space
        }
        return Int(size)
    }
    
    override var toPrint: String {"\(type) = type {\(subTypes.joined())}"}
    override func accept(visitor: IRVisitor) {visitor.visit(v: self)}
    
}

class GlobalVariable: Global {
    
    var value: Const
    
    init(name: String, value: Const, module: Module) {
        self.value = value
        super.init(name: name, type: IRPointer(base: value.type), module: module)
        _ = module.add(self)
    }
    
    override var toPrint: String {"\(name) = global \(value), align \(value.type.withAlign)"}
    override func accept(visitor: IRVisitor) {visitor.visit(v: self)}
    
}
