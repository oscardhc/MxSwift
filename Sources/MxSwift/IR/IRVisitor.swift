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
    func visit(v: BrInst)
    func visit(v: GEPInst)
    func visit(v: LoadInst)
    func visit(v: StoreInst)
    func visit(v: CallInst)
    func visit(v: AllocaInst)
    func visit(v: ReturnInst)
    func visit(v: BinaryInst)
    
}

let stdPrint = print

class IRNumberer: IRVisitor {
    
    func visit(v: Module) {
        v.functions.forEach {
            $0.accept(visitor: self)
        }
    }
    func visit(v: Function) {
        counter.reset()
        v.blocks.forEach {
            $0.initName()
            $0.accept(visitor: self)
        }
    }
    func visit(v: BasicBlock) {
        v.inst.forEach {
            $0.accept(visitor: self)
        }
    }
    func visit(v: BrInst) {v.initName()}
    func visit(v: GEPInst) {v.initName()}
    func visit(v: LoadInst) {v.initName()}
    func visit(v: StoreInst) {v.initName()}
    func visit(v: CallInst) {v.initName()}
    func visit(v: AllocaInst) {v.initName()}
    func visit(v: ReturnInst) {v.initName()}
    func visit(v: BinaryInst) {v.initName()}
    
}

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
        print(v.toPrint, "#0", "{")
        indent += 1
        v.blocks.forEach {
            indent -= 1
            print("\($0.basename):")
            indent += 1
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
    func visit(v: BrInst) {
        print(v.toPrint)
    }
    func visit(v: GEPInst) {
        print(v.toPrint)
    }
    func visit(v: LoadInst) {
        print(v.toPrint)
    }
    func visit(v: StoreInst) {
        print(v.toPrint)
    }
    func visit(v: CallInst) {
        print(v.toPrint)
    }
    func visit(v: AllocaInst) {
        print(v.toPrint)
    }
    func visit(v: ReturnInst) {
        print(v.toPrint)
    }
    func visit(v: BinaryInst) {
        print(v.toPrint)
    }
    
}
