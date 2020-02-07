//
//  ASTNode.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/1/31.
//

import Foundation

class ASTNode: HashableObject, CustomStringConvertible {
    var scope: Scope!
    var ret: Value?
    
    init(scope: Scope) {
        self.scope = scope
    }
    
    var custom: String {return ""}
    var description: String {return "\(hashString) \(scope.scopeName)::\(type(of: self)) \t \(custom)"}
    func accept(visitor: ASTVisitor) {}
}

class Program: ASTNode {
    var declarations: [Declaration]
    init(scope: Scope, declarations: [Declaration] = []) {
        self.declarations = declarations
        super.init(scope: scope)
    }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}

class Declaration: ASTNode {
    
}
class VariableDecl: Declaration {
    var id: [String]
    var type: String
    var expressions: [Expression?]!
    init(id: [String] = [], scope: Scope, type: String, expressions: [Expression?] = []) {
        self.id = id
        self.type = type
        self.expressions = expressions
        super.init(scope: scope)
    }
    override var custom: String {return "\(type) \(id)"}
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class FunctionDecl: Declaration {
    var id: String
    var type: String
    var parameters: [VariableDecl]
    var statements: [Statement]
    var hasReturn = false
    init(id: String, scope: Scope, type: String, parameters: [VariableDecl] = [], statements: [Statement] = []) {
        self.id = id
        self.type = type
        self.parameters = parameters
        self.statements = statements
        super.init(scope: scope)
    }
    override var custom: String {return "\(type) \(id)"}
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class ClassDecl: Declaration {
    var id: String
    var properties: [VariableDecl]
    var methods: [FunctionDecl]
    var initial: [FunctionDecl]
    init(id: String, scope: Scope, properties: [VariableDecl] = [], methods: [FunctionDecl] = [], initial: [FunctionDecl] = []) {
        self.id = id
        self.properties = properties
        self.methods = methods
        self.initial = initial
        super.init(scope: scope)
    }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}


class Statement: ASTNode {
    
}
class DeclarationS: Statement {
    var decl: Declaration
    init(scope: Scope, decl: Declaration) {
        self.decl = decl
        super.init(scope: scope)
    }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class CodeblockS: Statement {
    var statements: [Statement]
    init(scope: Scope, statements: [Statement] = []) {
        self.statements = statements
        super.init(scope: scope)
    }
    override var custom: String { var str = ""; statements.forEach{str += "\($0.hashString) "}; return str; }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class IfS: Statement {
    var condition: Expression
    var accept: Statement?
    var reject: Statement?
    init(scope: Scope, condition: Expression, accept: Statement?, reject: Statement?) {
        self.condition = condition
        self.accept = accept
        self.reject = reject
        super.init(scope: scope)
    }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class WhileS: Statement {
    var condition: Expression
    var accept: Statement?
    init(scope: Scope, condition: Expression, accept: Statement?) {
        self.condition = condition
        self.accept = accept
        super.init(scope: scope)
    }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class ForS: Statement {
    var initial: Expression?
    var condition: Expression?
    var increment: Expression?
    var accept: Statement?
    init(scope: Scope, initial: Expression?, condition: Expression?, increment: Expression?, accept: Statement?) {
        self.initial = initial
        self.condition = condition
        self.increment = increment
        self.accept = accept
        super.init(scope: scope)
    }
    override var custom: String {return "\(initial?.hashString) | \(condition?.hashString) | \(increment?.hashString)"}
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class ReturnS: Statement {
    var expression: Expression?
    init(scope: Scope, expression: Expression?) {
        super.init(scope: scope)
        self.expression = expression
    }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class BreakS: Statement {
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class ContinueS: Statement {
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class ExpressionS: Statement {
    var expression: Expression
    init(scope: Scope, expression: Expression) {
        self.expression = expression
        super.init(scope: scope)
    }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}

class Expression: ASTNode {
    var type: String
    var willBeAssigned = false
    var lValuable: Bool {
        return false
    }
    override var custom: String {
        return "(\(type))"
    }
    init(scope: Scope, type: String = "*") {
        self.type = type
        super.init(scope: scope)
    }
}
class VariableE: Expression {
    var id: String
    override var lValuable: Bool {
        return true
    }
    init(id: String, scope: Scope) {
        self.id = id;
        super.init(scope: scope)
    }
    override var custom: String {return "\(id)"}
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class ThisLiteralE: Expression {
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class BoolLiteralE: Expression {
    var value = true
    override var custom: String {return "\(value)"}
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class IntLiteralE: Expression {
    var value = 0;
    override var custom: String {return "\(value)"}
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class StringLiteralE: Expression {
    var value = "";
    override var custom: String {return "\(value)"}
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class NullLiteralE: Expression {
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class MethodAccessE: Expression {
    var toAccess: Expression
    var method: FunctionCallE
    init(scope: Scope, toAccess: Expression, method: FunctionCallE) {
        self.toAccess = toAccess
        self.method = method
        super.init(scope: scope)
    }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class PropertyAccessE: Expression {
    var toAccess: Expression
    var property: String
    override var lValuable: Bool {
        return true
    }
    init(scope: Scope, toAccess: Expression, property: String) {
        self.toAccess = toAccess
        self.property = property
        super.init(scope: scope)
    }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class ArrayE: Expression {
    var array: Expression
    var index: Expression
    override var lValuable: Bool {
        return true
    }
    init(scope: Scope, array: Expression, index: Expression) {
        self.array = array
        self.index = index
        super.init(scope: scope)
    }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class FunctionCallE: Expression {
    var id: String
    var arguments: [Expression]
    init(id: String, scope: Scope, arguments: [Expression]) {
        self.id = id
        self.arguments = arguments
        super.init(scope: scope)
    }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}

class SuffixE: Expression {
    var expression: Expression
    var op: UnaryOperator
    init(scope: Scope, expression: Expression, op: UnaryOperator) {
        self.expression = expression
        self.op = op
        super.init(scope: scope)
    }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class PrefixE: Expression {
    var expression: Expression
    var op: UnaryOperator
    override var lValuable: Bool {
        if [.doubleAdd, .doubleSub].contains(op) {
            return expression.lValuable
        } else {
            return false;
        }
    }
    init(scope: Scope, expression: Expression, op: UnaryOperator) {
        self.expression = expression
        self.op = op
        super.init(scope: scope)
    }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class NewE: Expression {
    var baseType: String
    var expressions: [Expression]
    var empty: Int
    init(scope: Scope, baseType: String!, expressions: [Expression], empty: Int) {
        self.baseType = baseType
        self.expressions = expressions
        self.empty = empty
        super.init(scope: scope)
    }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class BinaryE: Expression {
    var lhs, rhs: Expression
    var op: BinaryOperator
    init(scope: Scope, lhs: Expression, rhs: Expression, op: BinaryOperator) {
        self.lhs = lhs
        self.rhs = rhs
        self.op = op
        super.init(scope: scope)
    }
    override var custom: String {return "\(op)"}
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}

