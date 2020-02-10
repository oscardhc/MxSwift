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
    
    var builtinDeclarations = ""
    
    func accept(visitor: IRVisitor) {visitor.visit(v: self)}
    
    func added(f: Function) -> Function {
        self.functions.append(f)
        return f
    }
    
}
