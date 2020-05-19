//
//  IRBuilder.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/5.
//

import Foundation

class IRBuilder: ASTBaseVisitor {
    
    var module = Module()
    var curBlock: BlockIR!
    var curClass: Class?
    var controlBlock = [(BlockIR, BlockIR)]() // (breakTo, continueTo)
    
    var globalInit = true
    var globalFunc: FunctionIR!
    
    let pointerSize = 8
    
    private func getType(type: String) -> TypeIR {
        switch type {
        case int:
            return .int
        case bool:
            return .bool
        case void:
            return .void // mark: void not implemented, use i32 instead
        case string:
            return .string
        case let x where x.hasSuffix("[]"):
            return getType(type: x.dropArray()).pointer
        default: //  structures...
            return ClassT(name: type).pointer
        }
    }
    
    enum Builtin {
        static var functions = [String: FunctionIR]()
        static func addFunc(name: String, f: (() -> FunctionIR)) {
            functions[name] = f()
        }
    }
    
    override init() {
        super.init()
        Builtin.addFunc(name: "malloc") {
            FunctionIR(name: "malloc", type: .string,
                     module: module)
                .added(operand: Value(type: .long))
        }
        Builtin.addFunc(name: "print") {
            FunctionIR(name: "print", type: .void, module: module)
                .added(operand: Value(type: .string))
        }
        Builtin.addFunc(name: "println") {
            FunctionIR(name: "println", type: .void, module: module)
                .added(operand: Value(type: .string))
        }
        Builtin.addFunc(name: "printInt") {
            FunctionIR(name: "printInt", type: .void, module: module)
                .added(operand: Value(type: .int))
        }
        Builtin.addFunc(name: "printlnInt") {
            FunctionIR(name: "printlnInt", type: .void, module: module)
                .added(operand: Value(type: .int))
        }
        Builtin.addFunc(name: "toString") {
            FunctionIR(name: "toString", type: .string, module: module, noSideEffect: true)
                .added(operand: Value(type: .int))
        }
        Builtin.addFunc(name: "getInt") {
            FunctionIR(name: "getInt", type: .int, module: module)
        }
        Builtin.addFunc(name: "getString") {
            FunctionIR(name: "getString", type: .string, module: module)
        }
        Builtin.addFunc(name: "length") {
            FunctionIR(name: "_str_length", type: .int, module: module, noSideEffect: true)
                .added(operand: Value(type: .string))
        }
        Builtin.addFunc(name: "parseInt") {
            FunctionIR(name: "_str_parseInt", type: .int, module: module, noSideEffect: true)
                .added(operand: Value(type: .string))
        }
        Builtin.addFunc(name: "ord") {
            FunctionIR(name: "_str_ord", type: .int, module: module, noSideEffect: true)
                .added(operand: Value(type: .string))
                .added(operand: Value(type: .int))
        }
        Builtin.addFunc(name: "substring") {
            FunctionIR(name: "_str_substring", type: .string, module: module, noSideEffect: true)
                .added(operand: Value(type: .string))
                .added(operand: Value(type: .int))
                .added(operand: Value(type: .int))
        }
        addStringBOP(name: "add", type: .string)
        addStringBOP(name: "eq", type: .bool)
        addStringBOP(name: "ne", type: .bool)
        addStringBOP(name: "slt", type: .bool)
        addStringBOP(name: "sgt", type: .bool)
        addStringBOP(name: "sle", type: .bool)
        addStringBOP(name: "sge", type: .bool)
    }
    
    private func addStringBOP(name: String, type: TypeIR) {
        Builtin.addFunc(name: "_str_" + name) {
            FunctionIR(name: "_str_" + name, type: type, module: module)
                .added(operand: Value(type: .string))
                .added(operand: Value(type: .string))
        }
    }
    
