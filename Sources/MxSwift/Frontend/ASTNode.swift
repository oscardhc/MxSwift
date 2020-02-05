//
//  ASTNode.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/1/31.
//

import Foundation

class ASTNode: BaseObject, CustomStringConvertible {
    var scope: Scope!
    
    // for visitor use
    var ret: Any?
    
    init(scope: Scope) {
        self.scope = scope
    }
    var custom: Type {
        return ""
    }
    var description: Type {
        return "\(hashString) \(scope.scopeName)::\(type(of: self)) \t \(custom)"
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
class VariableDecl: Declaration {
    var id: [Type]!
    var type: Type!
    var expressions: [Expression?]!
    init(id: [Type] = [], scope: Scope, type: Type, expressions: [Expression?] = []) {
        super.init(scope: scope)
        self.id = id
        self.type = type
        self.expressions = expressions
    }
    override var custom: Type {return "\(type!) \(id!)"}
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class FunctionDecl: Declaration {
    var id: Type!
    var type: Type!
    var parameters: [VariableDecl]!
    var statements: [Statement]!
    var hasReturn = false
    init(id: Type, scope: Scope, type: Type, parameters: [VariableDecl] = [], statements: [Statement] = []) {
        super.init(scope: scope)
        self.id = id
        self.type = type
        self.parameters = parameters
        self.statements = statements
    }
    override var custom: Type {return "\(type!) \(id!)"}
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class ClassDecl: Declaration {
    var id: Type!
    var properties: [VariableDecl]!
    var methods: [FunctionDecl]!
    var initial: [FunctionDecl]!
    init(id: Type, scope: Scope, properties: [VariableDecl] = [], methods: [FunctionDecl] = [], initial: [FunctionDecl] = []) {
        super.init(scope: scope)
        self.id = id
        self.properties = properties
        self.methods = methods
        self.initial = initial
    }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}


class Statement: ASTNode {
    
}
class DeclarationS: Statement {
    var decl: Declaration!
    init(scope: Scope, decl: Declaration) {
        super.init(scope: scope)
        self.decl = decl
    }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class CodeblockS: Statement {
    var statements: [Statement]!
    init(scope: Scope, statements: [Statement] = []) {
        super.init(scope: scope)
        self.statements = statements
    }
    override var custom: Type { var str = ""; statements.forEach{str += "\($0.hashString) "}; return str; }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class IfS: Statement {
    var condition: Expression!
    var accept: Statement?
    var reject: Statement?
    init(scope: Scope, condition: Expression, accept: Statement?, reject: Statement?) {
        super.init(scope: scope)
        self.condition = condition
        self.accept = accept
        self.reject = reject
    }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class WhileS: Statement {
    var condition: Expression!
    var accept: Statement?
    init(scope: Scope, condition: Expression, accept: Statement?) {
        super.init(scope: scope)
        self.condition = condition
        self.accept = accept
    }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class ForS: Statement {
    var initial: Expression?
    var condition: Expression?
    var increment: Expression?
    var accept: Statement?
    init(scope: Scope, initial: Expression?, condition: Expression?, increment: Expression?, accept: Statement?) {
        super.init(scope: scope)
        self.initial = initial
        self.condition = condition
        self.increment = increment
        self.accept = accept
    }
    override var custom: Type {return "\(initial?.hashString) | \(condition?.hashString) | \(increment?.hashString)"}
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
    var expression: Expression!
    init(scope: Scope, expression: Expression) {
        super.init(scope: scope)
        self.expression = expression
    }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}

class Expression: ASTNode {
    var type: Type!
    var lValue: Bool {
        return false
    }
    override var custom: Type {
        return "(\(type!))"
    }
    init(scope: Scope, type: Type = "*") {
        super.init(scope: scope)
        self.type = type
    }
}
class VariableE: Expression {
    var id: Type!
    override var lValue: Bool {
        return true
    }
    init(id: Type, scope: Scope) {
        super.init(scope: scope)
        self.id = id;
    }
    override var custom: Type {return "\(id!)"}
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class ThisLiteralE: Expression {
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class BoolLiteralE: Expression {
    var value = true
    override var custom: Type {return "\(value)"}
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class IntLiteralE: Expression {
    var value = 0;
    override var custom: Type {return "\(value)"}
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class StringLiteralE: Expression {
    var value = "";
    override var custom: Type {return "\(value)"}
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class NullLiteralE: Expression {
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class MethodAccessE: Expression {
    var toAccess: Expression!
    var method: FunctionCallE!
    init(scope: Scope, toAccess: Expression, method: FunctionCallE) {
        super.init(scope: scope)
        self.toAccess = toAccess
        self.method = method
    }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class PropertyAccessE: Expression {
    var toAccess: Expression!
    var property: Type!
    override var lValue: Bool {
        return true
    }
    init(scope: Scope, toAccess: Expression, property: Type) {
        super.init(scope: scope)
        self.toAccess = toAccess
        self.property = property
    }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class ArrayE: Expression {
    var array: Expression!
    var index: Expression!
    override var lValue: Bool {
        return true
    }
    init(scope: Scope, array: Expression, index: Expression) {
        super.init(scope: scope)
        self.array = array
        self.index = index
    }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class FunctionCallE: Expression {
    var id: Type!
    var arguments: [Expression]!
    init(id: Type, scope: Scope, arguments: [Expression]) {
        super.init(scope: scope)
        self.id = id
        self.arguments = arguments
    }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}

class SuffixE: Expression {
    var expression: Expression!
    var op: UnaryOperator!
    init(scope: Scope, expression: Expression, op: UnaryOperator) {
        super.init(scope: scope)
        self.expression = expression
        self.op = op
    }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class PrefixE: Expression {
    var expression: Expression!
    var op: UnaryOperator!
    override var lValue: Bool {
        if [.doubleAdd, .doubleSub].contains(op) {
            return expression.lValue
        } else {
            return false;
        }
    }
    init(scope: Scope, expression: Expression, op: UnaryOperator) {
        super.init(scope: scope)
        self.expression = expression
        self.op = op
    }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class NewE: Expression {
    var baseType: Type!
    var expressions: [Expression]!
    var empty: Int!
    init(scope: Scope, baseType: Type!, expressions: [Expression], empty: Int) {
        super.init(scope: scope)
        self.baseType = baseType
        self.expressions = expressions
        self.empty = empty
    }
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}
class BinaryE: Expression {
    var lhs, rhs: Expression!
    var op: BinaryOperator!
    init(scope: Scope, lhs: Expression, rhs: Expression, op: BinaryOperator) {
        super.init(scope: scope)
        self.lhs = lhs
        self.rhs = rhs
        self.op = op
    }
    override var custom: Type {return "\(op!)"}
    override func accept(visitor: ASTVisitor) { visitor.visit(node: self) }
}

