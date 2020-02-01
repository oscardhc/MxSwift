//
//  Symbol.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/1/30.
//

import Foundation

struct Symbol {
    
    var type: String!
    var subScope: Scope?
    
    init(_type: String, _subScope: Scope? = nil) {
        type = _type
        subScope = _subScope
    }
    
}
