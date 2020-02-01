//
//  Utils.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/1/31.
//

import Foundation

//class Utils {
//
//    static func dropArray(str: String) -> String {
//        let idx = str.index(str.endIndex, offsetBy: -2)
//        return String(str[..<idx])
//    }
//
//}

extension String {
    func dropArray() -> String {
        let idx = index(endIndex, offsetBy: -2)
        return String(self[..<idx])
    }
}
