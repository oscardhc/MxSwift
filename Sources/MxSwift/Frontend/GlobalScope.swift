//
//  GlobalScope.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/1/30.
//

import Foundation

class GlobalScope: Scope {
    
    override func find(name: String) -> Symbol? {
        return table[name]
    }
    
}
