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
    
    func thisNotInClass() {
        message.append("[Error] Use of \"this\" without a class.")
    }
    
    func subscriptError(id: String) {
        message.append("[Error] Subscriptiion of the non-array object \"\(id)\".")
    }
    
    func show() {
        message.forEach{print($0)}
    }
}

let error = CompilationError()