    override func visit(node: Program) {
        
        // step 1: make all functions "callable" by adding a empty Function node
        for _d in node.declarations {
            if let f = _d as? FunctionD {
                f.ret = FunctionIR(name: f.id, type: getType(type: f.type), module: module)
            }
            if let c = _d as? ClassD {
                c.ret = Class(name: c.id, type: ClassT(name: c.id), module: module)
                c.initial.forEach {
                    $0.ret = FunctionIR(name: c.id + "_" + $0.id, type: getType(type: void), module: module)
                }
                c.methods.forEach {
                    $0.ret = FunctionIR(name: c.id + "_" + $0.id, type: getType(type: $0.type), module: module)
                }
            }
        }
        
        // step 2: global variable declarations
        globalFunc = FunctionIR(name: "global_init", type: getType(type: void), module: module)
        module.globalInit = globalFunc
        curBlock = BlockIR(curfunc: globalFunc)
        for i in node.declarations where i is VariableD {
            i.accept(visitor: self)
        }
        globalInit = false
        
        // step 3: others
        for i in node.declarations where !(i is VariableD) {
            i.accept(visitor: self)
        }
        
        // return for global init
        ReturnInst(val: VoidC(), in: globalFunc.blocks[0])
        
        for v in module.functions {
            if v.name == "@main" {
                for blk in v.blocks {
                    ReturnInst(val: IntC.zero(), in: blk)
                }
            }
            if v.type is VoidT {
                for blk in v.blocks {
                    ReturnInst(val: VoidC(), in: blk)
                }
            }
        }
    }
    
    private func assign(lhs: Value, rhs: Value, in block: BlockIR) {
        if rhs is NullC {
            rhs.type = lhs.type.getBase
        }
        StoreInst(alloc: lhs,
                  val: rhs.loadIfAddress(block: block),
                  in: block)
    }
    
    override func visit(node: VariableD) {
        super.visit(node: node)
        let type = getType(type: node.type)
        if curClass != nil && curBlock == nil {
            node.variable.forEach {
                _ = curClass!.added(subType: ($0.0, type))
            }
        } else {
            node.variable.forEach {
                let sym = node.scope.find(name: $0.0)!
                if globalInit {
                    let e = $0.1?.ret?.loadIfAddress(block: curBlock)
                    if e is ConstIR && !(e is NullC) {
                        sym.value = GlobalVariable(name: $0.0, value: e as! ConstIR, module: module, isConst: false)
                    } else {
                        var const: ConstIR {
                            switch node.type {
                            case int:
                                return IntC(type: type, value: 0)
                            default:
                                return NullC(type: type)
                            }
                        }
                        sym.value = GlobalVariable(name: $0.0, value: const, module: module, isConst: false)
                    }
                    if e != nil {
                        assign(lhs: sym.value!, rhs: e!, in: curBlock)
                    }
                } else {
                    let ret = AllocaInst(forType: type, in: curBlock.inFunction.blocks[0], at: 0)
                    sym.value = ret
                    print("!!! ALLOCA", ret.type)
                    if let e = $0.1 {
                        _ = assign(lhs: ret, rhs: e.ret!, in: curBlock)
                    } else if ret.type.getBase is PointerT {
                        _ = assign(lhs: ret, rhs: NullC(type: ret.type.getBase), in: curBlock)
                    }
                }
            }
        }
    }
    
    override func visit(node: FunctionD) {
        let ret = node.ret as! FunctionIR
        curBlock = BlockIR(curfunc: ret)
        
        if node.id == "main" {
            _ = CallInst(function: globalFunc, in: curBlock)
        }
        
        if curClass != nil {
            _ = ret.added(operand: Value(name: "this", type: curClass!.type.pointer))
        }
        
        node.parameters.forEach {
            let par = Value(name: $0.variable[0].0, type: getType(type: $0.type))
            _ = ret.added(operand: par)
            let alc = AllocaInst(forType: par.type, in: curBlock)
            $0.scope.find(name: $0.variable[0].0)!.value = alc
            StoreInst(alloc: alc, val: par, in: curBlock)
        }
        
        node.statements.forEach {
            $0.accept(visitor: self)
        }
        
        curBlock = nil
    }
    
