//
//  IRBuilder.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/5.
//

import Foundation

class IRBuilder: ASTBaseVisitor {
    
    var module = Module()
    var curBlock: BasicBlock!
    var continueToBlock: BasicBlock!
    var breakToBlock: BasicBlock!
    var conditionCounter = UnnamedCounter()
    
    let pointerSize = 8
    
    private func getType(type: String) -> Type {
        switch type {
        case int:
            return IntT(.int)
        case bool:
            return IntT(.bool)
        case void:
            return IntT(.int) // mark: void not implemented, use i32 instead
        case string:
            return PointerT(base: IntT(.char))
        case let x where x.hasSuffix("[]"):
            return PointerT(base: getType(type: x.dropArray()))
        default: //  structures...
//            return PointerT(base: )
            return Type()
        }
    }
    private class Builtin {
        static var functions = [String: Function]()
        static func addFunc(name: String, f: (() -> Function)) {
            functions[name] = f()
        }
        
        static func malloc() -> Function {
            functions["malloc"]!
        }
        static func putchar() -> Function {
            functions["putchar"]!
        }
    }
    
    override init() {
        super.init()
        Builtin.addFunc(name: "malloc") {
            Function(name: "malloc", type: PointerT(base: IntT(.char)),
                     module: module, attr: "allocsize(0)")
                .added(operand: Value(name: "", type: IntT(.long)))
        }
        Builtin.addFunc(name: "putchar") {
            Function(name: "putchar", type: IntT(.int),
                     module: module, attr: "")
                .added(operand: Value(name: "", type: IntT(.int)))
        }
    }
    
    override func visit(node: Program) {
        super.visit(node: node)
    }

    override func visit(node: VariableDecl) {
        super.visit(node: node)
        let type = getType(type: node.type)
        node.variable.forEach {
            let sym = node.scope.find(name: $0.0)!
            let ret = AllocaInst(name: $0.0, forType: type, in: curBlock)
            sym.value = ret
            if let e = $0.1 {
                let rhs = e.ret!.isAddress ? LoadInst(name: "", alloc: e.ret!, in: curBlock) : e.ret!
                StoreInst(name: "", alloc: ret, val: rhs, in: curBlock)
            }
        }
    }

    override func visit(node: FunctionDecl) {
//        super.visit(node: node)
//        var parType = [Type]()
//        node.parameters.forEach{parType.append(getType(type: $0.type))}
        
        let ret = Function(name: node.id,
                           type: getType(type: node.type),
                           module: module)
        
        curBlock = ret.newBlock(withName: "")
        
        node.parameters.forEach {
            let par = Value(name: $0.variable[0].0, type: getType(type: $0.type))
            ret.operands.append(par)
            let alc = AllocaInst(name: "", forType: par.type, in: curBlock)
            $0.scope.find(name: $0.variable[0].0)!.value = alc
            StoreInst(name: "", alloc: alc, val: par, in: curBlock)
        }
        
        node.statements.forEach {
            $0.accept(visitor: self)
        }
        
        if node.type == void {
//            ReturnInst(name: "", val: VoidInstant(name: "", type: VoidT()), in: curBlock)
            ReturnInst(name: "", val: Instant(name: "", type: IntT(.int), value: 0), in: curBlock)
        }
        
        node.ret = ret
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
        let number = conditionCounter.tik
        
        node.condition.accept(visitor: self)
        let cond = node.condition.ret!.isAddress ? LoadInst(name: "IC" + number, alloc: node.condition.ret!, in: curBlock) : node.condition.ret!
        let accept = curBlock.currentFunction.newBlock(withName: "IA" + number)
        let reject = curBlock.currentFunction.newBlock(withName: "IR" + number)
        let merge = curBlock.currentFunction.newBlock(withName: "IM" + number)
        BrInst(name: "", condition: cond, accept: accept, reject: reject, in: curBlock)
        
        curBlock = accept
        node.accept!.accept(visitor: self)
        BrInst(name: "", des: merge, in: curBlock)
        
        curBlock = reject
        node.reject?.accept(visitor: self)
        BrInst(name: "", des: merge, in: curBlock)
        
        curBlock = merge
    }

    override func visit(node: WhileS) {
//        super.visit(node: node)
        let number = conditionCounter.tik
        
        let judge = curBlock.currentFunction.newBlock(withName: "WJ" + number)
        let accept = curBlock.currentFunction.newBlock(withName: "WA" + number)
        let merge = curBlock.currentFunction.newBlock(withName: "WM" + number)
        BrInst(name: "", des: judge, in: curBlock)
        curBlock = judge
        node.condition.accept(visitor: self)
        let cond = node.condition.ret!.isAddress ? LoadInst(name: "", alloc: node.condition.ret!, in: curBlock) : node.condition.ret!
        BrInst(name: "", condition: cond, accept: accept, reject: merge, in: curBlock)
        
        curBlock = accept
        breakToBlock = merge
        continueToBlock = judge
        node.accept!.accept(visitor: self)
        BrInst(name: "", des: judge, in: curBlock)
        
        curBlock = merge
    }

