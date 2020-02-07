//
//  Symbol.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/1/30.
//

import Foundation

struct Symbol {
    
    var type: String!
    var belongsTo: Scope!
    var subScope: Scope?
    var value: Value?
    
    init(_type: String, _bel: Scope, _subScope: Scope? = nil) {
        type = _type
        belongsTo = _bel
        subScope = _subScope
    }
    
}
