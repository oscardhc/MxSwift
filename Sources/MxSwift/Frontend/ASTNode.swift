//
//  ASTNode.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/1/31.
//

import Foundation

class ASTNode {
    var scope: Scope!
    init(scope: Scope) {
        self.scope = scope
    }
    var description: String {
        return "\(type(of: self)) in scope \(scope.scopeName)"
    }
    func accept(visitor: ASTVisitor) {}
}

class Program: ASTNode {
    var declarations: [Declaration]!
    init(scope: Scope, declarations: [Declaration] = []) {
        super.init(scope: scope)
        self.declarations = declarations
    }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}

class Declaration: ASTNode {
    
}
class VariableDeclaration: Declaration {
    var id: [String]!
    var type: String!
    var expressions: [Expression?]!
    init(id: [String] = [], scope: Scope, type: String, expressions: [Expression?] = []) {
        super.init(scope: scope)
        self.id = id
        self.type = type
        self.expressions = expressions
    }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class FunctionDeclaration: Declaration {
    var id: String!
    var type: String!
    var parameters: [VariableDeclaration]!
    var statements: [Statement]!
    init(id: String, scope: Scope, type: String, parameters: [VariableDeclaration] = [], statements: [Statement] = []) {
        super.init(scope: scope)
        self.id = id
        self.type = type
        self.parameters = parameters
        self.statements = statements
    }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class ClassDeclaration: Declaration {
    var id: String!
    var properties: [VariableDeclaration]!
    var methods: [FunctionDeclaration]!
    init(id: String, scope: Scope, properties: [VariableDeclaration] = [], methods: [FunctionDeclaration] = []) {
        super.init(scope: scope)
        self.id = id
        self.properties = properties
        self.methods = methods
    }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}


class Statement: ASTNode {
    
}
class Decl: Statement {
    var decl: Declaration!
    init(scope: Scope, decl: Declaration) {
        super.init(scope: scope)
        self.decl = decl
    }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class CodeBlock: Statement {
    var statements: [Statement]!
    init(scope: Scope, statements: [Statement] = []) {
        super.init(scope: scope)
        self.statements = statements
    }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class If: Statement {
    var condition: Expression!
    var accept: Statement!
    var reject: Statement?
    init(scope: Scope, condition: Expression, accept: Statement, reject: Statement?) {
        super.init(scope: scope)
        self.condition = condition
        self.accept = accept
        self.reject = reject
    }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class While: Statement {
    var condition: Expression!
    var accept: Statement!
    init(scope: Scope, condition: Expression, accept: Statement) {
        super.init(scope: scope)
        self.condition = condition
        self.accept = accept
    }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class For: Statement {
    var initial: Expression?
    var condition: Expression?
    var increment: Expression?
    init(scope: Scope, initial: Expression?, condition: Expression?, increment: Expression?) {
        super.init(scope: scope)
        self.initial = initial
        self.condition = condition
        self.increment = increment
    }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class Return: Statement {
    var expression: Expression?
    init(scope: Scope, expression: Expression?) {
        super.init(scope: scope)
        self.expression = expression
    }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class Break: Statement {
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class Continue: Statement {
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class Expr: Statement {
    var expression: Expression!
    init(scope: Scope, expression: Expression) {
        super.init(scope: scope)
        self.expression = expression
    }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}

class Expression: ASTNode {
    var type: String!
    var lValue: Bool!
    init(scope: Scope, type: String = "", lValue: Bool = false) {
        super.init(scope: scope)
        self.type = type
        self.lValue = lValue
    }
}
class Variable: Expression {
    var id: String!
    init(id: String, scope: Scope) {
        super.init(scope: scope, lValue: true)
        self.id = id;
    }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class ThisLiteral: Expression {
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class BoolLiteral: Expression {
    var value = true
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class IntLiteral: Expression {
    var value = 0;
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class StringLiteral: Expression {
    var value = "";
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class NullLiteral: Expression {
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class MethodAccess: Expression {
    var toAccess: Expression!
    var method: FunctionCall!
    init(scope: Scope, toAccess: Expression, method: FunctionCall) {
        super.init(scope: scope)
        self.toAccess = toAccess
        self.method = method
    }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class PropertyAccess: Expression {
    var toAccess: Expression!
    var property: String!
    init(scope: Scope, toAccess: Expression, property: String) {
        super.init(scope: scope)
        self.toAccess = toAccess
        self.property = property
    }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class ArrayExpr: Expression {
    var array: Expression!
    var index: Expression!
    init(scope: Scope, array: Expression, index: Expression) {
        super.init(scope: scope)
        self.array = array
        self.index = index
    }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class FunctionCall: Expression {
    var arguments: [Expression]!
    init(id: String, scope: Scope, arguments: [Expression]) {
        super.init(scope: scope)
        self.arguments = arguments
    }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
enum UnaryOperator {
    case doubleAdd, doubleSub, add, sub, bitwise, negation
}
class SuffixExpr: Expression {
    var expression: Expression!
    var operation: UnaryOperator!
    init(scope: Scope, expression: Expression, operation: UnaryOperator) {
        super.init(scope: scope)
        self.expression = expression
        self.operation = operation
    }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class PrefixExpr: Expression {
    var expression: Expression!
    var operation: UnaryOperator!
    init(scope: Scope, expression: Expression, operation: UnaryOperator) {
        super.init(scope: scope)
        self.expression = expression
        self.operation = operation
    }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class NewExpr: Expression {
    var baseType: String!
    var expressions: [Expression]!
    var empty: Int!
    init(scope: Scope, baseType: String!, expressions: [Expression], empty: Int) {
        super.init(scope: scope)
        self.baseType = baseType
        self.expressions = expressions
        self.empty = empty
    }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
enum BinaryOperator {
    case add, sub, mul, div, mod, gt, lt, geq, leq, eq, neq, bitAnd, bitOr, bitXor, logAnd, logOr, lShift, rShift, assign
}
class BinaryExpr: Expression {
    var lhs, rhs: Expression!
    var op: BinaryOperator!
    init(scope: Scope, lhs: Expression, rhs: Expression, op: BinaryOperator) {
        super.init(scope: scope)
        self.lhs = lhs
        self.rhs = rhs
        self.op = op
    }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}

