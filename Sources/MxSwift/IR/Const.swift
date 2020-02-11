//
//  Const.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/6.
//

import Foundation

class Const: User {
    
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
        _ = module.added(f: self)
    }
    
    func newBlock(withName: String) -> BasicBlock {
        blocks.append(BasicBlock(name: withName, type: IRLabel(), curfunc: self))
        return blocks.last
    }
    
}

class Class: Global {
    
    var subTypes = [(String, Type)]()
    func added(subType: (String, Type)) -> Self {
        self.subTypes.append(subType)
        return self
    }
    
    override init(name: String, type: Type, module: Module) {
        super.init(name: name, type: type, module: module)
        _ = module.added(c: self)
    }
    
}

class GlobalVariable: Global {
    
}
