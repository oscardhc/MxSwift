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
    func indexError(type: String) {
        message.append(#"[Error] Subscriptiion index expected "int", received "\#(type)"."#)
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
    func indexError(name: String, type: String) {
        message.append("[Error] Expect \"int\" for subscription but get \"\(type)\" for \(name).")
    }
    func noMainFunction() {
        message.append("[Error] No \"main\" function declared.")
    }
    func typeError(name: String, type: String) {
        message.append("[Error] Type error for \"\(name)\" with type \"\(type)\"")
    }
    func argumentError(name: String, expected: [String], received: [String]) {
        message.append("[Error] Argument error when calling \"\(name)\", expected \(expected), received \(received).")
    }
    func statementError(name: String, environment: String) {
        message.append("[Error] Statement \"\(name)\" error in environment \"\(environment)\"")
    }
    func returnTypeError(name: String, expected: String, received: String) {
        message.append("[Error] Return type error in function \"\(name)\", expected \(expected), received \(received).")
    }
    func mainFuncError() {
        message.append("[Error] Function main type or parameter error.")
    }
    func notCallable(name: String) {
        message.append("[Error] Calling non-function symbol \"\(name)\"")
    }
    func controlConditionError(flow: String, type: String) {
        message.append(#"[Error] \#(flow) condition error, expected "bool", received "\#(type)""#)
    }
    
    func show() {
        message.forEach{print($0)}
    }
}

let error = CompilationError()
