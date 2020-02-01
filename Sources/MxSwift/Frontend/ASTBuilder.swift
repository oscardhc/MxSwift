//
//  ASTBuilder.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/1.
//

import Foundation
import Antlr4
import Parser

extension Int {
    func getUnaryOp() -> UnaryOperator {
        switch self {
        case MxsLexer.SelfAdd: return .doubleAdd
        case MxsLexer.SelfSub: return .doubleSub
        case MxsLexer.Add: return .add
        case MxsLexer.Sub: return .sub
        case MxsLexer.Bitwise: return .bitwise
        default: return .negation
        }
    }
    func getBinaryOp() -> BinaryOperator {
        switch self {
        case MxsLexer.Mul: return .mul
        case MxsLexer.Div: return .div
        case MxsLexer.Add: return .add
        case MxsLexer.Sub: return .sub
        case MxsLexer.Mod: return .mod
        case MxsLexer.Greater: return .gt
        case MxsLexer.Less: return .lt
        case MxsLexer.GreaterEq: return .geq
        case MxsLexer.LessEq: return .leq
        case MxsLexer.Equal: return .eq
        case MxsLexer.Inequal: return .neq
        case MxsLexer.BitAnd: return .bitAnd
        case MxsLexer.BitOr: return .bitOr
        case MxsLexer.BitXor: return .bitXor
        case MxsLexer.LogicAnd: return .logAnd
        case MxsLexer.LogicOr: return .logOr
        case MxsLexer.LeftShift: return .lShift
        case MxsLexer.RightShift: return .rShift
        default: return .assign
        }
    }
}

class ASTBuilder: MxsBaseVisitor<ASTNode> {
    
    var scopes: [Scope] = []
    var current: Scope {
        return scopes.last!
    }
    
    override func visitDeclarations(_ ctx: MxsParser.DeclarationsContext) -> ASTNode? {
        scopes.append(GlobalScope(_name: "Global", _type: .BLOCK))
        let node = Program(scope: current)
        for decl in ctx.variableDeclaration() {
            node.declarations.append(visit(decl) as! VariableDeclaration)
        }
        for decl in ctx.functionDeclaration() {
            node.declarations.append(visit(decl) as! FunctionDeclaration)
        }
        for decl in ctx.classDeclaration() {
            node.declarations.append(visit(decl) as! ClassDeclaration)
        }
        _ = scopes.popLast()
        return node
    }
    
    override func visitCodeBlock(_ ctx: MxsParser.CodeBlockContext) -> ASTNode? {
        let newScope = current.newSubscope(withName: "Block", withType: .BLOCK)
        scopes.append(newScope)
        let node = CodeBlock(scope: newScope)
        for stmt in ctx.sentence() {
            node.statements.append(visit(stmt) as! Statement)
        }
        _ = scopes.popLast()
        return node
    }
    
