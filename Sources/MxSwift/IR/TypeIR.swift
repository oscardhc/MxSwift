//
//  Type.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/5.
//

import Foundation

class TypeIR: CustomStringConvertible {
    init() {}
    var description: String {"???"}
    var bit: Int {0}
    var space: Int {Int(ceil(Double(bit) / 8))}
    var withAlign: String {description + ", align \(space)"}
    var getBase: TypeIR {(self as! PointerT).baseType}
    
    var pointer: PointerT {
        PointerT(base: self)
    }
    
    static let void = VoidT()
    static let bool = IntT(.bool)
    static let char = IntT(.char)
    static let int = IntT(.int)
    static let long = IntT(.long)
    static let string = PointerT(base: char)
    
    static func == (lhs: TypeIR, rhs: TypeIR) -> Bool {
        return lhs.description == rhs.description && lhs.description != "???"
    }
    
}

class LabelT: TypeIR {
    override var description: String {"label"}
}

class FunctionT: TypeIR {
    var retType: TypeIR
    var parType: [TypeIR]
    override var description: String {"\(retType)"}
    
    init(ret: TypeIR, par: [TypeIR]) {
        self.retType = ret
        self.parType = par
        super.init()
    }
}

class VoidT: TypeIR {
//    static let void = IRVoid()
    override var description: String {"void"}
}

class IntT: TypeIR {
    enum BitWidth {
        case bool, char, int, long
    }
    
    var width: BitWidth
    override var bit: Int {
        switch width {
        case .bool:
            return 1
        case .char:
            return 8
        case .int:
            return 32
        default:
            return 64
        }
    }
    override var description: String {return "i\(bit)"}
    override var space: Int {return width == .int ? 4 : 1}
    
    init(_ width: BitWidth) {
        self.width = width
        super.init()
    }
}

class PointerT: TypeIR {
    
    var baseType: TypeIR
    
    init(base: TypeIR) {
        self.baseType = base
        super.init()
    }
    override var bit: Int {32}
    override var description: String {"\(baseType)*"}
    
}

class ClassT: TypeIR {
//    let properties: [Type]
//    override var bit: Int {
//        var r = 0
//        self.properties.forEach {r += $0.bit}
//        return r
//    }
//    init(prop: [Type] = []) {
//        self.properties = prop
//        super.init()
//    }
    var name: String
    init(name: String) {
        self.name = name
        super.init()
    }
    override var description: String {"%\(name)"}
}

class ArrayT: TypeIR {
    var elementType: TypeIR
    var count: Int
    
    init(type: TypeIR, count: Int) {
        self.elementType = type
        self.count = count
        super.init()
    }
    
    override var bit: Int {elementType.bit}
    override var description: String {"[\(count) x \(elementType)]"}
}
