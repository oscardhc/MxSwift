//
//  Type.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/5.
//

import Foundation

class Type: CustomStringConvertible {
    
    init() {
    }
    var description: String {return "???"}
    
}

class LabelType: Type {
    
}

class FunctionT: Type {
    
    var retType: Type
    var parType: [Type]
    
//    override var description: String {return super.description + "<\(parType) -> \(retType)>"}
    override var description: String {return "\(retType)"}
    
    init(ret: Type, par: [Type]) {
        self.retType = ret
        self.parType = par
        super.init()
    }
    
}

class IntT: Type {
    
    enum BitWidth {
        case bool, char, int
    }
    
    var width: BitWidth
    var bit: Int {
        switch width {
        case .bool:
            return 1
        case .char:
            return 8
        case .int:
            return 32
        }
    }
    override var description: String {return "i\(bit)"}
    
    init(width: BitWidth) {
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
    override var description: String {return "\(baseType)*"}
    
}

class ClassT: Type {
    
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
