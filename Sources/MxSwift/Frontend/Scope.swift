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

class Scope: BaseObject {
    
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
    
    func find(name: String, check: ((String) -> Bool) = {_ in true}) -> Symbol? {return nil;}
    func printScope() {
        print(hashString, "-", scopeName, "(\(scopeType))", ":")
        table.forEach{print("        ", $0, $1.type!, $1.subScope)}
    }
    func currentClass() -> Scope? {return nil;}
    
    func newSubscope(withName _id: String, withType _ty: ScopeType) -> LocalScope {
        let newScope = LocalScope(_name: _id, _type: _ty, _father: self)
        return newScope
    }
    
}

class GlobalScope: Scope {
    
    override func find(name: String, check: ((String) -> Bool) = {_ in true}) -> Symbol? {
        let res = table[name]
        if res != nil && check(res!.type) {
            return res!
        } else {
            return nil
        }
    }
    
    override func printScope() {
        super.printScope()
        print("---------------------")
    }
    
}

class LocalScope: Scope {
    
    var father: Scope!
    
    init(_name: String, _type: ScopeType, _father: Scope) {
        super.init(_name: _name, _type: _type)
        father = _father;
    }
    
    override func find(name: String, check: ((String) -> Bool) = {_ in true}) -> Symbol? {
        let res = table[name]
        if res != nil && check(res!.type) {
            return res!
        } else {
            return father.find(name: name, check: check);
        }
    }
    
    override func printScope() {
        super.printScope()
        father.printScope()
    }
    
    override func currentClass() -> Scope? {
        if scopeType == .CLASS {
            return self
        } else {
            return father.currentClass()
        }
    }
    
}