    override func visit(node: ClassD) {
        //        super.visit(node: node)
        curClass = node.ret! as? Class
        curBlock = nil
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
        
        node.condition.accept(visitor: self)
        let cond = node.condition.ret!.loadIfAddress(block: curBlock)
        let accept = BlockIR(curfunc: curBlock.inFunction)
        let reject = BlockIR(curfunc: curBlock.inFunction)
        let merge = BlockIR(curfunc: curBlock.inFunction)
        BrInst(condition: cond, accept: accept, reject: reject, in: curBlock)
        
        curBlock = accept
        node.accept!.accept(visitor: self)
        BrInst(des: merge, in: curBlock)
        
        curBlock = reject
        node.reject?.accept(visitor: self)
        BrInst(des: merge, in: curBlock)
        
        curBlock = merge
    }
    
    override func visit(node: WhileS) {
        //        super.visit(node: node)
        
        let judge = BlockIR(curfunc: curBlock.inFunction)
        let accept = BlockIR(curfunc: curBlock.inFunction)
        let merge = BlockIR(curfunc: curBlock.inFunction)
        BrInst(des: judge, in: curBlock)
        curBlock = judge
        node.condition.accept(visitor: self)
        let cond = node.condition.ret!.isAddress ? LoadInst(alloc: node.condition.ret!, in: curBlock) : node.condition.ret!
        BrInst(condition: cond, accept: accept, reject: merge, in: curBlock)
        
        curBlock = accept
        controlBlock.append((merge, judge))
        node.accept!.accept(visitor: self)
        BrInst(des: judge, in: curBlock)
        _ = controlBlock.popLast()
        
        curBlock = merge
    }
    
    override func visit(node: ForS) {
        //        super.visit(node: node)
        
        node.initial?.accept(visitor: self)
        
        let accept  = BlockIR(curfunc: curBlock.inFunction)
        let merge   = BlockIR(curfunc: curBlock.inFunction)
        let incr    = BlockIR(curfunc: curBlock.inFunction)
        
        if let c = node.condition {
            let judge = BlockIR(curfunc: curBlock.inFunction)
            BrInst(des: judge, in: curBlock)
            curBlock = judge
            c.accept(visitor: self)
            let cond = c.ret!.isAddress ? LoadInst(alloc: c.ret!, in: curBlock) : c.ret!
            BrInst(condition: cond, accept: accept, reject: merge, in: curBlock)
            
            curBlock = accept
            controlBlock.append((merge, incr))
            node.accept?.accept(visitor: self)
            BrInst(des: incr, in: curBlock)
            
            curBlock = incr
            node.increment?.accept(visitor: self)
            BrInst(des: judge, in: curBlock)
            
            _ = controlBlock.popLast()
        } else {
            let cond = IntC(type: .bool, value: 1)
            BrInst(condition: cond, accept: accept, reject: merge, in: curBlock)
            
            curBlock = accept
            controlBlock.append((merge, incr))
            node.accept?.accept(visitor: self)
            BrInst(des: incr, in: curBlock)
            
            curBlock = incr
            node.increment?.accept(visitor: self)
            BrInst(des: accept, in: curBlock)
            
            _ = controlBlock.popLast()
        }
        
        curBlock = merge
    }
    
    override func visit(node: ReturnS) {
        super.visit(node: node)
        if let e = node.expression {
            node.ret = ReturnInst(val: e.ret!.loadIfAddress(block: curBlock), in: curBlock)
        } else if curBlock.inFunction.type is VoidT {
            node.ret = ReturnInst(val: VoidC(), in: curBlock)
        }
    }
    
    override func visit(node: BreakS) {
        super.visit(node: node)
        BrInst(des: controlBlock.last!.0, in: curBlock)
    }
    
    override func visit(node: ContinueS) {
        super.visit(node: node)
        BrInst(des: controlBlock.last!.1, in: curBlock)
    }
    
    override func visit(node: ExpressionS) {
        super.visit(node: node)
        node.ret = node.expression.ret
    }
    
    private var this: Value {
        (curBlock?.inFunction[0])! // first parameter: this
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
        node.ret = IntC(type: .bool, value: node.value ? 1 : 0)
    }
    
    override func visit(node: IntLiteralE) {
        super.visit(node: node)
        node.ret = IntC(type: .int, value: node.value)
    }
    
