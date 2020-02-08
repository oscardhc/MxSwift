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
    
    var currentModule: Module?
    override var prefix: String {return "@"}
    
    init(name: String, type: Type, module: Module?) {
        self.currentModule = module
        super.init(name: name, type: type)
    }
    
}

class Function: Global {
    
    var blocks = List<BasicBlock>()
    var parameters = List<Value>()
    
    override func accept(visitor: IRVisitor) {visitor.visit(v: self)}
    
    override var toPrint: String {return "define \(type) \(name)(\(parameters))"}
    override var description: String {return "\(type) \(name)"}
    
}

class GlobalVariable: Global {
    
}
