//
//  SemanticChecker.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/2.
//

import Foundation

// 1. check whether declaration type(class) is declared
// deal with l-value & types of expressions
// 2. array/member accessable
// 3. type-check

class SemanticChecker: ASTBaseVisitor {

    override func visit(node: Program) {
        super.visit(node: node)
    }

    override func visit(node: VariableDecl) {
        super.visit(node: node)
        let baseType = node.type.dropAllArray()
        if !baseType.isBuiltinType() && node.scope.find(name: baseType) == nil {
            error.notDeclared(id: baseType, scopeName: node.scope.scopeName)
        }
    }

    override func visit(node: FunctionDecl) {
        super.visit(node: node)
    }

    override func visit(node: ClassDecl) {
        super.visit(node: node)
    }

    override func visit(node: DeclarationS) {
        super.visit(node: node)
    }

    override func visit(node: CodeblockS) {
        super.visit(node: node)
    }

    override func visit(node: IfS) {
        super.visit(node: node)
    }

    override func visit(node: WhileS) {
        super.visit(node: node)
    }

    override func visit(node: ForS) {
        super.visit(node: node)
    }

    override func visit(node: ReturnS) {
        super.visit(node: node)
    }

    override func visit(node: BreakS) {
        super.visit(node: node)
    }

    override func visit(node: ContinueS) {
        super.visit(node: node)
    }

    override func visit(node: ExpressionS) {
        super.visit(node: node)
    }

    override func visit(node: VariableE) {
        super.visit(node: node)
        node.type = node.scope.find(name: node.id)?.type
    }

    override func visit(node: ThisLiteralE) {
        super.visit(node: node)
        if let c = node.scope.currentClass() {
            node.type = c.scopeName
        } else {
            error.notInClass(key: "this")
        }
    }

    override func visit(node: BoolLiteralE) {
        super.visit(node: node)
        node.type = bool
    }

    override func visit(node: IntLiteralE) {
        super.visit(node: node)
        node.type = int
    }

    override func visit(node: StringLiteralE) {
        super.visit(node: node)
        node.type = string
    }

    override func visit(node: NullLiteralE) {
        super.visit(node: node)
        node.type = null
    }

    override func visit(node: MethodAccessE) {
//        super.visit(node: node)
        
        node.toAccess.accept(visitor: self)
        let c = node.toAccess.type!
//        if c == string {
//
//        } else
        if let sym = node.scope.find(name: c, check: {(str) in return str == "class"}) {
            if sym.type == "class" {
                if let m = sym.subScope!.table[node.method.id] {
                    node.type = m.type
                    node.method.scope = sym.subScope!
                } else {
                    error.noSuchMember(name: node.method.id, c: c)
                }
            } else {
                error.notInClass(key: node.method.id)
            }
        } else {
            error.notInClass(key: node.method.id)
        }
        node.method.accept(visitor: self)
    }

    override func visit(node: PropertyAccessE) {
        super.visit(node: node)
        if let c = node.scope.currentClass() {
            if let t = c.table[node.property] {
                node.type = t.type
            } else {
                error.noSuchMember(name: node.property, c: c.scopeName)
            }
        } else {
            error.notInClass(key: node.property)
        }
    }

    override func visit(node: ArrayE) {
        super.visit(node: node)
        if node.array.type.hasSuffix("[]") {
            node.type = node.array.type.dropArray()
        } else {
            error.subscriptError(id: node.array.description)
        }
    }

    override func visit(node: FunctionCallE) {
        super.visit(node: node)
        if let t = node.scope.find(name: node.id) {
            node.type = t.type
        } else {
            error.notDeclared(id: node.id, scopeName: node.scope.scopeName)
        }
    }

    override func visit(node: SuffixE) {
        let unaryError = {error.unaryOperatorError(op: node.op, type1: node.expression.type)}
        super.visit(node: node)
        switch node.op {
        case .doubleAdd, .doubleSub:
            if node.expression.type == int {
                node.type = int
            } else {unaryError()}
        default:
            break
        }
    }

    override func visit(node: PrefixE) {
        let unaryError = {error.unaryOperatorError(op: node.op, type1: node.expression.type)}
        super.visit(node: node)
        switch node.op {
        case .doubleAdd, .doubleSub, .add, .sub, .bitwise:
            if node.expression.type == int {
                node.type = int
            } else {unaryError()}
        case .negation:
            if node.expression.type == bool {
                node.type = bool
            } else {unaryError()}
        default:
            error.unaryOperatorError(op: node.op, type1: node.expression.type)
        }
    }

    override func visit(node: NewE) {
        super.visit(node: node)
    }
    
    override func visit(node: BinaryE) {
        let binaryError = {error.binaryOperatorError(op: node.op, type1: node.lhs.type, type2: node.rhs.type)}
        super.visit(node: node)
        switch node.op! {
        case .assign:
            if node.lhs.lValue == false {
                error.notAssignable(id: node.lhs.description)
            } else if node.lhs.type != node.rhs.type {binaryError()}
        case .add, .sub, .mul, .mod, .div, .bitAnd, .bitOr, .bitXor, .lShift, .rShift:
            if node.lhs.type == node.rhs.type && [int].contains(node.lhs.type) {
                node.type = int
            } else {binaryError()}
        case .eq, .neq, .gt, .geq, .lt, .leq:
            if node.lhs.type == node.rhs.type && [int, string, bool].contains(node.lhs.type) {
                node.type = bool
            } else {binaryError()}
        case .logAnd, .logOr:
            if node.lhs.type == node.rhs.type && [bool].contains(node.lhs.type) {
                node.type = bool
            } else {binaryError()}
        }
    }

}