    override func visit(node: ForS) {
//        super.visit(node: node)
        node.initial?.accept(visitor: self)
        
        let number = conditionCounter.tik
        let accept = curBlock.currentFunction.newBlock(withName: "FA" + number)
        let merge = curBlock.currentFunction.newBlock(withName: "FM" + number)
        
        if let c = node.condition {
            let judge = curBlock.currentFunction.newBlock(withName: "FJ" + number)
            BrInst(name: "", des: judge, in: curBlock)
            curBlock = judge
            c.accept(visitor: self)
            let cond = c.ret!.isAddress ? LoadInst(name: "", alloc: c.ret!, in: curBlock) : c.ret!
            BrInst(name: "", condition: cond, accept: accept, reject: merge, in: curBlock)
            
            curBlock = accept
            breakToBlock = merge
            continueToBlock = judge
            node.accept?.accept(visitor: self)
            node.increment?.accept(visitor: self)
            BrInst(name: "", des: judge, in: curBlock)
        } else {
            let cond = Instant(name: "", type: IntT(.bool), value: 1)
            BrInst(name: "", condition: cond, accept: accept, reject: merge, in: curBlock)
            
            curBlock = accept
            breakToBlock = merge
            continueToBlock = accept
            node.accept?.accept(visitor: self)
            node.increment?.accept(visitor: self)
            BrInst(name: "", des: accept, in: curBlock)
        }
        
        curBlock = merge
    }

    override func visit(node: ReturnS) {
        super.visit(node: node)
        if let e = node.expression {
            let ret = e.ret!.isAddress ? LoadInst(name: "", alloc: e.ret!, in: curBlock) : e.ret!
            node.ret = ReturnInst(name: "", val: ret, in: curBlock)
        }
    }

    override func visit(node: BreakS) {
        super.visit(node: node)
        BrInst(name: "", des: breakToBlock, in: curBlock)
    }

    override func visit(node: ContinueS) {
        super.visit(node: node)
        BrInst(name: "", des: continueToBlock, in: curBlock)
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
        let toSub = node.array.ret!, index = node.index.ret!
        let t = toSub.isAddress ? LoadInst(name: "", alloc: toSub, in: curBlock) : toSub
        let i = index.isAddress ? LoadInst(name: "", alloc: index, in: curBlock) : index
        node.ret = GEPInst(name: "", type: t.type, base: t, needZero: false, val: i, in: curBlock)
    }

    override func visit(node: FunctionCallE) {
        super.visit(node: node)
        var f: Function?
        if node.id == "putchar" {
            f = Builtin.putchar()
        } else {
            f = node.scope.find(name: node.id)!.subScope!.correspondingNode!.ret as! Function
        }
        var arg = [Value]()
        node.arguments.forEach{
            arg.append($0.ret!.isAddress ? LoadInst(name: "", alloc: $0.ret!, in: curBlock) : $0.ret!)
        }
        node.ret = CallInst(name: "", function: f!, arguments: arg, in: curBlock)
    }

    override func visit(node: SuffixE) {
        super.visit(node: node)
    }

    override func visit(node: PrefixE) {
        super.visit(node: node)
    }

    override func visit(node: NewE) {
        super.visit(node: node)
        // deal with the last non-zero dim
        let type = getType(type: node.type)
        let size = node.empty > 0 ? pointerSize : type.bit ;
        let call = CallInst(name: "", function: Builtin.malloc(), arguments: [Instant(name: "", type: IntT(.long), value: size)], in: curBlock)
        node.ret = CastInst(name: "", val: call, toType: type, in: curBlock)
    }

//    case add, sub, mul, div, mod, gt, lt, geq, leq, eq, neq, bitAnd, bitOr, bitXor, logAnd, logOr, lShift, rShift, assign
    private let opMap: [BinaryOperator: Inst.OP] = [.add: .add, .sub: .sub, .mul: .mul, .div: .sdiv, .mod: .srem, .bitAnd: .and, .bitOr: .or, .bitXor: .xor, .lShift: .shl, .rShift: .ashr]
    private let cmpMap: [BinaryOperator: CompareInst.CMP] = [.eq: .eq, .neq: .ne, .lt: .slt, .leq: .sle, .gt: .sgt, .geq: .sge]
    
    override func visit(node: BinaryE) {
        super.visit(node: node)
        if node.op == .assign {
            let lhs = node.lhs.ret!
            let rhs = node.rhs.ret!.isAddress ? LoadInst(name: "", alloc: node.rhs.ret!, in: curBlock) : node.rhs.ret!
            node.ret = StoreInst(name: "", alloc: lhs, val: rhs, in: curBlock)
        } else {
            let lhs = node.lhs.ret!.isAddress ? LoadInst(name: "", alloc: node.lhs.ret!, in: curBlock) : node.lhs.ret!
            let rhs = node.rhs.ret!.isAddress ? LoadInst(name: "", alloc: node.rhs.ret!, in: curBlock) : node.rhs.ret!
            switch node.op {
            case .add, .sub, .mul, .div, .mod, .bitAnd, .bitOr, .bitXor, .lShift, .rShift:
                node.ret = BinaryInst(name: "", type: lhs.type, operation: opMap[node.op]!, lhs: lhs, rhs: rhs, in: curBlock)
            case .eq, .neq, .lt, .gt, .leq, .geq:
                switch node.lhs.type {
                case int:
                    node.ret = CompareInst(name: "", operation: .icmp, lhs: lhs, rhs: rhs, cmp: cmpMap[node.op]!, in: curBlock)
                default: //string
                    0
                }
            case .logOr, .logAnd:
                node.ret = CompareInst(name: "", operation: .icmp, lhs: lhs, rhs: rhs, cmp: cmpMap[node.op]!, in: curBlock)
            default:
                0
//                node.ret = currentBlock.create(Value(name: "", type: Type()))
            }
        }
    }

}
