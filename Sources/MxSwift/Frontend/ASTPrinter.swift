//
//  ASTPrinter.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/1.
//

import Foundation

class ASTPrinter: ASTBaseVisitor {
    
    override func visit(node: Program) {
        super.visit(node: node)
        print(node.description)
    }
    
    override func visit(node: VariableDeclaration) {
        super.visit(node: node)
        print(node.description)
    }
    
    override func visit(node: FunctionDeclaration) {
        super.visit(node: node)
        print(node.description)
    }
    
    override func visit(node: ClassDeclaration) {
        super.visit(node: node)
        print(node.description)
    }
    
    override func visit(node: Decl) {
        super.visit(node: node)
        print(node.description)
    }
    
    override func visit(node: CodeBlock) {
        super.visit(node: node)
        print(node.description)
    }
    
    override func visit(node: If) {
        super.visit(node: node)
        print(node.description)
    }
    
    override func visit(node: While) {
        super.visit(node: node)
        print(node.description)
    }
    
    override func visit(node: For) {
        super.visit(node: node)
        print(node.description)
    }
    
    override func visit(node: Return) {
        super.visit(node: node)
        print(node.description)
    }
    
    override func visit(node: Break) {
        super.visit(node: node)
        print(node.description)
    }
    
    override func visit(node: Continue) {
        super.visit(node: node)
        print(node.description)
    }
    
    override func visit(node: Expr) {
        super.visit(node: node)
        print(node.description)
    }
    
    override func visit(node: Variable) {
        super.visit(node: node)
        print(node.description)
    }
    
    override func visit(node: ThisLiteral) {
        super.visit(node: node)
        print(node.description)
    }
    
    override func visit(node: BoolLiteral) {
        super.visit(node: node)
        print(node.description)
    }
    
    override func visit(node: IntLiteral) {
        super.visit(node: node)
        print(node.description)
    }
    
    override func visit(node: StringLiteral) {
        super.visit(node: node)
        print(node.description)
    }
    
    override func visit(node: NullLiteral) {
        super.visit(node: node)
        print(node.description)
    }
    
    override func visit(node: MethodAccess) {
        super.visit(node: node)
        print(node.description)
    }
    
    override func visit(node: PropertyAccess) {
        super.visit(node: node)
        print(node.description)
    }
    
    override func visit(node: ArrayExpr) {
        super.visit(node: node)
        print(node.description)
    }
    
    override func visit(node: FunctionCall) {
        super.visit(node: node)
        print(node.description)
    }
    
    override func visit(node: SuffixExpr) {
        super.visit(node: node)
        print(node.description)
    }
    
    override func visit(node: PrefixExpr) {
        super.visit(node: node)
        print(node.description)
    }
    
    override func visit(node: NewExpr) {
        super.visit(node: node)
        print(node.description)
    }
    
    override func visit(node: BinaryExpr) {
        super.visit(node: node)
        print(node.description)
    }
    
}
