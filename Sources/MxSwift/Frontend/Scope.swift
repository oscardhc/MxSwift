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
    case CONDITION
    case LOOP
}

class Scope: HashableObject {
    
    var scopeType: ScopeType
    var scopeName = ""
    var table = [String: Symbol]()
    var correspondingNode: ASTNode? = nil
    
    init(_name: String, _type: ScopeType) {
        scopeName = _name
        scopeType = _type
    }
    
    func find(name: String, check: ((Symbol) -> Bool) = {_ in true}) -> Symbol? {return nil;}
    func printScope() {
        print(hashString, "-", scopeName, "(\(scopeType))", ":")
        table.forEach{print("        ", $0, $1.type, $1.subScope?.hashString ?? "nil")}
    }
    func currentScope(type: ScopeType) -> Scope? {return nil;}
//    func currentFunction() -> Symbol? {return nil;}
    
    func newSymbol(name: String, value: Symbol) {
        if (table[name] == nil) {
            table[name] = value;
        } else {
            error.redifinition(id: name, scopeName: scopeName)
        }
    }
    
    func newSubscope(withName _id: String, withType _ty: ScopeType, withNode _nd: ASTNode? = nil) -> LocalScope {
        let newScope = LocalScope(_name: _id, _type: _ty, _father: self, _node: _nd)
        return newScope
    }
    
}

class GlobalScope: Scope {
    
    override func find(name: String, check: ((Symbol) -> Bool) = {_ in true}) -> Symbol? {
        let res = table[name]
        if res != nil && check(res!) {
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
    
    init(_name: String, _type: ScopeType, _father: Scope, _node: ASTNode?) {
        super.init(_name: _name, _type: _type)
        father = _father
        correspondingNode = _node
    }
    
    override func find(name: String, check: ((Symbol) -> Bool) = {_ in true}) -> Symbol? {
        let res = table[name]
        if res != nil && check(res!) {
            return res!
        } else {
            return father.find(name: name, check: check);
        }
    }
    
    override func printScope() {
        super.printScope()
        father.printScope()
    }
    
    override func currentScope(type: ScopeType) -> Scope? {
        if scopeType == type {
            return self
        } else {
            return father.currentScope(type: type)
        }
    }
    
//    override func currentFunction() -> Symbol? {
//        if scopeType == .FUNCTION {
//            return father.table[scopeName]
//        } else {
//            return father.currentFunction()
//        }
//    }
    
}




