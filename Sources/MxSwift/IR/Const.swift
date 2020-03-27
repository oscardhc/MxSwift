//
//  Const.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/6.
//

import Foundation

class Const: User {
    
}

class IntC: Const {
    
    static func zero() -> IntC {
        IntC(type: .int, value: 0)
    }
    static func one() -> IntC {
        IntC(type: .int, value: 1)
    }
    static func four() -> IntC {
        IntC(type: .int, value: 4)
    }
    static func minusOne() -> IntC {
        IntC(type: .int, value: -1)
    }
    
    var value: Int
    init(type: Type, value: Int) {
        self.value = value
        super.init(name: "", type: type)
        
        ccpInfo = CCPInfo(type: .int, int: value)
        
    }
    override func initName() {}
    override var name: String {"\(value)"}
    override var description: String {"\(type) \(value)"}
}
class VoidC: Const {
    init() {
        super.init(name: "", type: .void)
    }
    override func initName() {}
    override var name: String {"void"}
    override var description: String {"void"}
}
class NullC: Const {
    init(type: Type = Type()) {
        super.init(name: "", type: type)
    }
    override func initName() {}
    override var name: String {"null"}
//    override var description: String {"\(type) null"}
}
class StringC: Const {
    var value: String
    var length = 0
    init(value: String) {
        self.value = ""
        var flag = false
        for char in value {
            if flag == true {
                switch char {
                case "n":
                    self.value += "0A"
                case "\"":
                    self.value += "22"
                default:
                    self.value += "5C"
                }
                flag = false
            } else if char == "\\" {
                flag = true
                self.value += String(char)
                length += 1
            } else if char != "\"" {
                self.value += String(char)
                length += 1
            }
        }
        self.value += "\\00"
        length += 1
        super.init(name: "", type: ArrayT(type: .char, count: length))
    }
    override var description: String {
        "\(type) c\"\(value)\""
    }
}

class Global: Const {
    
    var currentModule: Module
    override var prefix: String {return "@"}
    
    init(name: String, type: Type, module: Module) {
        self.currentModule = module
        super.init(name: name, type: type)
    }
    
}

class Function: Global {
    
    var blocks = List<BasicBlock>()
    var attribute: String
    
    override func accept(visitor: IRVisitor) {visitor.visit(v: self)}
    
    override var toPrint: String {
        "\(blocks.count > 0 ? "define" : "declare") \(type) \(name)(\(operands.joined {blocks.count > 0 ? "\($0)" : "\($0.type)"})) \(attribute) \(blocks.count > 0 ? "{" : "")"
    }
    override var description: String {return "\(type) \(name)"}
    
    init(name: String, type: Type, module: Module, attr: String = "") {
        self.attribute = attr
        super.init(name: name, type: type, module: module)
        module.add(self)
    }
    
    func append(_ b: BasicBlock) -> List<BasicBlock>.Node {
        blocks.append(b)
    }
    
    var size: (Int, Int) {
        var instCount = 0, blockCount = 0
        for b in blocks {
            instCount += b.insts.count
        }
        return (instCount, blockCount)
    }
    
}

class Class: Global {
    
    var subNames = [String]()
    var subTypes = [Type]()
    func added(subType: (String, Type)) -> Self {
        self.subNames.append(subType.0)
        self.subTypes.append(subType.1)
        return self
    }
    
    override init(name: String, type: Type, module: Module) {
        super.init(name: name, type: type, module: module)
        _ = module.add(self)
    }
    
    var getSize: Int {
        var size = 0.0
        subTypes.forEach {
            let space = Double($0.space)
            size = ceil(size / space) * space + space
        }
        return Int(size)
    }
    
    override var toPrint: String {"\(type) = type {\(subTypes.joined())}"}
    override func accept(visitor: IRVisitor) {visitor.visit(v: self)}
    
}

class GlobalVariable: Global {
    
    var value: Const
    var const: Bool
    
    init(name: String, value: Const, module: Module, isConst: Bool = true) {
        self.value = value
        self.const = isConst
        super.init(name: name, type: value.type.pointer, module: module)
        _ = module.add(self)
    }
    
    override var toPrint: String {"\(name) = \(const ? "constant" : "global") \(value), align \(value.type.space)"}
    override func accept(visitor: IRVisitor) {visitor.visit(v: self)}
    
}
