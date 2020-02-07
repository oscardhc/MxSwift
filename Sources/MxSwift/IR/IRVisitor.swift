//
//  IRVisitor.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/6.
//

import Foundation

protocol IRVisitor {
    
    func visit(v: Module)
    func visit(v: Function)
    func visit(v: BasicBlock)
    func visit(v: AllocaInst)
    func visit(v: ReturnInst)
    func visit(v: BinaryInst)
    
}

let stdPrint = print

class IRPrinter: IRVisitor {
    
    var str = ""
    var indent = 0
    
    func print(_ items: Any...) {
        for _ in 0..<indent {
            str += "\t"
        }
        for it in items {
            str += "\(it)"
            str += " "
        }
        str += "\n"
    }
    
    func visit(v: Module) {
        v.functions.forEach {
            $0.accept(visitor: self)
        }
    }
    
    func visit(v: Function) {
        print("define", v, "#0", "{")
        indent += 1
        v.blocks.forEach {
            $0.accept(visitor: self)
        }
        indent -= 1
        print("}")
    }
    
    func visit(v: BasicBlock) {
        v.inst.forEach {
            $0.accept(visitor: self)
        }
    }
    
    func visit(v: AllocaInst) {
        print(v)
    }
    
    func visit(v: ReturnInst) {
        print(v)
    }
    
    func visit(v: BinaryInst) {
        print(v)
    }
    
    
    
}
