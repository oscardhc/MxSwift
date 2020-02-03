//
//  ErrorListener.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/3.
//

import Foundation
import Antlr4

class ErrorListener: ANTLRErrorListener {

    var count = 0

    func syntaxError<T>(_ recognizer: Recognizer<T>, _ offendingSymbol: AnyObject?, _ line: Int, _ charPositionInLine: Int, _ msg: String, _ e: AnyObject?) where T : ATNSimulator {
        count += 1
    }

    func reportAmbiguity(_ recognizer: Parser, _ dfa: DFA, _ startIndex: Int, _ stopIndex: Int, _ exact: Bool, _ ambigAlts: BitSet, _ configs: ATNConfigSet) {
//        count += 1
    }

    func reportAttemptingFullContext(_ recognizer: Parser, _ dfa: DFA, _ startIndex: Int, _ stopIndex: Int, _ conflictingAlts: BitSet?, _ configs: ATNConfigSet) {
//        count += 1
    }

    func reportContextSensitivity(_ recognizer: Parser, _ dfa: DFA, _ startIndex: Int, _ stopIndex: Int, _ prediction: Int, _ configs: ATNConfigSet) {
//        count += 1
    }

}
