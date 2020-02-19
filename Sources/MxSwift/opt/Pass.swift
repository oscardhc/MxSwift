//
//  Pass.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/16.
//

import Foundation

class FunctionPass: IRVisitor {
    
    final func visit(v: Module) {
        v.functions.forEach {
            if $0.blocks.count > 0 {
                $0.accept(visitor: self)
            }
        }
    }
    
    var resultString: String {"\(self)".fixLength(30) + " finished. "}
    
    func work(on v: Module) {
        visit(v: v)
        print(resultString)
    }
    
    func visit(v: Function) {}
    
    final func visit(v: Class) {}
    final func visit(v: GlobalVariable) {}
    final func visit(v: BasicBlock) {}
    final func visit(v: PhiInst) {}
    final func visit(v: SExtInst) {}
    final func visit(v: CastInst) {}
    final func visit(v: BrInst) {}
    final func visit(v: GEPInst) {}
    final func visit(v: LoadInst) {}
    final func visit(v: StoreInst) {}
    final func visit(v: CallInst) {}
    final func visit(v: AllocaInst) {}
    final func visit(v: ReturnInst) {}
    final func visit(v: BinaryInst) {}
    
}
