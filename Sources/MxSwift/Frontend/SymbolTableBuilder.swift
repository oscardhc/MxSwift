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
    
    var inScope = [ParserRuleContext: Scope]()
    
    var error: CompilationError!
    var scopeStack: [Scope]!
    var current: Scope {
        return scopeStack.last!;
    }
    
    init(_error: CompilationError) {
        scopeStack = [GlobalScope(_name: "Global")]
        error = _error
    }
    
    override func enterFunctionDeclaration(_ ctx: MxsParser.FunctionDeclarationContext) {
        let newScope = current.newSubscope(withName: "Function_" + ctx.Identifier()[0].getText())
        current.append(name: ctx.Identifier()[0].getText(),
                       value: Symbol(_type: ctx.type()[0].getText(), _subScope: newScope),
                       error: error)
        for i in 1..<ctx.type().count {
            newScope.append(name: ctx.Identifier()[i].getText(),
                            value: Symbol(_type: ctx.type()[i].getText()),
                            error: error)
        }
        scopeStack.append(newScope)
    }
    override func exitFunctionDeclaration(_ ctx: MxsParser.FunctionDeclarationContext) {
        _ = scopeStack.popLast()
    }
    
    
    override func enterClassDeclaration(_ ctx: MxsParser.ClassDeclarationContext) {
        let newScope = current.newSubscope(withName: "Class_" + ctx.Identifier()!.getText())
        current.append(name: ctx.Identifier()!.getText(),
                       value: Symbol(_type: "class", _subScope: newScope),
                       error: error)
        scopeStack.append(newScope)
    }
    override func exitClassDeclaration(_ ctx: MxsParser.ClassDeclarationContext) {
        _ = scopeStack.popLast()
    }
    
    override func enterForSentence(_ ctx: MxsParser.ForSentenceContext) {
        let newScope = current.newSubscope(withName: "For_sentence")
        scopeStack.append(newScope)
    }
    override func exitForSentence(_ ctx: MxsParser.ForSentenceContext) {
        _ = scopeStack.popLast()
    }
    
    override func enterWhileSentence(_ ctx: MxsParser.WhileSentenceContext) {
        let newScope = current.newSubscope(withName: "While_sentence")
        scopeStack.append(newScope)
    }
    override func exitWhileSentence(_ ctx: MxsParser.WhileSentenceContext) {
        _ = scopeStack.popLast()
    }
    
    override func enterIfSentence(_ ctx: MxsParser.IfSentenceContext) {
        let newScope = current.newSubscope(withName: "If_sentence")
        scopeStack.append(newScope)
    }
    override func exitIfSentence(_ ctx: MxsParser.IfSentenceContext) {
        _ = scopeStack.popLast()
    }
    
    
    override func enterVariableDeclaration(_ ctx: MxsParser.VariableDeclarationContext) {
        for i in 0..<ctx.Identifier().count {
            let sym = Symbol(_type: ctx.type()!.getText())
            current.append(name: ctx.Identifier(i)!.getText(), value: sym, error: error)
        }
    }
    override func exitVariableDeclaration(_ ctx: MxsParser.VariableDeclarationContext) {
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
