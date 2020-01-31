//
//  Scope.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/1/30.
//

import Foundation

class Scope {
    
    var scopeName = ""
    var table = [String: Symbol]()
    
    init(_name: String) {
        scopeName = _name
    }
    
    func append(name: String, value: Symbol, error: CompilationError) {
        if (table[name] == nil) {
            table[name] = value;
        } else {
            error.message += "[Error] Redefinition of variable \"\(name)\" in scope \"\(scopeName)\"\n"
        }
    }
    
    func find(name: String) -> Symbol? {return nil;}
    func printScope() {}
    
    func newSubscope(withName _id: String) -> LocalScope {
        let newScope = LocalScope(_name: _id, _father: self)
        return newScope
    }
    
}




