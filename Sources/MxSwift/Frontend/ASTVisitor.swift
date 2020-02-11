//
//  ASTVisitor.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/1.
//

import Foundation

protocol ASTVisitor {
    
    func visit(node: Program)
    func visit(node: VariableD)
    func visit(node: FunctionD)
    func visit(node: ClassD)
    func visit(node: DeclarationS)
    func visit(node: CodeblockS)
    func visit(node: IfS)
    func visit(node: WhileS)
    func visit(node: ForS)
    func visit(node: ReturnS)
    func visit(node: BreakS)
    func visit(node: ContinueS)
    func visit(node: ExpressionS)
    func visit(node: VariableE)
    func visit(node: ThisLiteralE)
    func visit(node: BoolLiteralE)
    func visit(node: IntLiteralE)
    func visit(node: StringLiteralE)
    func visit(node: NullLiteralE)
    func visit(node: MethodAccessE)
    func visit(node: PropertyAccessE)
    func visit(node: ArrayE)
    func visit(node: FunctionCallE)
    func visit(node: SuffixE)
    func visit(node: PrefixE)
    func visit(node: NewE)
    func visit(node: BinaryE)
    
}

class ASTBaseVisitor: ASTVisitor {
    
    func visit(node: Program) {
        node.declarations.forEach{$0.accept(visitor: self)}
    }
    
    func visit(node: VariableD) {
        node.variable.forEach{$0.1?.accept(visitor: self)}
    }
    
    func visit(node: FunctionD) {
        node.parameters.forEach{$0.accept(visitor: self)}
        node.statements.forEach{$0.accept(visitor: self)}
    }
    
    func visit(node: ClassD) {
        node.properties.forEach{$0.accept(visitor: self)}
        node.methods.forEach{$0.accept(visitor: self)}
    }
    
    func visit(node: DeclarationS) {
        node.decl.accept(visitor: self)
    }
    
    func visit(node: CodeblockS) {
        node.statements.forEach{$0.accept(visitor: self)}
    }
    
    func visit(node: IfS) {
        node.condition.accept(visitor: self)
        node.accept?.accept(visitor: self)
        node.reject?.accept(visitor: self)
    }
    
    func visit(node: WhileS) {
        node.condition.accept(visitor: self)
        node.accept?.accept(visitor: self)
    }
    
    func visit(node: ForS) {
        node.initial?.accept(visitor: self)
        node.condition?.accept(visitor: self)
        node.increment?.accept(visitor: self)
        node.accept?.accept(visitor: self)
    }
    
    func visit(node: ReturnS) {
        node.expression?.accept(visitor: self)
    }
    
    func visit(node: BreakS) {
        
    }
    
    func visit(node: ContinueS) {
        
    }
    
    func visit(node: ExpressionS) {
        node.expression.accept(visitor: self)
    }
    
    func visit(node: VariableE) {
        
    }
    
    func visit(node: ThisLiteralE) {
        
    }
    
    func visit(node: BoolLiteralE) {
        
    }
    
    func visit(node: IntLiteralE) {
        
    }
    
    func visit(node: StringLiteralE) {
        
    }
    
    func visit(node: NullLiteralE) {
        
    }
    
    func visit(node: MethodAccessE) {
        node.toAccess.accept(visitor: self)
        node.method.accept(visitor: self)
    }
    
    func visit(node: PropertyAccessE) {
        node.toAccess.accept(visitor: self)
    }
    
    func visit(node: ArrayE) {
        node.array.accept(visitor: self)
        node.index.accept(visitor: self)
    }
    
    func visit(node: FunctionCallE) {
        node.arguments.forEach{$0.accept(visitor: self)}
    }
    
    func visit(node: SuffixE) {
        node.expression.accept(visitor: self)
    }
    
    func visit(node: PrefixE) {
        node.expression.accept(visitor: self)
    }
    
    func visit(node: NewE) {
        node.expressions.forEach{$0.accept(visitor: self)}
    }
    
    func visit(node: BinaryE) {
        node.lhs.accept(visitor: self)
        node.rhs.accept(visitor: self)
    }
    
}
