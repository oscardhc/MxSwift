//
//  Inst.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/5.
//

import Foundation

enum IROP {
    case add
}

class Inst: User {
    
    let operation: IROP
    var currentBlock: BasicBlock?
    
    init(name: String, type: Type, operation: IROP) {
        self.operation = operation
        super.init(name: name, type: type)
    }
    
}

class UnaryInst: Inst {
    
}

class BinaryInst: Inst {
    
    init(name: String, type: Type, operation: IROP, lhs: Value, rhs: Value) {
        super.init(name: name, type: type, operation: operation)
        operands.append(lhs)
        operands.append(rhs)
    }
    
}
    

