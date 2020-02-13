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
    var curClass: Class?
    var continueToBlock: BasicBlock!
    var breakToBlock: BasicBlock!
    var conditionCounter = UnnamedCounter()
    var globalInit = true
    
    let pointerSize = 8
    
    private func getType(type: String) -> Type {
        switch type {
        case int:
            return IRInt.int
        case bool:
            return IRInt.bool
        case void:
            return IRInt.int // mark: void not implemented, use i32 instead
        case string:
            return IRPointer(base: IRInt.char)
        case let x where x.hasSuffix("[]"):
            return IRPointer(base: getType(type: x.dropArray()))
        default: //  structures...
            return IRPointer(base: IRClass(name: type))
        }
    }
    
    enum Builtin {
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
            Function(name: "malloc", type: IRPointer(base: IRInt.char),
                     module: module, attr: "allocsize(0)")
                .added(operand: Value(name: "", type: IRInt.long))
        }
        Builtin.addFunc(name: "putchar") {
            Function(name: "putchar", type: IRInt.int,
                     module: module, attr: "")
                .added(operand: Value(name: "", type: IRInt.int))
        }
    }
    
    override func visit(node: Program) {
        let globalFunc = Function(name: "global_init", type: getType(type: void), module: module)
        curBlock = BasicBlock(curfunc: globalFunc)
        for i in node.declarations where i is VariableD {
            i.accept(visitor: self)
        }
        globalInit = false
        for _f in node.declarations where _f is FunctionD {
            let f = _f as! FunctionD
            _f.ret = Function(name: f.id, type: getType(type: f.type), module: module)
        }
        for i in node.declarations where !(i is VariableD) {
            i.accept(visitor: self)
        }
    }
    
    private func assign(lhs: Value, rhs: Value) {
        if rhs is NullConst {
            rhs.type = lhs.type.getBase
        }
        StoreInst(name: "", alloc: lhs,
                  val: rhs.isAddress ? LoadInst(name: "", alloc: rhs, in: curBlock) : rhs,
                  in: curBlock)
    }
    
    override func visit(node: VariableD) {
        super.visit(node: node)
        let type = getType(type: node.type)
        if curClass != nil {
            node.variable.forEach {
                _ = curClass!.added(subType: ($0.0, type))
            }
        } else {
            node.variable.forEach {
                let sym = node.scope.find(name: $0.0)!
                if globalInit {
                    print(">>>>>>", curBlock.currentFunction)
                    let e = $0.1?.ret?.loadIfAddress(block: curBlock)
                    if e is Const {
                        print("??????????")
                        sym.value = GlobalVariable(name: $0.0, value: e as! Const, module: module)
                    } else {
                        var const: Const {
                            switch node.type {
                            case int:
                                return IntConst(name: "", type: type, value: 0)
                            default:
                                return NullConst(name: "", type: type)
                            }
                        }
                        sym.value = GlobalVariable(name: $0.0, value: const, module: module)
                        if e != nil {
                            assign(lhs: sym.value!, rhs: e!)
                        }
                    }
                } else {
                    let ret = AllocaInst(name: $0.0, forType: type, in: curBlock)
                    sym.value = ret
                    if let e = $0.1 {
                        _ = assign(lhs: ret, rhs: e.ret!)
                    }
                }
            }
        }
    }
    
    override func visit(node: FunctionD) {
        let ret = node.ret as! Function
        curBlock = BasicBlock(curfunc: ret)
        
        if curClass != nil {
            _ = ret.added(operand: Value(name: "this", type: IRPointer(base: curClass!.type)))
        }
        
        node.parameters.forEach {
            let par = Value(name: $0.variable[0].0, type: getType(type: $0.type))
            _ = ret.added(operand: par)
            let alc = AllocaInst(name: "", forType: par.type, in: curBlock)
            $0.scope.find(name: $0.variable[0].0)!.value = alc
            StoreInst(name: "", alloc: alc, val: par, in: curBlock)
        }
        
        node.statements.forEach {
            $0.accept(visitor: self)
        }
        
        if node.type == void || node.hasReturn == false {
            ReturnInst(name: "", val: IntConst(name: "", type: IRInt.int, value: 0), in: curBlock)
        }
    }
    
    override func visit(node: ClassD) {
        //        super.visit(node: node)
        
        curClass = Class(name: node.id, type: IRClass(name: node.id), module: module)
        node.ret = curClass
        
        node.initial.forEach {
            $0.ret = Function(name: $0.id, type: getType(type: void), module: module)
        }
        node.methods.forEach {
            $0.ret = Function(name: $0.id, type: getType(type: $0.type), module: module)
        }
        
        
        node.properties.forEach {
            $0.accept(visitor: self)
        }
        
        node.initial.forEach {
            $0.accept(visitor: self)
        }
        node.methods.forEach {
            $0.accept(visitor: self)
        }
        curClass = nil
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
        let accept = BasicBlock(curfunc: curBlock.currentFunction)
        let reject = BasicBlock(curfunc: curBlock.currentFunction)
        let merge = BasicBlock(curfunc: curBlock.currentFunction)
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
        
        let judge = BasicBlock(curfunc: curBlock.currentFunction)
        let accept = BasicBlock(curfunc: curBlock.currentFunction)
        let merge = BasicBlock(curfunc: curBlock.currentFunction)
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
        let accept = BasicBlock(curfunc: curBlock.currentFunction)
        let merge = BasicBlock(curfunc: curBlock.currentFunction)
        
        if let c = node.condition {
            let judge = BasicBlock(curfunc: curBlock.currentFunction)
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
            let cond = IntConst(name: "", type: IRInt.bool, value: 1)
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
    
    private var this: Value {
        (curBlock?.currentFunction.operands[0])! // first parameter: this
    }
    
    override func visit(node: VariableE) {
        super.visit(node: node)
        let sym = node.scope.find(name: node.id)!
        if sym.value != nil {
            node.ret = sym.value
        } else {
            let cls = sym.belongsTo.correspondingNode as! ClassD
            node.ret = getMemberAccess(cls: cls, base: this, for: node.id)
        }
    }
    
    override func visit(node: ThisLiteralE) {
        super.visit(node: node)
        node.ret = this
    }
    
    override func visit(node: BoolLiteralE) {
        super.visit(node: node)
        node.ret = IntConst(name: "never", type: IRInt.bool, value: node.value ? 1 : 0)
    }
    
    override func visit(node: IntLiteralE) {
        super.visit(node: node)
        node.ret = IntConst(name: "never", type: IRInt.int, value: node.value)
    }
    
    override func visit(node: StringLiteralE) {
        super.visit(node: node)
    }
    
    override func visit(node: NullLiteralE) {
        super.visit(node: node)
        node.ret = NullConst(name: "", type: Type())
    }
    
    override func visit(node: MethodAccessE) {
        //        super.visit(node: node)
        node.toAccess.accept(visitor: self)
        let t = node.toAccess.ret!.loadIfAddress(block: curBlock)
        node.method.accept(visitor: self)
        node.ret = (node.method.ret! as! CallInst).inserted(operand: t)
    }
    
    private func getMemberAccess(cls: ClassD, base: Value, for property: String) -> GEPInst? {
        var count = 0
        for pro in cls.properties {
            for (j, (name, _)) in pro.variable.enumerated() {
                if name == property {
                    return GEPInst(name: "",
                                   type: IRPointer(base: getType(type: pro.type)),
                                   base: base,
                                   needZero: true,
                                   val: IntConst(name: "", type: IRInt.int, value: count + j),
                                   in: curBlock)
                }
                count += pro.variable.count
            }
        }
        return nil
    }
    
    override func visit(node: PropertyAccessE) {
        super.visit(node: node)
        node.ret = getMemberAccess(cls: node.scope.correspondingNode! as! ClassD,
                                   base: node.toAccess.ret!.loadIfAddress(block: curBlock),
                                   for: node.property)!
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
        var sym: Symbol?
        if node.id == "putchar" {
            f = Builtin.putchar()
        } else {
            sym = node.scope.find(name: node.id)!
            f = sym!.subScope!.correspondingNode!.ret as! Function
        }
        
        var arg = [Value]()
        node.arguments.forEach{
            arg.append($0.ret!.isAddress ? LoadInst(name: "", alloc: $0.ret!, in: curBlock) : $0.ret!)
        }
        
        if sym != nil && sym!.belongsTo.scopeType == .CLASS {
            // handle new instances
            if sym!.belongsTo.scopeName == node.id {
                let size = ((sym!.belongsTo.correspondingNode as! ClassD).ret! as! Class).getSize
                let call = CallInst(name: "",
                                    function: Builtin.malloc(),
                                    arguments: [IntConst(name: "", type: IRInt.long, value: size)],
                                    in: curBlock)
                let cast = CastInst(name: "", val: call, toType: getType(type: node.id), in: curBlock)
                arg.insert(cast, at: 0)
                _ = CallInst(name: "", function: f!, arguments: arg, in: curBlock)
                node.ret = cast
                
                return
                
            } else if node.needThis {
                arg.insert(this, at: 0)
            }
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
        
        let perSize = IntConst(name: "",
                               type: IRInt.int,
                               value: node.empty > 0 ? pointerSize : type.space)
        let num = node.expressions.last!.ret!.loadIfAddress(block: curBlock)
        
        let size = BinaryInst(name: "", type: IRInt.int, operation: .mul, lhs: perSize, rhs: num, in: curBlock)
        let cast = SExtInst(name: "", val: size, toType: IRInt.long, in: curBlock)
        
        let call = CallInst(name: "",
                            function: Builtin.malloc(),
                            arguments: [cast],
                            in: curBlock)
        
        node.ret = CastInst(name: "", val: call, toType: type, in: curBlock)
    }
    
    //    case add, sub, mul, div, mod, gt, lt, geq, leq, eq, neq, bitAnd, bitOr, bitXor, logAnd, logOr, lShift, rShift, assign
    private let opMap: [BinaryOperator: Inst.OP] = [.add: .add, .sub: .sub, .mul: .mul, .div: .sdiv, .mod: .srem, .bitAnd: .and, .bitOr: .or, .bitXor: .xor, .lShift: .shl, .rShift: .ashr]
    private let cmpMap: [BinaryOperator: CompareInst.CMP] = [.eq: .eq, .neq: .ne, .lt: .slt, .leq: .sle, .gt: .sgt, .geq: .sge]
    
    override func visit(node: BinaryE) {
        super.visit(node: node)
        if node.op == .assign {
            assign(lhs: node.lhs.ret!, rhs: node.rhs.ret!)
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
                    break
                }
            case .logOr, .logAnd:
                node.ret = CompareInst(name: "", operation: .icmp, lhs: lhs, rhs: rhs, cmp: cmpMap[node.op]!, in: curBlock)
            default:
                break
                //                node.ret = currentBlock.create(Value(name: "", type: Type()))
            }
        }
    }
    
}
