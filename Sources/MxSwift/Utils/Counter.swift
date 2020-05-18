//
//  Counter.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/3/1.
//

import Foundation

class Counter {
    
    private var count = [String: Int]()
    
    func tikInt(_ id: String = "") -> Int {
        if count[id] == nil {
            count[id] = -1
        }
        count[id]! += 1
        return count[id]!
    }
    func tik(_ id: String = "") -> String {"\(tikInt(id))"}
    func reset() {
        count = [:]
    }
    
}
