//
//  Utils.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/1/31.
//

import Foundation
import Antlr4
import Parser

class HashableObject {
    var hashString: String {
        return "\(ObjectIdentifier(self).hashValue)"
    }
    var thisType: String {
        return "\(type(of: self))"
    }
}

enum UnaryOperator {
    case doubleAdd, doubleSub, add, sub, bitwise, negation
}

enum BinaryOperator {
    case add, sub, mul, div, mod, gt, lt, geq, leq, eq, neq, bitAnd, bitOr, bitXor, logAnd, logOr, lShift, rShift, assign
}

let bool = "bool", int = "int", string = "string", void = "void", null = "null"
let builtinTypes: [String] = [bool, int, string, void]
let builtinSize = "size"

var preOperation: Bool = false

extension Array where Element == String {
    static func === (lhs: Array<String>, rhs: Array<String>) -> Bool {
        if lhs.count != rhs.count {
            return false
        }
        for i in 0..<lhs.count {
            if lhs[i] !== rhs[i] {
                return false
            }
        }
        return true
    }
    static func !== (lhs: Array<String>, rhs: Array<String>) -> Bool {
        return !(lhs === rhs)
    }
}

extension String {
    
    func fixLength(_ l: Int) -> String {
        self + String([Character](repeating: " ", count: l - count))
    }
    
    static func === (lhs: String, rhs: String) -> Bool {
//        print("=== CMP", lhs, rhs, !lhs.isBuiltinType(), rhs == null, (rhs == null && !lhs.isBuiltinType()))
        return lhs == rhs || (rhs == null && !lhs.isBuiltinType())
    }
    static func !== (lhs: String, rhs: String) -> Bool {
        return !(lhs === rhs)
    }
}

extension Int {
    func getUnaryOp() -> UnaryOperator {
        switch self {
        case MxsLexer.SelfAdd: return .doubleAdd
        case MxsLexer.SelfSub: return .doubleSub
        case MxsLexer.Add: return .add
        case MxsLexer.Sub: return .sub
        case MxsLexer.Bitwise: return .bitwise
        default: return .negation
        }
    }
    func getBinaryOp() -> BinaryOperator {
        switch self {
        case MxsLexer.Mul: return .mul
        case MxsLexer.Div: return .div
        case MxsLexer.Add: return .add
        case MxsLexer.Sub: return .sub
        case MxsLexer.Mod: return .mod
        case MxsLexer.Greater: return .gt
        case MxsLexer.Less: return .lt
        case MxsLexer.GreaterEq: return .geq
        case MxsLexer.LessEq: return .leq
        case MxsLexer.Equal: return .eq
        case MxsLexer.Inequal: return .neq
        case MxsLexer.BitAnd: return .bitAnd
        case MxsLexer.BitOr: return .bitOr
        case MxsLexer.BitXor: return .bitXor
        case MxsLexer.LogicAnd: return .logAnd
        case MxsLexer.LogicOr: return .logOr
        case MxsLexer.LeftShift: return .lShift
        case MxsLexer.RightShift: return .rShift
        default: return .assign
        }
    }
}

extension String {
    func dropArray() -> String {
        let idx = index(endIndex, offsetBy: -2)
        return String(self[..<idx])
    }
    func dropAllArray() -> String {
        var ret = String(self)
        while ret.hasSuffix("[]") {
            ret = ret.dropArray()
        }
        return ret;
    }
    func isBuiltinType() -> Bool {
        return builtinTypes.contains(self)
    }
}