    var globalStrMap = [String: GlobalVariable]()
    override func visit(node: StringLiteralE) {
        super.visit(node: node)
        let globS: GlobalVariable = {
            if let g = globalStrMap[node.value] {
                return g
            } else {
                let cons = StringC(value: node.value)
                let globS = GlobalVariable(name: "s.", value: cons, module: module)
                globalStrMap[node.value] = globS
                return globS
            }
        }()
//        let globP = GlobalVariable(name: "p.", value: NullC(type: .string), module: module, isConst: false)
//        let pos = GEPInst(type: .string, base: globS, needZero: true, val: IntC.zero(), in: globalFunc.blocks[0], at: 0)
//        StoreInst(alloc: globP, val: pos, in: globalFunc.blocks[0], at: 1)
//        node.ret = globP
        let pos = GEPInst(type: IntT.char.pointer, base: globS, needZero: true, val: IntC.zero(), in: curBlock, doNotLoad: true)
        node.ret = pos
    }
    
    override func visit(node: NullLiteralE) {
        super.visit(node: node)
        print("return type: ", node.type)
        node.ret = NullC(type: getType(type: node.type))
    }
    
    override func visit(node: MethodAccessE) {
        //        super.visit(node: node)
        node.toAccess.accept(visitor: self)
        var t = node.toAccess.ret!.loadIfAddress(block: curBlock)
        if node.method.id == builtinSize {
            t = CastInst(val: t, toType: TypeIR.int.pointer, in: curBlock)
            let g = GEPInst(type: TypeIR.int.pointer, base: t, needZero: false, val: IntC.minusOne(), in: curBlock)
            node.ret = LoadInst(alloc: g, in: curBlock)
        } else {
            node.method.accept(visitor: self)
            node.ret = (node.method.ret! as! CallInst).inserted(operand: t)
        }
    }
    
