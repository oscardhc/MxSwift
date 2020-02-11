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
    var align: Int {1}
    var bit: Int {0}
    var withAlign: String {description + ", align \(align)"}
    var getBase: Type {(self as! IRPointer).baseType}
}

class IRLabel: Type {
    override var description: String {"label"}
}

class IRFunction: Type {
    var retType: Type
    var parType: [Type]
    override var description: String {"\(retType)"}
    
    init(ret: Type, par: [Type]) {
        self.retType = ret
        self.parType = par
        super.init()
    }
}

class IRVoid: Type {
    override var description: String {"void"}
}

class IRInt: Type {
    enum BitWidth {
        case bool, char, int, long
    }
    
    static let bool = IRInt(.bool)
    static let char = IRInt(.char)
    static let int = IRInt(.int)
    static let long = IRInt(.long)
    
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
    
    private init(_ width: BitWidth) {
        self.width = width
        super.init()
    }
}

class IRPointer: Type {
    
    var baseType: Type
    
    init(base: Type) {
        self.baseType = base
        super.init()
    }
    override var description: String {"\(baseType)*"}
    override var align: Int {8}
    
}

class IRClass: Type {
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
}

class IRArray: Type {
    var elementType: Type
    var count: Int
    
    init(type: Type, count: Int) {
        self.elementType = type
        self.count = count
        super.init()
    }
}
