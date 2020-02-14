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
    
    override init() {
        super.init()
        scopes.append(GlobalScope(_name: "Global", _type: .BLOCK))
    }
    
    override func visitDeclarations(_ ctx: MxsParser.DeclarationsContext) -> ASTNode? {
        let node = Program(scope: current)
        for decl in ctx.declaration() {
            node.declarations.append(visit(decl) as! Declaration)
        }
        return node
    }
    
    override func visitCodeBlock(_ ctx: MxsParser.CodeBlockContext) -> ASTNode? {
        scopes.append(current.newSubscope(withName: "Block", withType: .BLOCK))
        let node = CodeblockS(scope: current)
        for stmt in ctx.sentence() {
            if let s = visit(stmt) {
                node.statements.append(s as! Statement)
            }
        }
        scopes.popLast()!.correspondingNode = node
        return node
    }
    
    override func visitFunctionDeclaration(_ ctx: MxsParser.FunctionDeclarationContext) -> ASTNode? {
        let id = ctx.Identifier(0)!.getText(), type = ctx.type(0)!.getText()
        
        let _s = current.newSubscope(withName: id, withType: .FUNCTION)
        current.newSymbol(name: id, value: Symbol(_type: type, _bel: current, _subScope: _s))
        scopes.append(_s)
        
        let node = FunctionD(id: id, scope: current, type: type, parameters: [], statements: [])
        
        for i in 1..<ctx.type().count {
            let pid = ctx.Identifier(i)!.getText(), ptype = ctx.type(i)!.getText()
            current.newSymbol(name: pid, value: Symbol(_type: ptype, _bel: current))
            node.parameters.append(VariableD(scope: current, type: ptype, variable: [(pid, nil)]))
        }
        
        for stmt in ctx.sentence() {
            if let s = visit(stmt) {
                node.statements.append(s as! Statement)
            }
        }
        
        scopes.popLast()!.correspondingNode = node
        
        return node
    }
    
    override func visitInitialDeclaration(_ ctx: MxsParser.InitialDeclarationContext) -> ASTNode? {
        let id = ctx.Identifier(0)!.getText()
        
        let _s = current.newSubscope(withName: id, withType: .FUNCTION)
        current.newSymbol(name: id, value: Symbol(_type: id, _bel: current, _subScope: _s))
        scopes.append(_s)
        
        let node = FunctionD(id: id, scope: current, type: id, parameters: [], statements: [])
        
        for i in 0..<ctx.type().count {
            let pid = ctx.Identifier(i + 1)!.getText(), ptype = ctx.type(i)!.getText()
            current.newSymbol(name: pid, value: Symbol(_type: ptype, _bel: current))
            node.parameters.append(VariableD(scope: current, type: ptype, variable: [(pid, nil)]))
        }
        
        for stmt in ctx.sentence() {
            node.statements.append(visit(stmt) as! Statement)
        }
        
        scopes.popLast()!.correspondingNode = node
        
        return node
    }
    
    override func visitClassDeclaration(_ ctx: MxsParser.ClassDeclarationContext) -> ASTNode? {
        let id = preOperation ? "string" : ctx.Identifier()!.getText()
        
        let _s = current.newSubscope(withName: id, withType: .CLASS)
        current.newSymbol(name: id, value: Symbol(_type: "class", _bel: current, _subScope: _s))
        scopes.append(_s)
        
        let node = ClassD(id: id, scope: current)

        ctx.variableDeclaration().forEach{node.properties.append(visit($0) as! VariableD)}
        ctx.functionDeclaration().forEach{node.methods.append(visit($0) as! FunctionD)}
        ctx.initialDeclaration().forEach{node.initial.append(visit($0) as! FunctionD)}
        if ctx.initialDeclaration().count == 0 {
            let _s = current.newSubscope(withName: id, withType: .FUNCTION)
            current.newSymbol(name: id, value: Symbol(_type: id, _bel: current, _subScope: _s))
            scopes.append(_s)
            let _node = FunctionD(id: id, scope: current, type: id, parameters: [], statements: [])
            scopes.popLast()!.correspondingNode = _node
            node.initial.append(_node)
        }
        
        scopes.popLast()!.correspondingNode = node
    
        return node
    }
    
    override func visitVariableDeclaration(_ ctx: MxsParser.VariableDeclarationContext) -> ASTNode? {
        let type = ctx.type()!.getText(), node = VariableD(scope: current, type: type)
        for sing in ctx.singleVarDeclaration() {
            node.variable.append((sing.Identifier()!.getText(), sing.expression() != nil ? visit(sing.expression()!) as? Expression : nil))
            current.newSymbol(name: sing.Identifier()!.getText(), value: Symbol(_type: type, _bel: current))
        }
        return node
    }
    
    override func visitIdExpr(_ ctx: MxsParser.IdExprContext) -> ASTNode? {
        let id = ctx.Identifier()!.getText()
        var sc = current
        if let _s = current.find(name: id) {
            sc = _s.belongsTo
        } else {
            error.notDeclared(id: id, scopeName: current.scopeName)
        }
        return VariableE(id: id, scope: sc)
    }
    
    override func visitLiteralExpr(_ ctx: MxsParser.LiteralExprContext) -> ASTNode? {
        if ctx.This() != nil {
            return ThisLiteralE(scope: current)
        } else if ctx.BoolLiteral() != nil {
            return BoolLiteralE(scope: current).setValue(value: ctx.getText() == "true" ? true: false)
        } else if ctx.IntLiteral() != nil {
            return IntLiteralE(scope: current).setValue(value: Int(ctx.getText())!)
        } else if ctx.StringLiteral() != nil {
            return StringLiteralE(scope: current).setValue(value: ctx.getText())
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
        } else if ctx.This() != nil {
            return PropertyAccessE(scope: current, toAccess: visit(ctx.expression()!) as! Expression, property: ctx.This()!.getText())
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
        ctx.expression().forEach{node.arguments.append(visit($0) as! Expression)}
        return node
    }
    
    override func visitSufExpr(_ ctx: MxsParser.SufExprContext) -> ASTNode? {
        return SuffixE(scope: current, expression: visit(ctx.expression()!) as! Expression, op: ctx.op.getType().getUnaryOp())
    }
    
    override func visitUnaryExpr(_ ctx: MxsParser.UnaryExprContext) -> ASTNode? {
        return PrefixE(scope: current, expression: visit(ctx.expression()!) as! Expression, op: ctx.op.getType().getUnaryOp())
    }
    
    override func visitInstExpr(_ ctx: MxsParser.InstExprContext) -> ASTNode? {
        let id = ctx.Identifier()!.getText()
//        if let sc = current.find(name: id, check: {$0.type == "class"}) {
//            return FunctionCallE(id: id, scope: sc.subScope!, arguments: [])
//        } else {
//            error.notDeclared(id: id, scopeName: current.scopeName)
            return FunctionCallE(id: id, scope: current, arguments: [])
//        }
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
        scopes.append(current.newSubscope(withName: "If", withType: .CONDITION))
        let node = IfS(scope: current,
                      condition: visit(ctx.expression()!) as! Expression,
                      accept: visit(ctx.sentence(0)!) as? Statement,
                      reject: nil)
        scopes.popLast()!.correspondingNode = node
        if let r = ctx.sentence(1) {
            scopes.append(current.newSubscope(withName: "Else", withType: .CONDITION))
            node.reject = visit(r) as? Statement
            _ = scopes.popLast()
        }
        return node
    }
    
    override func visitForSentence(_ ctx: MxsParser.ForSentenceContext) -> ASTNode? {
        scopes.append(current.newSubscope(withName: "For", withType: .LOOP))
        let ini = ctx.declSentence() != nil ? visit(ctx.declSentence()!) : (ctx.expressionSentence() != nil ? visit(ctx.expressionSentence()!) : nil)
        let node = ForS(scope: current,
                        initial: ini == nil ? nil : ini as! Statement,
                        condition: ctx.cod == nil ? nil : visit(ctx.cod!) as? Expression,
                        increment: ctx.inc == nil ? nil : visit(ctx.inc!) as? Expression,
                        accept: visit(ctx.body!) as? Statement)
        scopes.popLast()!.correspondingNode = node
        return node
    }
    
    override func visitWhileSentence(_ ctx: MxsParser.WhileSentenceContext) -> ASTNode? {
        scopes.append(current.newSubscope(withName: "While", withType: .LOOP))
        let node = WhileS(scope: current,
                          condition: visit(ctx.expression()!) as! Expression,
                          accept: visit(ctx.sentence()!) as? Statement)
        scopes.popLast()!.correspondingNode = node
        return node
    }
    
    override func visitReturnSentence(_ ctx: MxsParser.ReturnSentenceContext) -> ASTNode? {
        return ReturnS(scope: current,
                       expression: ctx.expression() == nil ? nil : visit(ctx.expression()!) as? Expression)
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
