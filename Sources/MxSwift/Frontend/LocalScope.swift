//
//  LocalScope.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/1/30.
//

import Foundation

class LocalScope: Scope {
    
    var father: Scope!
    
    init(_father: Scope) {
        father = _father;
    }
    
    override func find(name: String) -> Symbol? {
        let res = table[name]
        if res != nil {
            return res!
        } else {
            return father.find(name: name);
        }
    }
    
}
