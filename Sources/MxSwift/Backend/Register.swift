//
//  Register.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/4/4.
//

import Foundation

class Register: OperandRV {
    
    let name: String
    override var description: String {name}
    
    init(name: String) {
        self.name = name
    }
    
}

class VReg: Register {
    override init(name: String = "") {
        super.init(name: name)
    }
}

class RV32 {
    
    static let callerSave = ["ra"] + (0...6).map{"t\($0)"} + (0...7).map{"a\($0)"}
    static let calleeSave = (0...11).map{"s\($0)"}
    static let special = ["zero", "sp", "gp", "tp"]
    static let regs = Dictionary(uniqueKeysWithValues:
        (RV32.calleeSave + RV32.callerSave + RV32.special).map {($0, VReg(name: $0))}
    )
    static subscript(s: String) -> VReg {regs[s]!}
    
}
