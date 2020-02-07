//
//  IRBuilder.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/5.
//

import Foundation

class IRBuilder: ASTBaseVisitor {
    
    var module = Module()
//    var namedValue = [String: Value]()
    var currentBlock = BasicBlock(name: "", type: Type(), curfunc: nil)
    
    private func getType(type: String) -> Type {
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
        for id in node.id {
            var sym = node.scope.find(name: id)!
            let ret = AllocaInst(name: id, forType: getType(type: node.type))
            sym.value = ret
            currentBlock.inst.append(ret)
        }
    }

    override func visit(node: FunctionDecl) {
//        super.visit(node: node)
        var parType = [Type]()
        node.parameters.forEach{parType.append(getType(type: $0.type))}
        
        let ret = Function(name: node.id,
                           type: FunctionT(ret: getType(type: node.type), par: parType),
                           module: module)
        
        node.parameters.forEach {
            let par = Value(name: $0.id[0], type: getType(type: $0.type))
            ret.parameters.append(par)
            var sym = $0.scope.find(name: $0.id[0])!
            sym.value = par
        }
        
        ret.blocks.append(BasicBlock(name: "", type: LabelType(), curfunc: ret))
        currentBlock = ret.blocks.last
        
        node.statements.forEach {
            $0.accept(visitor: self)
        }
        
//        currentBlock.inst.append()
        
        node.ret = ret
        module.functions.append(ret)
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
        if let e = node.expression {
            node.ret = ReturnInst(name: "", type: getType(type: e.type), val: e.ret!)
            currentBlock.inst.append(node.ret as! Inst)
        }
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
        let v = node.scope.find(name: node.id)!.value!
        if v is AllocaInst {
            let ret = LoadInst(name: "", alloc: v as! AllocaInst)
            node.ret = ret
            currentBlock.inst.append(ret)
        } else {
            node.ret = v
        }
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
        let f = node.scope.find(name: node.id)!.subScope!.correspondingNode!.ret as! Function
        var arg = [Value]()
        node.arguments.forEach{arg.append($0.ret!)}
        let ret = CallInst(name: "", type: getType(type: node.type), function: f, arguments: arg)
        currentBlock.inst.append(ret)
        node.ret = ret
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

//    case add, sub, mul, div, mod, gt, lt, geq, leq, eq, neq, bitAnd, bitOr, bitXor, logAnd, logOr, lShift, rShift, assign
    private let opMap: [BinaryOperator: Inst.OP] = [.add: .add, .sub: .sub, .mul: .mul, .div: .sdiv, .mod: .srem, .bitAnd: .and, .bitOr: .or, .bitXor: .xor, .lShift: .shl, .rShift: .ashr]
    private let cmpMap: [BinaryOperator: CompareInst.CMP] = [.lt: .slt, .leq: .sle, .gt: .sgt, .geq: .sge]
    
    override func visit(node: BinaryE) {
        super.visit(node: node)
        switch node.op {
        case .add, .sub, .mul, .div, .mod, .bitAnd, .bitOr, .bitXor, .lShift, .rShift:
            node.ret = BinaryInst(name: "", type: node.lhs.ret!.type, operation: opMap[node.op]!, lhs: node.lhs.ret!, rhs: node.rhs.ret!)
        case .assign:
            0
////            let v = node.scope.find(name: node.lhs)!.value!
//            if v is AllocaInst {
//                let ret = LoadInst(name: "", alloc: v as! AllocaInst)
//                node.ret = ret
//                currentBlock.inst.append(ret)
//            } else {
//                node.ret = v
//            }
//            node.ret = StoreInst(name: <#T##String#>, alloc: <#T##Value#>, val: <#T##Value#>)
        case .eq, .neq:
            switch node.type {
            case int:
                node.ret = CompareInst(name: "", type: IntT(width: .bool), operation: .icmp, lhs: node.lhs.ret!, rhs: node.rhs.ret!, cmp: cmpMap[node.op]!)
            default: //string
                0
            }
        case .lt, .gt, .leq, .geq, .logOr, .logAnd:
            node.ret = CompareInst(name: "", type: IntT(width: .bool), operation: .icmp, lhs: node.lhs.ret!, rhs: node.rhs.ret!, cmp: cmpMap[node.op]!)
        default:
            node.ret = Value(name: "", type: Type())
        }
        currentBlock.inst.append(node.ret as! Inst)
    }

}
