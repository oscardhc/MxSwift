//
//  Module.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/6.
//

import Foundation

class Module {
    
    var functions = List<Function>()
    var globalVar = List<Global>()
    var classes = List<Class>()
    
    var builtinDeclarations = ""
    
    func accept(visitor: IRVisitor) {visitor.visit(v: self)}
    
    func added(f: Function) -> Function {
        self.functions.pushBack(f)
        return f
    }
    func added(c: Class) -> Class {
        self.classes.pushBack(c)
        return c
    }
}
