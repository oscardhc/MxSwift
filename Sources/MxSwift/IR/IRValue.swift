//
//  Value.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/5.
//

import Foundation

class IRValue {
    
    var users = [IRUser]()
    
}

class IRUser: IRValue {
    
    var operands = [IRValue]()
    
}
