//
//  Register.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/4/4.
//

import Foundation

var allRegs = [Register]()
var debug = false

class Register: OperandRV, Hashable, Equatable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    static func == (lhs: Register, rhs: Register) -> Bool {
        lhs === rhs
    }
    
    let name: String
    override var description: String {
        if !debug {
            return color
        }
        return color + "<\(name)>"
    }
    
    override func resetConst() {
        if name == "zero" {
            con = 0
        } else {
            con = nil
        }
    }
    
    static let counter = Counter()
    init(name: String? = nil, color: String = "?") {
        self.name = name ?? ("tmp_" + Self.counter.tik())
        self.color = color
        super.init()
        allRegs.append(self)
        resetConst()
    }
    
    var defs = [InstRV]()
    var uses = [InstRV]()
    
    var itr = Set<Register>()
    var mov = Set<InstRV>()
    
    var deg: Int = -1
    var alias: Register?
    var color: String
    
    func clear() {
        itr.removeAll()
        mov.removeAll()
        deg = 0
    }
    
    var cost: Double {
        uses.reduce(0.0, {$0 + pow(10.0, Double($1.inBlock.loopDepth) + $1.inBlock.loopPartition / 5.0)})
        + defs.reduce(0.0, {$0 + pow(10.0, Double($1.inBlock.loopDepth) + $1.inBlock.loopPartition / 5.0)})
    }
    
}

class RV32 {
    
    static let callerSave = (0...6).map{"t\($0)"} + (0...7).map{"a\($0)"} + ["ra"]
    static let calleeSave = (0...11).map{"s\($0)"}
    static let normal = RV32.callerSave + RV32.calleeSave
    static let special = ["zero", "sp", "gp", "tp"]
    static let regs = Dictionary(uniqueKeysWithValues:
        (RV32.calleeSave + RV32.callerSave + RV32.special).map {($0, Register(name: $0, color: $0))}
    )
    static subscript(s: String) -> Register {regs[s]!}
    
}
