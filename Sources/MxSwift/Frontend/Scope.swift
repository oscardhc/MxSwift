//
//  Scope.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/1/30.
//

import Foundation

class Scope {
    
    var sons = [Scope]()
    var table = [String: Symbol]()
    
    func append(name: String, value: Symbol, error: CompilationError) {
        if (table[name] == nil) {
            table[name] = value;
        } else {
            error.message += "[Error] Redefinition of variable \(name)\n"
        }
    }
    
    func find(name: String) -> Symbol? {
        return nil;
    }
    
    func newChild() -> LocalScope {
        let newScope = LocalScope(_father: self)
        sons.append(newScope)
        return newScope
    }
    
}