    override func visitFunctionDeclaration(_ ctx: MxsParser.FunctionDeclarationContext) -> ASTNode? {
        let id = ctx.Identifier(0)!.getText(), type = ctx.type(0)!.getText()
        
        let _s = current.newSubscope(withName: id, withType: .FUNCTION)
        current.newSymbol(name: id, value: Symbol(_type: type, _subScope: _s))
        scopes.append(_s)
        
        let node = FunctionDeclaration(id: id, scope: current, type: type, parameters: [], statements: [])
        
        for i in 1..<ctx.type().count {
            let pid = ctx.Identifier(i)!.getText(), ptype = ctx.type(i)!.getText()
            current.newSymbol(name: pid, value: Symbol(_type: ptype))
            node.parameters.append(VariableDeclaration(id: [pid], scope: current, type: ptype))
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
        
        let node = ClassDeclaration(id: id, scope: current)

        for vdecl in ctx.variableDeclaration() {
            node.properties.append(visit(vdecl) as! VariableDeclaration)
        }
        for fdecl in ctx.functionDeclaration() {
            node.methods.append(visit(fdecl) as! FunctionDeclaration)
        }
        
        return node
    }
    
    override func visitVariableDeclaration(_ ctx: MxsParser.VariableDeclarationContext) -> ASTNode? {
        let node = VariableDeclaration(scope: current, type: ctx.type()!.getText())
        if let expr = ctx.expression(0) {
            node.id.append(ctx.Identifier(0)!.getText())
            node.expressions.append(visit(expr) as! Expression)
        } else {
            for id in ctx.Identifier() {
                node.id.append(id.getText())
            }
        }
        return node
    }
    
    override func visitIdExpr(_ ctx: MxsParser.IdExprContext) -> ASTNode? {
        return Variable(id: ctx.Identifier()!.getText(), scope: current)
    }
    
    override func visitLiteralExpr(_ ctx: MxsParser.LiteralExprContext) -> ASTNode? {
        if ctx.This() != nil {
            return ThisLiteral(scope: current)
        } else if ctx.BoolLiteral() != nil {
            return BoolLiteral(scope: current)
        } else if ctx.IntLiteral() != nil {
            return IntLiteral(scope: current)
        } else if ctx.StringLiteral() != nil {
            return StringLiteral(scope: current)
        } else {
            return NullLiteral(scope: current)
        }
    }
    
    override func visitParaExpr(_ ctx: MxsParser.ParaExprContext) -> ASTNode? {
        return visit(ctx.expression()!) as! Expression
    }
    
    override func visitMemberExpr(_ ctx: MxsParser.MemberExprContext) -> ASTNode? {
        if ctx.Identifier() != nil {
            return PropertyAccess(scope: current, toAccess: visit(ctx.expression()!) as! Expression, property: ctx.Identifier()!.getText())
        } else {
            return MethodAccess(scope: current, toAccess: visit(ctx.expression()!) as! Expression, method: visit(ctx.functionExpression()!) as! FunctionCall)
        }
    }
    
    override func visitArrayExpr(_ ctx: MxsParser.ArrayExprContext) -> ASTNode? {
        return ArrayExpr(scope: current, array: visit(ctx.array!) as! Expression, index: visit(ctx.idx!) as! Expression)
    }
    
    override func visitFuncExpr(_ ctx: MxsParser.FuncExprContext) -> ASTNode? {
        return visit(ctx.functionExpression()!) as! FunctionCall
    }
    
    override func visitFunctionExpression(_ ctx: MxsParser.FunctionExpressionContext) -> ASTNode? {
        let node = FunctionCall(id: ctx.Identifier()!.getText(), scope: current, arguments: [])
        for expr in ctx.expression() {
            node.arguments.append(visit(expr) as! Expression)
        }
        return node
    }
    
    override func visitSufExpr(_ ctx: MxsParser.SufExprContext) -> ASTNode? {
        return SuffixExpr(scope: current, expression: visit(ctx.expression()!) as! Expression, operation: ctx.op.getType().getUnaryOp())
    }
    
    override func visitUnaryExpr(_ ctx: MxsParser.UnaryExprContext) -> ASTNode? {
        return PrefixExpr(scope: current, expression: visit(ctx.expression()!) as! Expression, operation: ctx.op.getType().getUnaryOp())
    }
    
    override func visitNewExpr(_ ctx: MxsParser.NewExprContext) -> ASTNode? {
        let node = NewExpr(scope: current, baseType: ctx.ty.getText(), expressions: [], empty: ctx.EmptySet().count)
        for expr in ctx.expression() {
            node.expressions.append(visit(expr) as! Expression)
        }
        return node
    }
    
    override func visitBinaryExpr(_ ctx: MxsParser.BinaryExprContext) -> ASTNode? {
        return BinaryExpr(scope: current,
                          lhs: visit(ctx.expression(0)!) as! Expression,
                          rhs: visit(ctx.expression(1)!) as! Expression,
                          op: ctx.op.getType().getBinaryOp())
    }
    
    override func visitAssignExpr(_ ctx: MxsParser.AssignExprContext) -> ASTNode? {
        return BinaryExpr(scope: current,
                          lhs: visit(ctx.expression(0)!) as! Expression,
                          rhs: visit(ctx.expression(1)!) as! Expression,
                          op: ctx.op.getType().getBinaryOp())
    }
    
    override func visitDeclSentence(_ ctx: MxsParser.DeclSentenceContext) -> ASTNode? {
        return Decl(scope: current, decl: visit(ctx.variableDeclaration()!) as! Declaration)
    }
    
    override func visitIfSentence(_ ctx: MxsParser.IfSentenceContext) -> ASTNode? {
        let newScope = current.newSubscope(withName: "If", withType: .BLOCK)
        scopes.append(newScope)
        let node = If(scope: newScope,
                      condition: visit(ctx.expression()!) as! Expression,
                      accept: visit(ctx.sentence(0)!) as! Statement,
                      reject: visit(ctx.sentence(1)!) as! Statement)
        _ = scopes.popLast()
        return node
    }
    
    override func visitForSentence(_ ctx: MxsParser.ForSentenceContext) -> ASTNode? {
        let newScope = current.newSubscope(withName: "For", withType: .BLOCK)
        scopes.append(newScope)
        let node = For(scope: newScope,
                       initial: ctx.ini == nil ? nil : visit(ctx.ini!) as! Expression,
                       condition: ctx.cod == nil ? nil : visit(ctx.cod!) as! Expression,
                       increment: ctx.inc == nil ? nil : visit(ctx.inc!) as! Expression)
        _ = scopes.popLast()
        return node
    }
    
    override func visitWhileSentence(_ ctx: MxsParser.WhileSentenceContext) -> ASTNode? {
        let newScope = current.newSubscope(withName: "While", withType: .BLOCK)
        scopes.append(newScope)
        let node = While(scope: newScope,
                         condition: visit(ctx.expression()!) as! Expression,
                         accept: visit(ctx.sentence()!) as! Statement)
        _ = scopes.popLast()
        return node
    }
    
    override func visitReturnSentence(_ ctx: MxsParser.ReturnSentenceContext) -> ASTNode? {
        return Return(scope: current,
                      expression: ctx.expression() == nil ? nil : visit(ctx.expression()!) as! Expression)
    }
    
    override func visitBreakSentence(_ ctx: MxsParser.BreakSentenceContext) -> ASTNode? {
        return Break(scope: current)
    }
    
    override func visitContinueSentence(_ ctx: MxsParser.ContinueSentenceContext) -> ASTNode? {
        return Continue(scope: current)
    }
    
    override func visitExpressionSentence(_ ctx: MxsParser.ExpressionSentenceContext) -> ASTNode? {
        return Expr(scope: current, expression: visit(ctx.expression()!) as! Expression)
    }
    
}
