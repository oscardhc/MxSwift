//
//  IRBuilder.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/5.
//

import Foundation

class IRBuilder: ASTBaseVisitor {
    
    var module = Module()
    var currentBlock: BasicBlock!
    var continueToBlock: BasicBlock!
    var breakToBlock: BasicBlock!
    
    private func getType(type: String) -> Type {
        switch type {
        case int:
            return IntT(.int)
        case bool:
            return IntT(.bool)
        case string:
            return PointerT(base: IntT(.char))
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
            let sym = node.scope.find(name: id)!
            let ret = currentBlock.create(AllocaInst(name: id, forType: getType(type: node.type)))
            sym.value = ret
        }
    }

    override func visit(node: FunctionDecl) {
//        super.visit(node: node)
        var parType = [Type]()
        node.parameters.forEach{parType.append(getType(type: $0.type))}
        
        let ret = Function(name: node.id,
                           type: FunctionT(ret: getType(type: node.type), par: parType),
                           module: module)
        
        
        currentBlock = ret.newBlock(withName: "")
        
        node.parameters.forEach {
            let par = Value(name: $0.id[0], type: getType(type: $0.type))
            ret.parameters.append(par)
            let alc = currentBlock.create(AllocaInst(name: "", forType: par.type))
            $0.scope.find(name: $0.id[0])!.value = alc
            _ = currentBlock.create(StoreInst(name: "", alloc: alc, val: par))
        }
        
        node.statements.forEach {
            $0.accept(visitor: self)
        }
        
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
//        super.visit(node: node)
        node.condition.accept(visitor: self)
        let cond = node.condition.ret!.isAddress ? currentBlock.create(LoadInst(name: "", alloc: node.condition.ret!)) : node.condition.ret!
        let accept = currentBlock.currentFunction.newBlock(withName: "")
        let reject = currentBlock.currentFunction.newBlock(withName: "")
        let merge = currentBlock.currentFunction.newBlock(withName: "")
        _ = currentBlock.create(BrInst(name: "", condition: cond, accept: accept, reject: reject))
        
        currentBlock = accept
        node.accept!.accept(visitor: self)
        _ = currentBlock.create(BrInst(name: "", des: merge))
        
        currentBlock = reject
        node.reject?.accept(visitor: self)
        _ = currentBlock.create(BrInst(name: "", des: merge))
        
        currentBlock = merge
    }

    override func visit(node: WhileS) {
//        super.visit(node: node)
        let judge = currentBlock.currentFunction.newBlock(withName: "")
        let accept = currentBlock.currentFunction.newBlock(withName: "")
        let merge = currentBlock.currentFunction.newBlock(withName: "")
        _ = currentBlock.create(BrInst(name: "", des: judge))
        currentBlock = judge
        node.condition.accept(visitor: self)
        let cond = node.condition.ret!.isAddress ? currentBlock.create(LoadInst(name: "", alloc: node.condition.ret!)) : node.condition.ret!
        _ = currentBlock.create(BrInst(name: "", condition: cond, accept: accept, reject: merge))
        
        currentBlock = accept
        breakToBlock = merge
        continueToBlock = judge
        node.accept!.accept(visitor: self)
        _ = currentBlock.create(BrInst(name: "", des: judge))
        
        currentBlock = merge
    }

    override func visit(node: ForS) {
//        super.visit(node: node)
        node.initial?.accept(visitor: self)
        
        let accept = currentBlock.currentFunction.newBlock(withName: "")
        let merge = currentBlock.currentFunction.newBlock(withName: "")
        
        if let c = node.condition {
            let judge = currentBlock.currentFunction.newBlock(withName: "")
            _ = currentBlock.create(BrInst(name: "", des: judge))
            currentBlock = judge
            c.accept(visitor: self)
            let cond = c.ret!.isAddress ? currentBlock.create(LoadInst(name: "", alloc: c.ret!)) : c.ret!
            _ = currentBlock.create(BrInst(name: "", condition: cond, accept: accept, reject: merge))
            
            currentBlock = accept
            breakToBlock = merge
            continueToBlock = judge
            node.accept?.accept(visitor: self)
            node.increment?.accept(visitor: self)
            _ = currentBlock.create(BrInst(name: "", des: judge))
        } else {
            let cond = Instant(name: "", type: IntT(.bool), value: 1)
            _ = currentBlock.create(BrInst(name: "", condition: cond, accept: accept, reject: merge))
            
            currentBlock = accept
            breakToBlock = merge
            continueToBlock = accept
            node.accept?.accept(visitor: self)
            node.increment?.accept(visitor: self)
            _ = currentBlock.create(BrInst(name: "", des: accept))
        }
        
        currentBlock = merge
    }

