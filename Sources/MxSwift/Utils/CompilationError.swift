//
//  CompilationError.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/1/30.
//

import Foundation

class CompilationError: Error {
    
    var message = [String]()
    
    func redifinition(id: String, scopeName: String) {
        message.append("[Error] Redefinition of variable \"\(id)\" in scope \"\(scopeName)\".")
    }
    func notDeclared(id: String, scopeName: String) {
        message.append("[Error] Use of undeclared identifier \"\(id)\" in scope \"\(scopeName)\".")
    }
    func notInClass(key: String) {
        message.append("[Error] Use of \"\(key)\" without a class.")
    }
    func subscriptError(id: String) {
        message.append("[Error] Subscriptiion of a non-array object \"\(id)\".")
    }
    func notAssignable(id: String) {
        message.append("[Error] Assign to not-assignable expression \"\(id)\".")
    }
    func unaryOperatorError(op: UnaryOperator, type1: String) {
        message.append("[Error] Type error with \"\(op)\" for type \"\(type1)\"")
    }
    func binaryOperatorError(op: BinaryOperator, type1: String, type2: String) {
        message.append("[Error] Type error with \"\(op)\" for types \"\(type1)\" and \"\(type2)\"")
    }
    func noSuchMember(name: String, c: String) {
        message.append("[Error] Member \"\(name)\" not found in class \"\(c)\"")
    }
    
    func show() {
        message.forEach{print($0)}
    }
}

let error = CompilationError()
