//
//  StaticTypeChecker.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/1/31.
//

import Foundation
import Antlr4
import Parser

class StaticTypeChecker: MxsBaseListener {
    
    var scopeMap: [ParserRuleContext: Scope]!
    var error: CompilationError!
    
    var type = [ParserRuleContext: String]()
    
    init(_error: CompilationError, _scopeMap: [ParserRuleContext: Scope]) {
        error = _error
        scopeMap = _scopeMap
    }
    
    override func enterDeclarations(_ ctx: MxsParser.DeclarationsContext) {
        print(scopeMap[ctx]!.scopeName, scopeMap[ctx]!.table)
    }
    
    override func exitIdExpr(_ ctx: MxsParser.IdExprContext) {
        guard let res = scopeMap[ctx]!.find(name: ctx.Identifier()!.getText()) else {
            error.notDeclared(id: ctx.Identifier()!.getText())
            return
        }
        type[ctx] = res.type
    }
    override func exitLiteralExpr(_ ctx: MxsParser.LiteralExprContext) {
        if ctx.This() != nil {
            guard let res = scopeMap[ctx]?.currentClass() else {
                error.thisNotInClass()
                return
            }
            type[ctx] = res
        } else if ctx.BoolLiteral() != nil {
            type[ctx] = "bool"
        } else if ctx.IntLiteral() != nil {
            type[ctx] = "int"
        } else if ctx.StringLiteral() != nil {
            type[ctx] = "string"
        } else if ctx.NullLiteral() != nil {
            type[ctx] = "null"
        }
    }
    override func exitParaExpr(_ ctx: MxsParser.ParaExprContext) {
        type[ctx] = type[ctx.expression()!]
    }
    override func exitMemberExpr(_ ctx: MxsParser.MemberExprContext) {
        
    }
    override func exitArrayExpr(_ ctx: MxsParser.ArrayExprContext) {
        if type[ctx.array]!.hasSuffix("[]") {
            type[ctx] = type[ctx.array]!.dropArray()
        } else {
            error.subscriptError(id: ctx.array.getText())
        }
    }
    override func exitFunctionExpression(_ ctx: MxsParser.FunctionExpressionContext) {
        
    }
}
