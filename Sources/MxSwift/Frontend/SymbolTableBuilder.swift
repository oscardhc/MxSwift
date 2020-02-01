//
//  ASTListener.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/1/30.
//

import Foundation
import Antlr4
import Parser

extension ParserRuleContext: Hashable {
    
    public static func == (lhs: ParserRuleContext, rhs: ParserRuleContext) -> Bool {
        return (
            lhs === rhs
        )
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }

}

class SymbolTableBuilder: MxsBaseListener {
    
    var scopeMap = [ParserRuleContext: Scope]()
    var node = [ParserRuleContext: ASTNode]()
    
    var error: CompilationError!
    var scopeStack: [Scope]!
    var current: Scope {
        return scopeStack.last!;
    }
    
    init(_error: CompilationError) {
        scopeStack = [GlobalScope(_name: "Global", _type: .BLOCK)]
        error = _error
    }
    
    override func enterFunctionDeclaration(_ ctx: MxsParser.FunctionDeclarationContext) {
        let newScope = current.newSubscope(withName: ctx.Identifier(0)!.getText(), withType: .FUNCTION)
        for i in 1..<ctx.type().count {
            newScope.newSymbol(name: ctx.Identifier(i)!.getText(),
                            value: Symbol(_type: ctx.type(i)!.getText()))
        }
        current.newSymbol(name: ctx.Identifier(0)!.getText(),
                       value: Symbol(_type: ctx.type(0)!.getText(), _subScope: newScope))
        scopeStack.append(newScope)
    }
    override func exitFunctionDeclaration(_ ctx: MxsParser.FunctionDeclarationContext) {
        var parameters = [VariableDeclaration]()
        var statements = [Statement]()
        for i in 1..<ctx.type().count {
            parameters.append(VariableDeclaration(id: [ctx.Identifier(i)!.getText()],
                                                  scope: current, type: ctx.type(i)!.getText(), expressions: [nil]))
        }
        for stmt in ctx.sentence() {
            statements.append(node[stmt]! as! Statement)
        }
        node[ctx] = FunctionDeclaration(id: ctx.Identifier(0)!.getText(),
                                        scope: current, type: ctx.type(0)!.getText(),
                                        parameters: parameters, statements: statements)
        _ = scopeStack.popLast()
    }
    
    override func enterCodeBlock(_ ctx: MxsParser.CodeBlockContext) {
        let newScope = current.newSubscope(withName: "code block", withType: .BLOCK)
        scopeStack.append(newScope)
    }
    override func exitCodeBlock(_ ctx: MxsParser.CodeBlockContext) {
        _ = scopeStack.popLast()
    }
    
    override func enterClassDeclaration(_ ctx: MxsParser.ClassDeclarationContext) {
        let newScope = current.newSubscope(withName: ctx.Identifier()!.getText(), withType: .CLASS)
        current.newSymbol(name: ctx.Identifier()!.getText(),
                       value: Symbol(_type: "class", _subScope: newScope))
        scopeStack.append(newScope)
    }
    override func exitClassDeclaration(_ ctx: MxsParser.ClassDeclarationContext) {
        _ = scopeStack.popLast()
    }
    
    override func enterForSentence(_ ctx: MxsParser.ForSentenceContext) {
        let newScope = current.newSubscope(withName: "For_sentence", withType: .BLOCK)
        scopeStack.append(newScope)
    }
    override func exitForSentence(_ ctx: MxsParser.ForSentenceContext) {
        _ = scopeStack.popLast()
    }
    
    override func enterWhileSentence(_ ctx: MxsParser.WhileSentenceContext) {
        let newScope = current.newSubscope(withName: "While_sentence", withType: .BLOCK)
        scopeStack.append(newScope)
    }
    override func exitWhileSentence(_ ctx: MxsParser.WhileSentenceContext) {
        _ = scopeStack.popLast()
    }
    
    override func enterIfSentence(_ ctx: MxsParser.IfSentenceContext) {
        let newScope = current.newSubscope(withName: "If_sentence", withType: .BLOCK)
        scopeStack.append(newScope)
    }
    override func exitIfSentence(_ ctx: MxsParser.IfSentenceContext) {
        _ = scopeStack.popLast()
    }
    
    
    override func enterVariableDeclaration(_ ctx: MxsParser.VariableDeclarationContext) {
        for i in 0..<ctx.Identifier().count {
            let sym = Symbol(_type: ctx.type()!.getText())
            current.newSymbol(name: ctx.Identifier(i)!.getText(), value: sym)
        }
    }
    override func exitVariableDeclaration(_ ctx: MxsParser.VariableDeclarationContext) {
        if ctx.expression().count == 0 {
            
        } else {
            for id in ctx.Identifier() {
                
            }
        }
    }
    
    override func enterReturnSentence(_ ctx: MxsParser.ReturnSentenceContext) {
//        print(current.table)
        current.printScope()
    }
    override func exitReturnSentence(_ ctx: MxsParser.ReturnSentenceContext) {
    }
    
    override func enterDeclarations(_ ctx: MxsParser.DeclarationsContext) {
        
    }
    
}
