//
//  ASTVisitor.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/1.
//

import Foundation

protocol ASTVisitor {
    
    func visit(node: Program)
    func visit(node: VariableDeclaration)
    func visit(node: FunctionDeclaration)
    func visit(node: ClassDeclaration)
    func visit(node: Decl)
    func visit(node: CodeBlock)
    func visit(node: If)
    func visit(node: While)
    func visit(node: For)
    func visit(node: Return)
    func visit(node: Break)
    func visit(node: Continue)
    func visit(node: Expr)
    func visit(node: Variable)
    func visit(node: ThisLiteral)
    func visit(node: BoolLiteral)
    func visit(node: IntLiteral)
    func visit(node: StringLiteral)
    func visit(node: NullLiteral)
    func visit(node: MethodAccess)
    func visit(node: PropertyAccess)
    func visit(node: ArrayExpr)
    func visit(node: FunctionCall)
    func visit(node: SuffixExpr)
    func visit(node: PrefixExpr)
    func visit(node: NewExpr)
    func visit(node: BinaryExpr)
    
}

class ASTBaseVisitor: ASTVisitor {
    
    func visit(node: Program) {
        node.declarations.forEach{$0.accept(visitor: self)}
    }
    
    func visit(node: VariableDeclaration) {
        node.expressions.forEach{$0?.accept(visitor: self)}
    }
    
    func visit(node: FunctionDeclaration) {
        node.parameters.forEach{$0.accept(visitor: self)}
        node.statements.forEach{$0.accept(visitor: self)}
    }
    
    func visit(node: ClassDeclaration) {
        node.properties.forEach{$0.accept(visitor: self)}
        node.methods.forEach{$0.accept(visitor: self)}
    }
    
    func visit(node: Decl) {
        node.decl.accept(visitor: self)
    }
    
    func visit(node: CodeBlock) {
        node.statements.forEach{$0.accept(visitor: self)}
    }
    
    func visit(node: If) {
        node.condition.accept(visitor: self)
        node.accept.accept(visitor: self)
        node.reject?.accept(visitor: self)
    }
    
    func visit(node: While) {
        node.condition.accept(visitor: self)
        node.accept.accept(visitor: self)
    }
    
    func visit(node: For) {
        node.initial?.accept(visitor: self)
        node.condition?.accept(visitor: self)
        node.increment?.accept(visitor: self)
    }
    
    func visit(node: Return) {
        node.expression?.accept(visitor: self)
    }
    
    func visit(node: Break) {
        
    }
    
    func visit(node: Continue) {
        
    }
    
    func visit(node: Expr) {
        node.expression.accept(visitor: self)
    }
    
    func visit(node: Variable) {
        
    }
    
    func visit(node: ThisLiteral) {
        
    }
    
    func visit(node: BoolLiteral) {
        
    }
    
    func visit(node: IntLiteral) {
        
    }
    
    func visit(node: StringLiteral) {
        
    }
    
    func visit(node: NullLiteral) {
        
    }
    
    func visit(node: MethodAccess) {
        node.toAccess.accept(visitor: self)
        node.method.accept(visitor: self)
    }
    
    func visit(node: PropertyAccess) {
        node.toAccess.accept(visitor: self)
    }
    
    func visit(node: ArrayExpr) {
        node.array.accept(visitor: self)
        node.index.accept(visitor: self)
    }
    
    func visit(node: FunctionCall) {
        node.arguments.forEach{$0.accept(visitor: self)}
    }
    
    func visit(node: SuffixExpr) {
        node.expression.accept(visitor: self)
    }
    
    func visit(node: PrefixExpr) {
        node.expression.accept(visitor: self)
    }
    
    func visit(node: NewExpr) {
        node.expressions.forEach{$0.accept(visitor: self)}
    }
    
    func visit(node: BinaryExpr) {
        node.lhs.accept(visitor: self)
        node.rhs.accept(visitor: self)
    }
    
}
