//
//  IRVisitor.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/6.
//

import Foundation

protocol IRVisitor {
    
    var resultString: String {get}
    
    func work(on v: Module)
    func visit(v: Module)
    func visit(v: Function)
    func visit(v: Class)
    func visit(v: GlobalVariable)
    func visit(v: BasicBlock)
    func visit(v: PhiInst)
    func visit(v: SExtInst)
    func visit(v: CastInst)
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
    
    var resultString: String {"\(self) finished. "}
    
    func work(on v: Module) {
        visit(v: v)
    }
    func visit(v: Module) {
        v.functions.forEach {
            $0.accept(visitor: self)
        }
    }
    func visit(v: Function) {
        instNamingCounter.reset()
        v.operands.forEach {$0.initName()}
        v.blocks.forEach {
            $0.initName()
            $0.accept(visitor: self)
        }
    }
    func visit(v: Class) {
        v.operands.forEach {$0.initName()}
    }
    func visit(v: GlobalVariable) {
        
    }
    func visit(v: BasicBlock) {
        v.insts.forEach {
            $0.accept(visitor: self)
        }
    }
    func visit(v: PhiInst) {v.initName()}
    func visit(v: SExtInst) {v.initName()}
    func visit(v: CastInst) {v.initName()}
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
    var resultString: String {"\(self) finished. "}
    var file: String
    
    init(filename: String = "") {
        file = filename
    }
    func work(on v: Module) {
        IRNumberer().work(on: v)
        visit(v: v)
        if file != "" {
            flushToFile(name: file)
        }
    }
    func flushToFile(name: String) {
        let handle = FileHandle(forWritingAtPath: name)!
        handle.truncateFile(atOffset: 0)
        handle.write(str.data(using: .utf8)!)
    }
    func print(_ items: Any..., end: String = "\n") {
        for _ in 0..<indent {
            str += "\t"
        }
        for it in items {
            str += "\(it)"
            str += " "
        }
        str += end
    }
    func visit(v: Module) {
        v.classes.forEach {
            $0.accept(visitor: self)
        }
        v.globalVar.forEach {
            $0.accept(visitor: self)
        }
        v.functions.forEach {
            $0.accept(visitor: self)
        }
    }
    func visit(v: Function) {
        print(v.toPrint)
        if v.blocks.count > 0 {
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
    }
    func visit(v: Class) {
        print(v.toPrint)
    }
    func visit(v: GlobalVariable) {
        print(v.toPrint)
    }
    func visit(v: BasicBlock) {
        v.insts.forEach {
            $0.accept(visitor: self)
        }
    }
    func visit(v: PhiInst) {
        print(v.toPrint)
    }
    func visit(v: SExtInst) {
        print(v.toPrint)
    }
    func visit(v: CastInst) {
        print(v.toPrint)
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