    override func visit(node: ReturnS) {
        super.visit(node: node)
        if let e = node.expression {
            let ret = e.ret!.isAddress ? currentBlock.create(LoadInst(name: "", alloc: e.ret!)) : e.ret!
            node.ret = currentBlock.create(ReturnInst(name: "", type: getType(type: e.type), val: ret))
        }
    }

    override func visit(node: BreakS) {
        super.visit(node: node)
        currentBlock.create(BrInst(name: "", des: breakToBlock))
    }

    override func visit(node: ContinueS) {
        super.visit(node: node)
        currentBlock.create(BrInst(name: "", des: continueToBlock))
    }

    override func visit(node: ExpressionS) {
        super.visit(node: node)
        node.ret = node.expression.ret
    }

    override func visit(node: VariableE) {
        super.visit(node: node)
        let v = node.scope.find(name: node.id)!.value!
        node.ret = v
    }

    override func visit(node: ThisLiteralE) {
        super.visit(node: node)
    }

    override func visit(node: BoolLiteralE) {
        super.visit(node: node)
        node.ret = Instant(name: "never", type: IntT(.bool), value: node.value ? 1 : 0)
    }

    override func visit(node: IntLiteralE) {
        super.visit(node: node)
        node.ret = Instant(name: "never", type: IntT(.int), value: node.value)
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
        node.arguments.forEach{
            arg.append($0.ret!.isAddress ? currentBlock.create(LoadInst(name: "", alloc: $0.ret!)) : $0.ret!)
        }
        node.ret = currentBlock.create(CallInst(name: "", type: getType(type: node.type), function: f, arguments: arg))
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
    private let cmpMap: [BinaryOperator: CompareInst.CMP] = [.eq: .eq, .neq: .ne, .lt: .slt, .leq: .sle, .gt: .sgt, .geq: .sge]
    
    override func visit(node: BinaryE) {
        if node.op == .assign {
            super.visit(node: node)
            let lhs = node.lhs.ret!
            let rhs = node.rhs.ret!.isAddress ? currentBlock.create(LoadInst(name: "", alloc: node.rhs.ret!)) : node.rhs.ret!
            node.ret = currentBlock.create(StoreInst(name: "", alloc: lhs, val: rhs))
        } else {
            super.visit(node: node)
            let lhs = node.lhs.ret!.isAddress ? currentBlock.create(LoadInst(name: "", alloc: node.lhs.ret!)) : node.lhs.ret!
            let rhs = node.rhs.ret!.isAddress ? currentBlock.create(LoadInst(name: "", alloc: node.rhs.ret!)) : node.rhs.ret!
            switch node.op {
            case .add, .sub, .mul, .div, .mod, .bitAnd, .bitOr, .bitXor, .lShift, .rShift:
                node.ret = currentBlock.create(BinaryInst(name: "", type: lhs.type, operation: opMap[node.op]!, lhs: lhs, rhs: rhs))
            case .eq, .neq, .lt, .gt, .leq, .geq:
                switch node.lhs.type {
                case int:
                    node.ret = currentBlock.create(CompareInst(name: "", operation: .icmp, lhs: lhs, rhs: rhs, cmp: cmpMap[node.op]!))
                default: //string
                    0
                }
            case .logOr, .logAnd:
                node.ret = currentBlock.create(CompareInst(name: "", operation: .icmp, lhs: lhs, rhs: rhs, cmp: cmpMap[node.op]!))
            default:
                0
//                node.ret = currentBlock.create(Value(name: "", type: Type()))
            }
        }
    }

}
