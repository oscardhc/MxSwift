//
//  Register.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/4/4.
//

import Foundation

class Register: CustomStringConvertible, RegisterConvertable, OperandRV {
    
    let name: String
    var description: String {name}
    var reg: Register {self}
    
    init(name: String) {
        self.name = name
    }
    
}

class VirtRegister: Register {
    
    override init(name: String = "") {
        super.init(name: name)
    }
    
}

class RV32 {
    
    static let regs = Dictionary(uniqueKeysWithValues:
        (["zero", "ra", "sp", "gp", "tp"] + (0...6).map{"t\($0)"} + (0...7).map{"a\($0)"} + (0...11).map{"s\($0)"}).map {($0, Register(name: $0))}
    )
    static subscript(s: String) -> Register {
        regs[s]!
    }
    
}