    private func getMemberAccess(cls: ClassD, base: Value, for property: String) -> GEPInst? {
        var count = 0
        for pro in cls.properties {
            for (j, (name, _)) in pro.variable.enumerated() {
                if name == property {
                    return GEPInst(type: getType(type: pro.type).pointer,
                                   base: base,
                                   needZero: true,
                                   val: IntC(type: .int, value: count + j),
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
        let t = toSub.isAddress ? LoadInst(alloc: toSub, in: curBlock) : toSub
        let i = index.isAddress ? LoadInst(alloc: index, in: curBlock) : index
        node.ret = GEPInst(type: t.type, base: t, needZero: false, val: i, in: curBlock)
    }
    
    override func visit(node: FunctionCallE) {
        super.visit(node: node)
        var f: FunctionIR?
        var sym: Symbol?
        
        print(">>>", node.id)
        if Builtin.functions.keys.contains(node.id) {
            print("...builtin", node.id, node.arguments.joined() {"\($0.ret!.type)"})
            f = Builtin.functions[node.id]!
        } else {
            sym = node.scope.find(name: node.id)!
            f = sym!.subScope!.correspondingNode!.ret as? FunctionIR
        }
        
        var arg = [Value]()
        node.arguments.forEach{
            arg.append($0.ret!.isAddress ? LoadInst(alloc: $0.ret!, in: curBlock) : $0.ret!)
        }
        
        if sym != nil && sym!.belongsTo.scopeType == .CLASS {
            // handle new instances
            if sym!.belongsTo.scopeName == node.id {
                let size = ((sym!.belongsTo.correspondingNode as! ClassD).ret! as! Class).getSize
                let call = CallInst(function: Builtin.functions["malloc"]!,
                                    arguments: [IntC(type: .long, value: size)],
                                    in: curBlock)
                let cast = CastInst(val: call, toType: getType(type: node.id), in: curBlock)
                arg.insert(cast, at: 0)
                _ = CallInst(function: f!, arguments: arg, in: curBlock)
                node.ret = cast
                
                return
                
            } else if node.needThis {
                arg.insert(this, at: 0)
            }
        }
        
        node.ret = CallInst(function: f!, arguments: arg, in: curBlock)
    }
    
    private let uopMap: [UnaryOperator: InstIR.OP] = [.doubleAdd: .add, .doubleSub: .sub, .sub: .sub, .bitwise: .xor, .negation: .xor]
    
    override func visit(node: SuffixE) {
        super.visit(node: node)
        let exp = node.expression.ret!.loadIfAddress(block: curBlock)
        let inst = IntC(type: exp.type, value: 1)
        node.ret = BinaryInst(type: exp.type, operation: uopMap[node.op]!, lhs: exp, rhs: inst, in: curBlock)
        assign(lhs: node.expression.ret!, rhs: node.ret!, in: curBlock)
        node.ret = exp
    }
    
    override func visit(node: PrefixE) {
        super.visit(node: node)
        let exp = node.expression.ret!.loadIfAddress(block: curBlock)
        switch node.op {
        case .doubleAdd, .doubleSub:
            let inst = IntC(type: exp.type, value: 1)
            node.ret = BinaryInst(type: exp.type, operation: uopMap[node.op]!, lhs: exp, rhs: inst, in: curBlock)
            assign(lhs: node.expression.ret!, rhs: node.ret!, in: curBlock)
        case .sub:
            node.ret = BinaryInst(type: exp.type, operation: uopMap[node.op]!, lhs: IntC.zero(), rhs: exp, in: curBlock)
        case .bitwise:
            let inst = IntC(type: exp.type, value: 4294967295)
            node.ret = BinaryInst(type: exp.type, operation: uopMap[node.op]!, lhs: exp, rhs: inst, in: curBlock)
        case .negation:
            let inst = IntC(type: exp.type, value: 1)
            node.ret = BinaryInst(type: exp.type, operation: uopMap[node.op]!, lhs: exp, rhs: inst, in: curBlock)
        default:
            node.ret = exp
        }
    }
    
    private func newArray(type: TypeIR, num: Value) -> Value {
        let perSize = IntC(type: .int,
                           value: type.getBase.space)
        
        let size = BinaryInst(type: .int, operation: .mul, lhs: perSize, rhs: num, in: curBlock)
        let real = BinaryInst(type: .int, operation: .add, lhs: size, rhs: IntC.four(), in: curBlock)
        let cast = SExtInst(val: real, toType: .long, in: curBlock)
        
        let call = CallInst(function: Builtin.functions["malloc"]!,
                            arguments: [cast],
                            in: curBlock)
        
        let toint = CastInst(val: call, toType: TypeIR.int.pointer, in: curBlock)
        
        _ = StoreInst(alloc: toint, val: num, in: curBlock)
        
        let nbase = GEPInst(type: TypeIR.int.pointer, base: toint, needZero: false, val: IntC.one(), in: curBlock)
        return CastInst(val: nbase, toType: type, in: curBlock)
    }
    
    private func buildArray(node: NewE, idx: Int, arr: Value, type: TypeIR) {
        
        let v = AllocaInst(forType: .int, in: curBlock.inFunction.blocks[0], at: 0)
        _ = StoreInst(alloc: v, val: IntC.zero(), in: curBlock)
        let b = node.expressions[idx - 1].ret!.loadIfAddress(block: curBlock)
        let s = node.expressions[idx].ret!.loadIfAddress(block: curBlock)
        
        let judge = BlockIR(curfunc: curBlock.inFunction)
        let accept = BlockIR(curfunc: curBlock.inFunction)
        let merge = BlockIR(curfunc: curBlock.inFunction)
        
        BrInst(des: judge, in: curBlock)
        
        curBlock = judge
        let i = v.loadIfAddress(block: curBlock)
        let r = CompareInst(lhs: i, rhs: b, cmp: .slt, in: curBlock)
        BrInst(condition: r, accept: accept, reject: merge, in: curBlock)
        
        curBlock = accept
        let p = GEPInst(type: type.pointer, base: arr, needZero: false, val: i, in: curBlock)
        let narr = newArray(type: type, num: s)
        _ = StoreInst(alloc: p, val: narr, in: curBlock)
        
        if idx < node.expressions.count - 1 {
            buildArray(node: node, idx: idx + 1, arr: narr, type: type.getBase)
        }
        
        let j = BinaryInst(type: .int, operation: .add, lhs: i, rhs: IntC.one(), in: curBlock)
        _ = StoreInst(alloc: v, val: j, in: curBlock)
        BrInst(des: judge, in: curBlock)
        
        curBlock = merge
    }
    
    override func visit(node: NewE) {
        super.visit(node: node)
        // deal with the last non-zero dim
        let type = getType(type: node.type)
//        node.ret = newArray(type: type, num: )

        let arr = newArray(type: type, num: node.expressions[0].ret!.loadIfAddress(block: curBlock))
        
        if node.expressions.count > 1 {
            buildArray(node: node, idx: 1, arr: arr, type: type.getBase)
        }
        
        node.ret = arr
        
    }
    
    //    case add, sub, mul, div, mod, gt, lt, geq, leq, eq, neq, bitAnd, bitOr, bitXor, logAnd, logOr, lShift, rShift, assign
    private let bopMap: [BinaryOperator: InstIR.OP] = [.add: .add, .sub: .sub, .mul: .mul, .div: .sdiv, .mod: .srem, .bitAnd: .and, .bitOr: .or, .bitXor: .xor, .lShift: .shl, .rShift: .ashr, .logAnd: .and, .logOr: .or]
    private let cmpMap: [BinaryOperator: CompareInst.CMP] = [.eq: .eq, .neq: .ne, .lt: .slt, .leq: .sle, .gt: .sgt, .geq: .sge]
    
    override func visit(node: BinaryE) {
        if node.op == .logOr || node.op == .logAnd {
            node.lhs.accept(visitor: self)
            let lhs = node.lhs.ret!.loadIfAddress(block: curBlock)
            let result = AllocaInst(forType: IntT.bool, in: curBlock.inFunction.blocks[0], at: 0)
            let reject = BlockIR(curfunc: curBlock.inFunction)
            let merge = BlockIR(curfunc: curBlock.inFunction)
            _ = StoreInst(alloc: result, val: lhs, in: curBlock)
            _ = BrInst(condition: lhs,
                       accept: node.op == .logOr ? merge: reject,
                       reject: node.op == .logOr ? reject: merge, in: curBlock)
            
            curBlock = reject
            node.rhs.accept(visitor: self)
            let rhs = node.rhs.ret!.loadIfAddress(block: curBlock)
            _ = StoreInst(alloc: result, val: rhs, in: curBlock)
            _ = BrInst(des: merge, in: curBlock)
            
            curBlock = merge
            node.ret = result
        } else if node.op == .assign {
            super.visit(node: node)
            assign(lhs: node.lhs.ret!, rhs: node.rhs.ret!, in: curBlock)
        } else {
            super.visit(node: node)
            let lhs = node.lhs.ret!.loadIfAddress(block: curBlock)
            let rhs = node.rhs.ret!.loadIfAddress(block: curBlock)
            switch node.op {
            case .add:
                if node.lhs.type == int {
                    node.ret = BinaryInst(type: lhs.type, operation: bopMap[node.op]!, lhs: lhs, rhs: rhs, in: curBlock)
                } else {
                    node.ret = CallInst(function: Builtin.functions["_str_add"]!, in: curBlock)
                        .added(operand: lhs)
                        .added(operand: rhs)
                }
            case .sub, .mul, .div, .mod, .bitAnd, .bitOr, .bitXor, .lShift, .rShift:
                node.ret = BinaryInst(type: lhs.type, operation: bopMap[node.op]!, lhs: lhs, rhs: rhs, in: curBlock)
            case .eq, .neq, .lt, .gt, .leq, .geq:
                if node.lhs.type == int {
                    node.ret = CompareInst(lhs: lhs, rhs: rhs, cmp: cmpMap[node.op]!, in: curBlock)
                } else if node.lhs.type == string {
                    node.ret = CallInst(function: Builtin.functions["_str_\( cmpMap[node.op]!)"]!, in: curBlock)
                        .added(operand: lhs)
                        .added(operand: rhs)
                } else if node.rhs.type == null {
                    node.ret = CompareInst(lhs: lhs, rhs: rhs, cmp: cmpMap[node.op]!, in: curBlock)
                }
            case .logOr, .logAnd:
                print("log and/or", curBlock.inFunction.name, node.op, bopMap[node.op]!)
                node.ret = BinaryInst(type: lhs.type, operation: bopMap[node.op]!, lhs: lhs, rhs: rhs, in: curBlock)
            default:
                break
                //                node.ret = currentBlock.create(Value(type: Type()))
            }
        }
    }
    
}
