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
    var controlBlock = [(BasicBlock, BasicBlock)]() // (breakTo, continueTo)
    
    var globalInit = true
    var globalFunc: Function!
    
    let pointerSize = 8
    
    private func getType(type: String) -> Type {
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
        static var functions = [String: Function]()
        static func addFunc(name: String, f: (() -> Function)) {
            functions[name] = f()
        }
    }
    
    override init() {
        super.init()
        Builtin.addFunc(name: "malloc") {
            Function(name: "malloc", type: .string,
                     module: module)
                .added(operand: Value(name: "", type: .long))
        }
        Builtin.addFunc(name: "print") {
            Function(name: "print", type: .void, module: module)
                .added(operand: Value(name: "", type: .string))
        }
        Builtin.addFunc(name: "println") {
            Function(name: "println", type: .void, module: module)
                .added(operand: Value(name: "", type: .string))
        }
        Builtin.addFunc(name: "printInt") {
            Function(name: "printInt", type: .void, module: module)
                .added(operand: Value(name: "", type: .int))
        }
        Builtin.addFunc(name: "printlnInt") {
            Function(name: "printlnInt", type: .void, module: module)
                .added(operand: Value(name: "", type: .int))
        }
        Builtin.addFunc(name: "toString") {
            Function(name: "toString", type: .string, module: module)
                .added(operand: Value(name: "", type: .int))
        }
        Builtin.addFunc(name: "getInt") {
            Function(name: "getInt", type: .int, module: module)
        }
        Builtin.addFunc(name: "size") {
            Function(name: "size", type: .int, module: module)
                .added(operand: Value(name: "", type: Type.int.pointer))
        }
        Builtin.addFunc(name: "getString") {
            Function(name: "getString", type: .string, module: module)
        }
        Builtin.addFunc(name: "parseInt") {
            Function(name: "parseInt", type: .int, module: module)
                .added(operand: Value(name: "", type: .string))
        }
        addStringBOP(name: "add", type: .string)
        addStringBOP(name: "eq", type: .bool)
        addStringBOP(name: "neq", type: .bool)
        addStringBOP(name: "slt", type: .bool)
        addStringBOP(name: "sgt", type: .bool)
        addStringBOP(name: "sle", type: .bool)
        addStringBOP(name: "sge", type: .bool)
    }
    
    private func addStringBOP(name: String, type: Type) {
        Builtin.addFunc(name: "_str_" + name) {
            Function(name: "_str_" + name, type: type, module: module)
                .added(operand: Value(name: "", type: .string))
                .added(operand: Value(name: "", type: .string))
        }
    }
    
    override func visit(node: Program) {
        
        // step 1: make all functions "callable" by adding a empty Function node
        for _d in node.declarations {
            if let f = _d as? FunctionD {
                f.ret = Function(name: f.id, type: getType(type: f.type), module: module)
            }
            if let c = _d as? ClassD {
                c.ret = Class(name: c.id, type: ClassT(name: c.id), module: module)
                c.initial.forEach {
                    $0.ret = Function(name: $0.id, type: getType(type: void), module: module)
                }
                c.methods.forEach {
                    $0.ret = Function(name: $0.id, type: getType(type: $0.type), module: module)
                }
            }
        }
        
        // step 2: global variable declarations
        globalFunc = Function(name: "global_init", type: getType(type: void), module: module)
        curBlock = BasicBlock(curfunc: globalFunc)
        for i in node.declarations where i is VariableD {
            i.accept(visitor: self)
        }
        globalInit = false
        
        // step 3: others
        for i in node.declarations where !(i is VariableD) {
            i.accept(visitor: self)
        }
        
        // return for global init
        ReturnInst(name: "", val: VoidC(), in: globalFunc.blocks[0])
    }
    
    private func assign(lhs: Value, rhs: Value, in block: BasicBlock) {
        if rhs is NullC {
            rhs.type = lhs.type.getBase
        }
        StoreInst(name: "", alloc: lhs,
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
                    if e is Const {
                        sym.value = GlobalVariable(name: $0.0, value: e as! Const, module: module)
                    } else {
                        var const: Const {
                            switch node.type {
                            case int:
                                return IntC(name: "", type: type, value: 0)
                            default:
                                return NullC(type: type)
                            }
                        }
                        sym.value = GlobalVariable(name: $0.0, value: const, module: module, isConst: false)
                        if e != nil {
                            assign(lhs: sym.value!, rhs: e!, in: curBlock)
                        }
                    }
                } else {
                    let ret = AllocaInst(name: $0.0 + "_" + sym.belongsTo.scopeName, forType: type, in: curBlock)
                    sym.value = ret
                    if let e = $0.1 {
                        _ = assign(lhs: ret, rhs: e.ret!, in: curBlock)
                    }
                }
            }
        }
    }
    
    override func visit(node: FunctionD) {
        let ret = node.ret as! Function
        curBlock = BasicBlock(curfunc: ret)
        
        if node.id == "main" {
            CallInst(name: "", function: globalFunc, in: curBlock)
        }
        
        if curClass != nil {
            _ = ret.added(operand: Value(name: "this", type: curClass!.type.pointer))
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
        
        if node.hasReturn == false {
            ReturnInst(name: "", val: VoidC(), in: curBlock)
        }
        
        ret.checkForEmptyBlock()
        
        curBlock = nil
    }
    
    override func visit(node: ClassD) {
        //        super.visit(node: node)
        curClass = node.ret! as! Class
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
        let accept = BasicBlock(curfunc: curBlock.inFunction)
        let reject = BasicBlock(curfunc: curBlock.inFunction)
        let merge = BasicBlock(curfunc: curBlock.inFunction)
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
        
        let judge = BasicBlock(curfunc: curBlock.inFunction)
        let accept = BasicBlock(curfunc: curBlock.inFunction)
        let merge = BasicBlock(curfunc: curBlock.inFunction)
        BrInst(name: "", des: judge, in: curBlock)
        curBlock = judge
        node.condition.accept(visitor: self)
        let cond = node.condition.ret!.isAddress ? LoadInst(name: "", alloc: node.condition.ret!, in: curBlock) : node.condition.ret!
        BrInst(name: "", condition: cond, accept: accept, reject: merge, in: curBlock)
        
        curBlock = accept
        controlBlock.append((merge, judge))
        node.accept!.accept(visitor: self)
        BrInst(name: "", des: judge, in: curBlock)
        _ = controlBlock.popLast()
        
        curBlock = merge
    }
    
    override func visit(node: ForS) {
        //        super.visit(node: node)
        
        node.initial?.accept(visitor: self)
        
        let accept = BasicBlock(curfunc: curBlock.inFunction)
        let merge = BasicBlock(curfunc: curBlock.inFunction)
        
        if let c = node.condition {
            let judge = BasicBlock(curfunc: curBlock.inFunction)
            BrInst(name: "", des: judge, in: curBlock)
            curBlock = judge
            c.accept(visitor: self)
            let cond = c.ret!.isAddress ? LoadInst(name: "", alloc: c.ret!, in: curBlock) : c.ret!
            BrInst(name: "", condition: cond, accept: accept, reject: merge, in: curBlock)
            
            curBlock = accept
            controlBlock.append((merge, judge))
            node.accept?.accept(visitor: self)
            node.increment?.accept(visitor: self)
            BrInst(name: "", des: judge, in: curBlock)
            _ = controlBlock.popLast()
        } else {
            let cond = IntC(name: "", type: .bool, value: 1)
            BrInst(name: "", condition: cond, accept: accept, reject: merge, in: curBlock)
            
            curBlock = accept
            controlBlock.append((merge, accept))
            node.accept?.accept(visitor: self)
            node.increment?.accept(visitor: self)
            BrInst(name: "", des: accept, in: curBlock)
            _ = controlBlock.popLast()
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
        BrInst(name: "", des: controlBlock.last!.0, in: curBlock)
    }
    
    override func visit(node: ContinueS) {
        super.visit(node: node)
        BrInst(name: "", des: controlBlock.last!.1, in: curBlock)
    }
    
    override func visit(node: ExpressionS) {
        super.visit(node: node)
        node.ret = node.expression.ret
    }
    
    private var this: Value {
        (curBlock?.inFunction.operands[0])! // first parameter: this
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
        node.ret = IntC(name: "never", type: .bool, value: node.value ? 1 : 0)
    }
    
    override func visit(node: IntLiteralE) {
        super.visit(node: node)
        node.ret = IntC(name: "never", type: .int, value: node.value)
    }
    
    override func visit(node: StringLiteralE) {
        super.visit(node: node)
        let cons = StringC(value: node.value)
        let globS = GlobalVariable(name: "s.", value: cons, module: module)
        let globP = GlobalVariable(name: "p.", value: NullC(type: .string), module: module, isConst: false)
        let pos = GEPInst(name: "", type: .string, base: globS, needZero: true, val: IntC.zero(), in: globalFunc.blocks[0])
        StoreInst(name: "", alloc: globP, val: pos, in: globalFunc.blocks[0])
        node.ret = globP
    }
    
    override func visit(node: NullLiteralE) {
        super.visit(node: node)
        node.ret = NullC()
    }
    
    override func visit(node: MethodAccessE) {
        //        super.visit(node: node)
        node.toAccess.accept(visitor: self)
        let t = node.toAccess.ret!.loadIfAddress(block: curBlock)
        node.method.accept(visitor: self)
        if node.method.id == "size" {
            _ = CastInst(name: "", val: t, toType: Type.int.pointer, in: curBlock)
        }
        node.ret = (node.method.ret! as! CallInst).inserted(operand: t)
    }
    
    private func getMemberAccess(cls: ClassD, base: Value, for property: String) -> GEPInst? {
        var count = 0
        for pro in cls.properties {
            for (j, (name, _)) in pro.variable.enumerated() {
                if name == property {
                    return GEPInst(name: "",
                                   type: getType(type: pro.type).pointer,
                                   base: base,
                                   needZero: true,
                                   val: IntC(name: "", type: .int, value: count + j),
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
        if Builtin.functions.keys.contains(node.id) {
            f = Builtin.functions[node.id]!
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
                                    function: Builtin.functions["malloc"]!,
                                    arguments: [IntC(name: "", type: .long, value: size)],
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
    
    private let uopMap: [UnaryOperator: Inst.OP] = [.doubleAdd: .add, .doubleSub: .sub, .sub: .sub, .bitwise: .xor, .negation: .xor]
    
    override func visit(node: SuffixE) {
        super.visit(node: node)
        let exp = node.expression.ret!.loadIfAddress(block: curBlock)
        let inst = IntC(name: "", type: exp.type, value: 1)
        node.ret = BinaryInst(name: "", type: exp.type, operation: uopMap[node.op]!, lhs: exp, rhs: inst, in: curBlock)
        assign(lhs: node.expression.ret!, rhs: node.ret!, in: curBlock)
        node.ret = exp
    }
    
    override func visit(node: PrefixE) {
        super.visit(node: node)
        let exp = node.expression.ret!.loadIfAddress(block: curBlock)
        switch node.op {
        case .doubleAdd, .doubleSub:
            let inst = IntC(name: "", type: exp.type, value: 1)
            node.ret = BinaryInst(name: "", type: exp.type, operation: uopMap[node.op]!, lhs: exp, rhs: inst, in: curBlock)
            assign(lhs: node.expression.ret!, rhs: node.ret!, in: curBlock)
        case .sub:
            node.ret = BinaryInst(name: "", type: exp.type, operation: uopMap[node.op]!, lhs: IntC.zero(), rhs: exp, in: curBlock)
        case .bitwise, .negation:
            let inst = IntC(name: "", type: exp.type, value: -1)
            node.ret = BinaryInst(name: "", type: exp.type, operation: uopMap[node.op]!, lhs: exp, rhs: inst, in: curBlock)
        default:
            node.ret = exp
        }
    }
    
    override func visit(node: NewE) {
        super.visit(node: node)
        // deal with the last non-zero dim
        let type = getType(type: node.type)
        
        let perSize = IntC(name: "",
                           type: .int,
                           value: node.empty > 0 ? pointerSize : type.getBase.space)
        let num = node.expressions.last!.ret!.loadIfAddress(block: curBlock)
        
        let size = BinaryInst(name: "", type: .int, operation: .mul, lhs: perSize, rhs: num, in: curBlock)
        let real = BinaryInst(name: "", type: .int, operation: .add, lhs: size, rhs: IntC.four(), in: curBlock)
        let cast = SExtInst(name: "", val: real, toType: .long, in: curBlock)
        
        let call = CallInst(name: "",
                            function: Builtin.functions["malloc"]!,
                            arguments: [cast],
                            in: curBlock)
        
        let toint = CastInst(name: "", val: call, toType: Type.int.pointer, in: curBlock)
        
        _ = StoreInst(name: "", alloc: toint, val: num, in: curBlock)
        
        let nbase = GEPInst(name: "", type: Type.int.pointer, base: toint, needZero: false, val: IntC.one(), in: curBlock)
        
        node.ret = CastInst(name: "", val: nbase, toType: type, in: curBlock)
    }
    
    //    case add, sub, mul, div, mod, gt, lt, geq, leq, eq, neq, bitAnd, bitOr, bitXor, logAnd, logOr, lShift, rShift, assign
    private let bopMap: [BinaryOperator: Inst.OP] = [.add: .add, .sub: .sub, .mul: .mul, .div: .sdiv, .mod: .srem, .bitAnd: .and, .bitOr: .or, .bitXor: .xor, .lShift: .shl, .rShift: .ashr, .logAnd: .and, .logOr: .or]
    private let cmpMap: [BinaryOperator: CompareInst.CMP] = [.eq: .eq, .neq: .ne, .lt: .slt, .leq: .sle, .gt: .sgt, .geq: .sge]
    
    override func visit(node: BinaryE) {
        super.visit(node: node)
        if node.op == .assign {
            assign(lhs: node.lhs.ret!, rhs: node.rhs.ret!, in: curBlock)
        } else {
            let lhs = node.lhs.ret!.loadIfAddress(block: curBlock)
            let rhs = node.rhs.ret!.loadIfAddress(block: curBlock)
            switch node.op {
            case .add:
                if node.lhs.type == int {
                    node.ret = BinaryInst(name: "", type: lhs.type, operation: bopMap[node.op]!, lhs: lhs, rhs: rhs, in: curBlock)
                } else {
                    node.ret = CallInst(name: "", function: Builtin.functions["_str_add"]!, in: curBlock)
                        .added(operand: lhs)
                        .added(operand: rhs)
                }
            case .sub, .mul, .div, .mod, .bitAnd, .bitOr, .bitXor, .lShift, .rShift:
                node.ret = BinaryInst(name: "", type: lhs.type, operation: bopMap[node.op]!, lhs: lhs, rhs: rhs, in: curBlock)
            case .eq, .neq, .lt, .gt, .leq, .geq:
                if node.lhs.type == int {
                    node.ret = CompareInst(name: "", operation: .icmp, lhs: lhs, rhs: rhs, cmp: cmpMap[node.op]!, in: curBlock)
                } else {
                    node.ret = CallInst(name: "", function: Builtin.functions["_str_\( cmpMap[node.op]!)"]!, in: curBlock)
                        .added(operand: lhs)
                        .added(operand: rhs)
                }
            case .logOr, .logAnd:
                node.ret = BinaryInst(name: "", type: lhs.type, operation: bopMap[node.op]!, lhs: lhs, rhs: rhs, in: curBlock)
            default:
                break
                //                node.ret = currentBlock.create(Value(name: "", type: Type()))
            }
        }
    }
    
}
