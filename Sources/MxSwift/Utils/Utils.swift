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

class RefList<P> {
    var list = [P]()
}
class RefSet<P: Hashable> {
    private(set) var _s = Set<P>()
    
    func contains(_ v: P) -> Bool {
        _s.contains(v)
    }
    func insert(_ v: P) {
        _s.insert(v)
    }
    func popFirst() -> P? {
        _s.popFirst()
    }
    func formUnion(rhs: RefSet<P>) {
        _s.formUnion(rhs._s)
    }
}
class RefDict<P: Hashable, Q> {
    private(set) var _s = [P: Q]()
    
    subscript(p: P) -> Q? {
        get {
            _s[p]
        }
        set(q) {
            _s[p] = q
        }
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
let builtinSize = "_size"

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

let welcomeText =
"""
                                           .............  ........
                                     .. . ..~8MMDNMMNNMMMMMMMMNMMO:. ..
                                 . . +MDMMMDD8O88O8OOO8OOO888OO888MMMM,..
                             ... ,MMMDO888O8ONMOMDM8MOOO88888888888OZNMM. ..
                            .. MMD8O888OO8888ONMOMMNZ8888888888ONMMM7?$MM..   ..  ....
                           ..=MOO888888888888OND=7+=MOO8OO8MMMMD?ZMMMMMMMMMMNMMNNMMMMI~,... ... .
                         . .+M8888888888888888OOMMMNONMMMM$I?8MMMMO,.,MN::,,,,,,,,,.,=?MMNMMNMM? ...
                         ..D888888OO88O88O8OO8NMMMMMI==+$MNMMM?,,,,,,,,,$Z,,,,,,,,,,,,,,,,,?+??8MMM.
                  .  .... DMNI77MMMNMNNMMMOI====:7MNMMMM$.,,,,,,,,,,,,,,,,.,,,,,,,,,,,,,,=++?++OMN .
                ....7MNMN::,,+MMMMMMMMMMMMMMMMMNMM?.,M.,~:,,,,,,,,,,,,,,,,,=M.,,,,,,,,,,+?+?MMM8.
             . ,MMDM,,,,,,,,,,,,,,.,,~.,,.,,,,,,,,,,,+M,,M,,,,,,,,,,,,,,,,,.~M,,,,,,,,+?++=8MM  .
       ... .8NND.:,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,M:,M,,,,,,,,,,,,,,,,,,,~M~,,,,,+?+?+MNM..
   .....ONN7.,,,,,,,,,,,.,,,,,,,,,,,,,,II,,,,,,,,,,,,=M,:?,,,,,,,,.,,,,,,,,..,,M8.,:=++$MM...      .
  ...7DM$?+,,,,,,,,,,,,,M,,,,,,,,,,,,,,:N,,,,,,,,,,,,N,=$,,,,,,,,,7M,,,...,. .,.MM?++++?NM.. .     .
 ..DMM++++?+?:,,,,,,,,,,M,,..,,,,,,,,,,,M,,,,,,,,,,,,DM.,   .. ...:M,,,,,,,. ..,~MD+NMN8....       .
..MM++?7MM++++++?++~,,,N8, ..., .... ...$N:,,,,,,,,,,,,,,,,,,,,,,,:M,,,,.,,,,,. ,OMMM . .
.. ~I~ ..MM$?7MMZ++?+?+M,, ..,,,,,,,,,,,,M7,,,,,,,,,,,,,,,,,,,,,O.MM,.,8MM:.,,,.,,$M+ .
       . . ?+=, MNNNMN$M,...,,,,,,,,,,,,,.M:,.,,,,,,,,,,,,,,,,MMMMMI7MMM+MMZ,,,,,,,MM..
       .   ..  .   ...MM,.,,,,N.,,,,,,,,.:+MMDMO,,,,,,,,,,,,,,ZN77=NM?=:NM+M,,,,,,,,MM.
                     .MZ.,,,,:NM,NM,,,,MM,:,MIMDMNM+,.,,,,:,,IMM7M$Z?+,,.,.M,,MM?N,:IM...
                   . NM?,,,,,,,IM+M?DNDNMMZ$7DMM:,:++?I$?=,,,7NMMMMMMMNNMM,M,,,MMM=,.NM~.
                   ..MM,,,,,,,,,,IMMM=+?==ZMNMMMN$.,,,,.M,,,.,MIIII?MN...IMM:7NM~MM,,,MM,.
                   .$MM,,,,,,,,,,.M$:,,MMMMMN7ON$.,,,,,,M,,,,$MI==+IOM....MM?+=MMMN,,,?M: ..
                  ..DMM,,,,,,,,,,,ZM~MMM8M8I?II?M7..,,,,M,,,,,M?IIIINM...MDM?,,,MMM=,,,8M .
                  ..MMM,,,,,,,,,,,:MMM...MM?I==IIM.,,,,,,M,,,,,$NMDM..7I.,,M?,,MN,~M~:,+MD.
                 . ZMMN:,,,,,,,,,,,MMM....DM?I??N.,,,,,,,,,,,,,,,,,,,:MM.M.M?,,,,,,,,,,,MM.
                . .MMNM,,,,,,,,,,,,MM,NM~,,.,~,.,,,,,,,,,,,,,,,,,,,,,MM.Z.:M+,,,,,,,,,,,IM, .
                 . M8M$,,,,,,,,,,,,,MM,O.,.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,MM+,,,,,,,,,,,,MM .
                 .,MIMM,,,,,,,,,,,,,MMMM:D.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,MM+,,,,,,,,,,,,~M:..
                ..NN:M=,,,,,,,,,,,,,.MM,.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,NMM+,,,,,,,,,,,,~M8.
                 .MM.M7,,,,,,,,,,,,,,DM~,,,,,,,,,,,,,,,,,~,,,,,,,,,,,,,,NMMN?,,,,,,,,,,,,,MM .
                ..MM,MM,,,,,,,,,,,,,,,MM7,,,,,,,,,,,,,,,,,,,,,,,,,,,,,=MMMM++,,,,,,,,,,,,,MM.
                ..MM,MM,,,,,,,,,,,,,,,ZMMM,,,,,,,,,,,,,,,,,,,,,,,,,,~NMMMMM++,,,,,,,,,,,,,IM.
                ..MM,MM,,,,,,,,,,,,,,,+MMMMMM7..,,,,,,,,,,,,,,,,,,+MMMMMMMM?:,,,,,,,,,,,,,MM..
                ..NM,MM,,,,,,,,,,,,,,,?IMMMMMMMMM$.,,:,,,,,,,,:,MMMMMMMMMM++,,,,,,,,,,,,,,NM,
                 ..MMMM,,,,,,,,,,,,,,,:+MMMMMMMMMMMMMNNMMO7?8NMMMMMMMMMMMN+,,,,,,,,,,,,,,,MM.
                 ...MMM,,,,,,,,,,,,,,,.++MMMMMMMMMDMO?++78MMMNMZ+=++MMMMM+,,,,,,,,,,,,,,,,MM
                     .M,,,,,,,,,,,,,,,,+++MMMMMMM=+=+++==++++++++++7MMMM=,,,,,,,,,,,,,,,,,M8.
                    ..MM,,,,,,,,,,,,,,,,++?MMMMMMMMI7I?==++++++I777IMMM,,,,,,,,,,,,,,,,,,ZM ....
                     .8M,,,,,,,,,,,,,,,,+++IMMMMMMMI777777++++=II?==MN,,,,,.,,,,,,,,,,,,,M+:. ....
                    ..~MD,,,,,,,,,,,,,,,,?+?+MMM$MMI777I=++++++=?7MM,,,,~MM,,,,,,,,,,,,,7+,:,.?MMM .
                    ...MM,,,,,,,,,,,,,,,,,+++?NM+IMMM++++++++77IMMMMMMMMMNM,,,,,,,,,,,,NMM,,,,,,::MM
                   ...MNMZ,,,,,,,,,,,,,,,,,,++??MM=MM=++=+++++++=MMO=ZZZMM,,,,,,,,,,,,MMM:,,,,ZMMO:N
                ..  MM?:MM.,,,:,,,,,,,,,,,,,.,,:.7NM+==MMD=MO=MM+++++ZZNM.,,,,,,,,,,:MMMM~,,,,,MMM=8
               ..MNM,,,,,MM:.:MO,,,,,,,,,,,,,8MNMMMMM+++++=I+=+=++++=MM.,,,,,,,:.,IMMNMM?+?=,,,,,,MM
          .. 7NNM,,,,,,,=?MM$,,NMM,,,,,,,,,,,.,,7NM8=+++==MNMMMN=+++=MNMDNMMMMNMNM777IM=MM=+++?=,,,.
         .MMMMMDMMMZ:,,:+++INM:,ZMZNNNDMMMMMDMNMZNOM7+++=M$DZD=MM++++M$OM77IM77777777MM++MM+???=,,?D
       .. . ....DM,:,,,++?+++=MMMMI77I7III7I7MI7IDM8M?+++MM?DDZM~=+=OM$ZM77IM77777I77M=MM+MMI++:MMM.
"""
