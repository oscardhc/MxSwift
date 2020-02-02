//
//  ASTBuilder.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/1.
//

import Foundation
import Antlr4
import Parser

class ASTBuilder: MxsBaseVisitor<ASTNode> {
    
    var scopes: [Scope] = []
    var current: Scope {
        return scopes.last!
    }
    
    override func visitDeclarations(_ ctx: MxsParser.DeclarationsContext) -> ASTNode? {
        scopes.append(GlobalScope(_name: "Global", _type: .BLOCK))
        let node = Program(scope: current)
        for decl in ctx.declaration() {
            node.declarations.append(visit(decl) as! Declaration)
        }
        _ = scopes.popLast()
        return node
    }
    
    override func visitCodeBlock(_ ctx: MxsParser.CodeBlockContext) -> ASTNode? {
        let newScope = current.newSubscope(withName: "Block", withType: .BLOCK)
        scopes.append(newScope)
        let node = CodeblockS(scope: newScope)
        for stmt in ctx.sentence() {
            if let s = visit(stmt) {
                node.statements.append(s as! Statement)
            }
        }
        _ = scopes.popLast()
        return node
    }
    
    override func visitFunctionDeclaration(_ ctx: MxsParser.FunctionDeclarationContext) -> ASTNode? {
        let id = ctx.Identifier(0)!.getText(), type = ctx.type(0)!.getText()
        
        let _s = current.newSubscope(withName: id, withType: .FUNCTION)
        current.newSymbol(name: id, value: Symbol(_type: type, _subScope: _s))
        scopes.append(_s)
        
        let node = FunctionDecl(id: id, scope: current, type: type, parameters: [], statements: [])
        
        for i in 1..<ctx.type().count {
            let pid = ctx.Identifier(i)!.getText(), ptype = ctx.type(i)!.getText()
            current.newSymbol(name: pid, value: Symbol(_type: ptype))
            node.parameters.append(VariableDecl(id: [pid], scope: current, type: ptype))
        }
        
        for stmt in ctx.sentence() {
            if let s = visit(stmt) {
                node.statements.append(s as! Statement)
            }
        }
        
        _ = scopes.popLast()
        
        return node
    }
    
    override func visitInitialDeclaration(_ ctx: MxsParser.InitialDeclarationContext) -> ASTNode? {
        let id = ctx.Identifier(0)!.getText()
        
        let _s = current.newSubscope(withName: id, withType: .FUNCTION)
        current.newSymbol(name: id, value: Symbol(_type: id, _subScope: _s))
        scopes.append(_s)
        
        let node = FunctionDecl(id: id, scope: current, type: id, parameters: [], statements: [])
        
        for i in 0..<ctx.type().count {
            let pid = ctx.Identifier(i + 1)!.getText(), ptype = ctx.type(i)!.getText()
            current.newSymbol(name: pid, value: Symbol(_type: ptype))
            node.parameters.append(VariableDecl(id: [pid], scope: current, type: ptype))
        }
        
        for stmt in ctx.sentence() {
            node.statements.append(visit(stmt) as! Statement)
        }
        
        _ = scopes.popLast()
        
        return node
    }
    
    override func visitClassDeclaration(_ ctx: MxsParser.ClassDeclarationContext) -> ASTNode? {
        let id = ctx.Identifier()!.getText()
        
        let _s = current.newSubscope(withName: id, withType: .CLASS)
        current.newSymbol(name: id, value: Symbol(_type: "class", _subScope: _s))
        scopes.append(_s)
        
        let node = ClassDecl(id: id, scope: current)

        ctx.variableDeclaration().forEach{node.properties.append(visit($0) as! VariableDecl)}
        ctx.functionDeclaration().forEach{node.methods.append(visit($0) as! FunctionDecl)}
        ctx.initialDeclaration().forEach{node.initial.append(visit($0) as! FunctionDecl)}
        
        _ = scopes.popLast()
    
        return node
    }
    
    override func visitVariableDeclaration(_ ctx: MxsParser.VariableDeclarationContext) -> ASTNode? {
        let type = ctx.type()!.getText(), node = VariableDecl(scope: current, type: type)
        if let expr = ctx.expression(0) {
            current.newSymbol(name: ctx.Identifier(0)!.getText(), value: Symbol(_type: type))
            node.id.append(ctx.Identifier(0)!.getText())
            node.expressions.append(visit(expr) as! Expression)
        } else {
            for id in ctx.Identifier() {
                current.newSymbol(name: id.getText(), value: Symbol(_type: type))
                node.id.append(id.getText())
            }
        }
        if error.message.count > 0 {
            error.show()
            print(ctx.getText())
            current.printScope()
            exit(-1)
        }
        return node
    }
    
    override func visitIdExpr(_ ctx: MxsParser.IdExprContext) -> ASTNode? {
        let id = ctx.Identifier()!.getText()
        if current.find(name: id) == nil {
            error.notDeclared(id: id, scopeName: current.scopeName)
        }
        return VariableE(id: id, scope: current)
    }
    
    override func visitLiteralExpr(_ ctx: MxsParser.LiteralExprContext) -> ASTNode? {
        if ctx.This() != nil {
            return ThisLiteralE(scope: current)
        } else if ctx.BoolLiteral() != nil {
            return BoolLiteralE(scope: current)
        } else if ctx.IntLiteral() != nil {
            return IntLiteralE(scope: current)
        } else if ctx.StringLiteral() != nil {
            return StringLiteralE(scope: current)
        } else {
            return NullLiteralE(scope: current)
        }
    }
    
    override func visitParaExpr(_ ctx: MxsParser.ParaExprContext) -> ASTNode? {
        return visit(ctx.expression()!) as! Expression
    }
    
