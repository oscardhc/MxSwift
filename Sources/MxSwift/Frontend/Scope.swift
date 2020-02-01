//
//  Scope.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/1/30.
//

import Foundation

enum ScopeType {
    case CLASS
    case FUNCTION
    case BLOCK
}

class Scope {
    
    var scopeType: ScopeType
    var scopeName = ""
    var table = [String: Symbol]()
    
    init(_name: String, _type: ScopeType) {
        scopeName = _name
        scopeType = _type
    }
    
    func newSymbol(name: String, value: Symbol) {
        if (table[name] == nil) {
            table[name] = value;
        } else {
            error.redifinition(id: name, scopeName: scopeName)
        }
    }
    
    func find(name: String) -> Symbol? {return nil;}
    func printScope() {}
    func currentClass() -> String? {return nil;}
    
    func newSubscope(withName _id: String, withType _ty: ScopeType) -> LocalScope {
        let newScope = LocalScope(_name: _id, _type: _ty, _father: self)
        return newScope
    }
    
}




