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
    
    func accept(visitor: IRVisitor) {visitor.visit(v: self)}
    
}
