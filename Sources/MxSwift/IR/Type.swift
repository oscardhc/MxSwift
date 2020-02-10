//
//  Type.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/5.
//

import Foundation

class Type: CustomStringConvertible {
    init() {}
    var description: String {"???"}
    var align: Int {return 1}
    var bit: Int {0}
    var withAlign: String {return description + ", align \(align)"}
}

class LabelType: Type {
    override var description: String {"label"}
}

class FunctionT: Type {
    var retType: Type
    var parType: [Type]
    override var description: String {"\(retType)"}
    
    init(ret: Type, par: [Type]) {
        self.retType = ret
        self.parType = par
        super.init()
    }
}

class VoidT: Type {
    override var description: String {"void"}
}

class IntT: Type {
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
    override var align: Int {return width == .int ? 4 : 1}
    
    init(_ width: BitWidth) {
        self.width = width
        super.init()
    }
}

class PointerT: Type {
    
    var baseType: Type
    
    init(base: Type) {
        self.baseType = base
        super.init()
    }
    override var description: String {"\(baseType)*"}
    override var align: Int {8}
    
}

class ClassT: Type {
    let properties: [Type]
    override var bit: Int {
        var r = 0
        self.properties.forEach {r += $0.bit}
        return r
    }
    
    init(prop: [Type] = []) {
        self.properties = prop
        super.init()
    }
}

class ArrayT: Type {
    var elementType: Type
    var count: Int
    
    init(type: Type, count: Int) {
        self.elementType = type
        self.count = count
        super.init()
    }
}