    override func visitMemberExpr(_ ctx: MxsParser.MemberExprContext) -> ASTNode? {
        if ctx.Identifier() != nil {
            return PropertyAccessE(scope: current, toAccess: visit(ctx.expression()!) as! Expression, property: ctx.Identifier()!.getText())
        } else {
            return MethodAccessE(scope: current, toAccess: visit(ctx.expression()!) as! Expression, method: visit(ctx.functionExpression()!) as! FunctionCallE)
        }
    }
    
    override func visitArrayExpr(_ ctx: MxsParser.ArrayExprContext) -> ASTNode? {
        return ArrayE(scope: current, array: visit(ctx.array!) as! Expression, index: visit(ctx.idx!) as! Expression)
    }
    
    override func visitFuncExpr(_ ctx: MxsParser.FuncExprContext) -> ASTNode? {
        return visit(ctx.functionExpression()!) as! FunctionCallE
    }
    
    override func visitFunctionExpression(_ ctx: MxsParser.FunctionExpressionContext) -> ASTNode? {
        let node = FunctionCallE(id: ctx.Identifier()!.getText(), scope: current, arguments: [])
        for expr in ctx.expression() {
            node.arguments.append(visit(expr) as! Expression)
        }
        return node
    }
    
    override func visitSufExpr(_ ctx: MxsParser.SufExprContext) -> ASTNode? {
        return SuffixE(scope: current, expression: visit(ctx.expression()!) as! Expression, operation: ctx.op.getType().getUnaryOp())
    }
    
    override func visitUnaryExpr(_ ctx: MxsParser.UnaryExprContext) -> ASTNode? {
        return PrefixE(scope: current, expression: visit(ctx.expression()!) as! Expression, operation: ctx.op.getType().getUnaryOp())
    }
    
    override func visitInstExpr(_ ctx: MxsParser.InstExprContext) -> ASTNode? {
        return visit(ctx.functionExpression()!) as! Expression
    }
    
    override func visitNewExpr(_ ctx: MxsParser.NewExprContext) -> ASTNode? {
        let node = NewE(scope: current, baseType: ctx.ty.getText(), expressions: [], empty: ctx.emptySet().count)
        for expr in ctx.expression() {
            node.expressions.append(visit(expr) as! Expression)
        }
        return node
    }
    
    override func visitBinaryExpr(_ ctx: MxsParser.BinaryExprContext) -> ASTNode? {
        return BinaryE(scope: current,
                          lhs: visit(ctx.expression(0)!) as! Expression,
                          rhs: visit(ctx.expression(1)!) as! Expression,
                          op: ctx.op.getType().getBinaryOp())
    }
    
    override func visitAssignExpr(_ ctx: MxsParser.AssignExprContext) -> ASTNode? {
        return BinaryE(scope: current,
                          lhs: visit(ctx.expression(0)!) as! Expression,
                          rhs: visit(ctx.expression(1)!) as! Expression,
                          op: ctx.op.getType().getBinaryOp())
    }
    
    override func visitDeclSentence(_ ctx: MxsParser.DeclSentenceContext) -> ASTNode? {
        return DeclarationS(scope: current, decl: visit(ctx.variableDeclaration()!) as! Declaration)
    }
    
    override func visitIfSentence(_ ctx: MxsParser.IfSentenceContext) -> ASTNode? {
        scopes.append(current.newSubscope(withName: "If", withType: .BLOCK))
        let node = IfS(scope: current,
                      condition: visit(ctx.expression()!) as! Expression,
                      accept: visit(ctx.sentence(0)!) as? Statement,
                      reject: nil)
        _ = scopes.popLast()
        if let r = ctx.sentence(1) {
            scopes.append(current.newSubscope(withName: "Else", withType: .BLOCK))
            node.reject = visit(r) as? Statement
            _ = scopes.popLast()
        }
        return node
    }
    
    override func visitForSentence(_ ctx: MxsParser.ForSentenceContext) -> ASTNode? {
        scopes.append(current.newSubscope(withName: "For", withType: .BLOCK))
        let node = ForS(scope: current,
                        initial: ctx.ini == nil ? nil : visit(ctx.ini!) as? Expression,
                        condition: ctx.cod == nil ? nil : visit(ctx.cod!) as? Expression,
                        increment: ctx.inc == nil ? nil : visit(ctx.inc!) as? Expression,
                        accept: visit(ctx.sentence()!) as? Statement)
        _ = scopes.popLast()
        return node
    }
    
    override func visitWhileSentence(_ ctx: MxsParser.WhileSentenceContext) -> ASTNode? {
        scopes.append(current.newSubscope(withName: "While", withType: .BLOCK))
        let node = WhileS(scope: current,
                          condition: visit(ctx.expression()!) as! Expression,
                          accept: visit(ctx.sentence()!) as? Statement)
        _ = scopes.popLast()
        return node
    }
    
    override func visitReturnSentence(_ ctx: MxsParser.ReturnSentenceContext) -> ASTNode? {
        return ReturnS(scope: current,
                       expression: ctx.expression() == nil ? nil : visit(ctx.expression()!) as! Expression)
    }
    
    override func visitBreakSentence(_ ctx: MxsParser.BreakSentenceContext) -> ASTNode? {
        return BreakS(scope: current)
    }
    
    override func visitContinueSentence(_ ctx: MxsParser.ContinueSentenceContext) -> ASTNode? {
        return ContinueS(scope: current)
    }
    
    override func visitExpressionSentence(_ ctx: MxsParser.ExpressionSentenceContext) -> ASTNode? {
        return ExpressionS(scope: current, expression: visit(ctx.expression()!) as! Expression)
    }
    
}