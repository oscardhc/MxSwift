//
//  ASTListener.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/1/30.
//

import Foundation
import Antlr4
import Parser

class SymbolTableBuilder: MxsBaseListener {
    
    var error: CompilationError!
    var scopes: [Scope]!
    var current: Scope {
        return scopes.last!;
    }
    
    init(_error: CompilationError) {
        scopes = [GlobalScope()]
        error = _error
    }
    
    
    override func enterFunctionDeclaration(_ ctx: MxsParser.FunctionDeclarationContext) {
        let newScope = current.newChild()
        scopes.append(newScope)
    }
    override func exitFunctionDeclaration(_ ctx: MxsParser.FunctionDeclarationContext) {
        _ = scopes.popLast()
    }
    
    
    override func enterClassDeclaration(_ ctx: MxsParser.ClassDeclarationContext) {
        let newScope = current.newChild()
        scopes.append(newScope)
    }
    override func exitClassDeclaration(_ ctx: MxsParser.ClassDeclarationContext) {
        _ = scopes.popLast()
    }
    
    override func enterForSentence(_ ctx: MxsParser.ForSentenceContext) {
        let newScope = current.newChild()
        scopes.append(newScope)
    }
    override func exitForSentence(_ ctx: MxsParser.ForSentenceContext) {
        _ = scopes.popLast()
    }
    
    override func enterWhileSentence(_ ctx: MxsParser.WhileSentenceContext) {
        let newScope = current.newChild()
        scopes.append(newScope)
    }
    override func exitWhileSentence(_ ctx: MxsParser.WhileSentenceContext) {
        _ = scopes.popLast()
    }
    
    override func enterIfSentence(_ ctx: MxsParser.IfSentenceContext) {
        let newScope = current.newChild()
        scopes.append(newScope)
    }
    override func exitIfSentence(_ ctx: MxsParser.IfSentenceContext) {
        _ = scopes.popLast()
    }
    
    
    override func enterVariableDeclaration(_ ctx: MxsParser.VariableDeclarationContext) {
        for i in 0..<ctx.Identifier().count {
            let sym = Symbol(_type: ctx.type()!.getText())
            current.append(name: ctx.Identifier(i)!.getText(), value: sym, error: error)
        }
        print(current.table)
    }
    override func exitVariableDeclaration(_ ctx: MxsParser.VariableDeclarationContext) {
    }
    
}
