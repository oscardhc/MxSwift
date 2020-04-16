//
//  Register.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/4/4.
//

import Foundation

var allRegs = [Register]()

class Register: OperandRV, Hashable, Equatable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    static func == (lhs: Register, rhs: Register) -> Bool {
        lhs === rhs
    }
    
    let name: String
    override var description: String {
//        RV32.regs.values.contains(self) ? color! : ("<\(name)>\(color ?? "~")")
        color ?? "<\(name)>"
    }
    
    static let counter = Counter()
    init(name: String? = nil, color: String? = nil) {
        self.name = name ?? ("tmp_" + Self.counter.tik())
        self.color = color
        super.init()
        allRegs.append(self)
    }
    
    var defs = [InstRV]()
    var uses = [InstRV]()
    
    var itr = Set<Register>()
    var mov = Set<InstRV>()
    
    var deg: Int = -1
    var alias: Register?
    var color: String?
    
    func clear() {
        itr.removeAll()
        mov.removeAll()
        deg = 0
    }
    
    var cost: Double {
        uses.reduce(0.0, {$0 + pow(10.0, Double($1.inBlock.loopDepth))})
        + defs.reduce(0.0, {$0 + pow(10.0, Double($1.inBlock.loopDepth))})
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
