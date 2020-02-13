//
//  Module.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/6.
//

import Foundation

class Module {
    
    var functions = [Function]()
    var globalVar = [GlobalVariable]()
    var classes = [Class]()
    
    var builtinDeclarations = ""
    
    func accept(visitor: IRVisitor) {visitor.visit(v: self)}
    
    func add(_ f: Function) {
        self.functions.append(f)
    }
    func add(_ c: Class) {
        self.classes.append(c)
    }
    func add(_ v: GlobalVariable) {
        self.globalVar.append(v)
    }
    
}
