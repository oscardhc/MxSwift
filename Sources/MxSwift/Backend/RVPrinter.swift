//
//  RVPrinter.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/4/13.
//

import Foundation

class RVPrinter {
    
    var str = ""
    var file: String
    
    init(filename: String = "") {
        file = filename
    }
    
    func pr(_ ar: CustomStringConvertible...) {
        for it in ar {
            str += "\(it) "
        }
        str += "\n"
    }
    func flushToFile(name: String) {
        try! str.write(toFile: name, atomically: true, encoding: .utf8)
    }
    
    
    func work(on v: Assmebly) -> String {
        
        pr("  .text")
        for f in v.functions where f.blocks.count > 0 {
            pr("  .globl", f)
            pr("\(f):")
            
            f.initPred()
            var arrangement = [f.blocks.first!]
            for _ in 1..<f.blocks.count {
//                print(arrangement)
                arrangement.append(
                    arrangement.last!.succs.filter{!arrangement.contains($0)}.first ?? f.blocks.filter{!arrangement.contains($0)}.first!
                )
            }
            for (idx, b) in arrangement.enumerated() {
                pr("\(b):")
                for i in b.insts.dropLast() {
                    if i.op == .mv && i.dst!.color == (i[0] as! Register).color {
                        continue
                    }
                    pr(" ", i)
                }
                pr(" ", b.insts.last!.printAsLast(nextBlock:
                    idx == arrangement.count - 1 ? nil: arrangement[idx + 1]
                ))
            }
            
            pr("")
        }
        pr("")
        pr("  .bss")
        for g in v.globals where !(g is GlobalStr) {
            pr(g.toPrint)
        }
        pr("")
        pr("  .rodata")
        for g in v.globals where g is GlobalStr {
            pr(g.toPrint)
        }
        if file != "" {
            flushToFile(name: file)
        }
        return str
        
    }
    
}
