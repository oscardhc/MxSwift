//
//  IRBuilder.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/5.
//

import Foundation

class IRBuilder: ASTBaseVisitor {
    
    var module = Module()
    
    private func getType(type: SType) -> Type {
        switch type {
        case int:
            return IntT(width: .int)
        case bool:
            return IntT(width: .bool)
        case string:
            return PointerT(base: IntT(width: .char))
        case let x where x.hasSuffix("[]"):
            return PointerT(base: getType(type: x.dropArray()))
        default: //  structures...
//            return PointerT(base: )
            return Type()
        }
    }

    override func visit(node: Program) {
        super.visit(node: node)
    }

    override func visit(node: VariableDecl) {
        super.visit(node: node)
    }

    override func visit(node: FunctionDecl) {
        super.visit(node: node)
        let retType = getType(type: node.type)
        var parType = [Type]()
        node.parameters.forEach{parType.append(getType(type: $0.type))}
        let type = FunctionT(ret: retType, par: parType)
        node.ret = Function(name: node.id, type: type, module: module)
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
        node.ret = node.expression.ret
    }

    override func visit(node: VariableE) {
        super.visit(node: node)
    }

    override func visit(node: ThisLiteralE) {
        super.visit(node: node)
    }

    override func visit(node: BoolLiteralE) {
        super.visit(node: node)
    }

    override func visit(node: IntLiteralE) {
        super.visit(node: node)
    }

    override func visit(node: StringLiteralE) {
        super.visit(node: node)
    }

    override func visit(node: NullLiteralE) {
        super.visit(node: node)
    }

    override func visit(node: MethodAccessE) {
        super.visit(node: node)
    }

    override func visit(node: PropertyAccessE) {
        super.visit(node: node)
    }

    override func visit(node: ArrayE) {
        super.visit(node: node)
    }

    override func visit(node: FunctionCallE) {
        super.visit(node: node)
    }

    override func visit(node: SuffixE) {
        super.visit(node: node)
    }

    override func visit(node: PrefixE) {
        super.visit(node: node)
    }

    override func visit(node: NewE) {
        super.visit(node: node)
    }

    override func visit(node: BinaryE) {
        super.visit(node: node)
        node.ret = BinaryInst(name: "binaryE", type: node.lhs.ret!.type, operation: {
            switch node.op {
            case .add:
                return .add
            default:
                return .add
            }
        }(), lhs: node.lhs.ret!, rhs: node.rhs.ret!)
    }

}
