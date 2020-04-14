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
        let handle = FileHandle(forWritingAtPath: name)!
        handle.truncateFile(atOffset: 0)
        handle.write(str.data(using: .utf8)!)
    }
    
    func print(on v: Assmebly) -> String {
        
        for f in v.functions where f.blocks.count > 0 {
            pr(f, ":")
            for b in f.blocks {
                pr(b, ":")
                for i in b.insts {
                    pr(" ", i)
                }
            }
            pr("")
        }
        for g in v.globals {
            pr(g.toPrint)
        }
        if file != "" {
            flushToFile(name: file)
        }
        return str
        
    }
    
}
