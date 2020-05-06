
import Foundation
import Antlr4
import Parser

let testing = CommandLine.arguments.count > 1

public func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    if !testing {
        Swift.print(items.map{"\($0)"}.joined(separator: separator), terminator: terminator)
    }
}

func compile() throws {
    
//    print(welcomeText)
    let prog = try semantic(useFileStream: !testing)
    
    if testing && CommandLine.arguments[1] == "semantic" {
        return
    }
    
    let ir = IRBuilder()
    ir.visit(node: prog)
    DeadCleaner().work(on: ir.module)
    
    if error.message.count > 0 {
        throw error
    }
    
    if !testing {
        IRPrinter(filename: "/Users/oscar/Documents/Classes/1920_Spring/Compiler/tmp/out0.ll").print(on: ir.module)
    }
    MemToReg().work(on: ir.module)
        
    optimize(v: ir.module, timeLimit: Int(2e9), iterationLimit: 20)
    
    CESplit(removePhi: false).work(on: ir.module)
//    IRPrinter(filename: "/Users/oscar/Documents/Classes/1920_Spring/Compiler/tmp/out1.ll").print(on: ir.module)
//
//    optimize(v: ir.module, timeLimit: Int(3e9), iterationLimit: 5, noPhi: true)
//
//    MemToReg().work(on: ir.module)
//    optimize(v: ir.module, timeLimit: Int(3e9), iterationLimit: 4, noCopy: true)
    if !testing {
        IRPrinter(filename: "/Users/oscar/Documents/Classes/1920_Spring/Compiler/tmp/out2.ll").print(on: ir.module)
    } else {
        _ = IRPrinter().print(on: ir.module)
    }
    
    let asm = InstSelect()
    asm.work(on: ir.module)
    
    debug = true
    UseImmediate().work(on: asm.program)
    RAllocator().work(on: asm.program)
    _ = RVPrinter(filename: "/Users/oscar/Documents/Classes/1920_Spring/Compiler/tmp/after.s").work(on: asm.program)
    
    debug = false
    if !testing {
        _ = RVPrinter(filename: "/Users/oscar/Documents/Classes/1920_Spring/Compiler/tmp/test.s").work(on: asm.program)
    } else {
        Swift.print(RVPrinter().work(on: asm.program))
    }
    
}

func optimize(v: Module, timeLimit: Int, iterationLimit: Int, noPhi: Bool = false, noCopy: Bool = false) {
    let start = DispatchTime.now().uptimeNanoseconds
    var lastString = ""
    
    for iteration in 1...iterationLimit {
        print("iteration \(iteration):")
        
        GLocalizer()        .work(on: v)
        MemToReg()          .work(on: v)
        
        SCCPropagation()    .work(on: v)
        if !noCopy {
            CSElimination()     .work(on: v)
            GVNumberer()        .work(on: v)
        }
        DCElimination()     .work(on: v)
        CFGSimplifier(noPhi).work(on: v)
        
        let aa = PTAnalysis()
        aa.work(on: v)
        if !noCopy {
            LSElimination(aa)   .work(on: v)
        }
        DCElimination(aa)   .work(on: v)
        LICHoister(aa)      .work(on: v)
        
        DCElimination()     .work(on: v)
        CFGSimplifier(noPhi).work(on: v)
        
        if !noPhi && !noCopy {
            Inliner().work(on: v)
        }
        
        let curString = IRPrinter().print(on: v)
        if lastString != curString {
            lastString = curString
        } else {
            break
        }
        
        if DispatchTime.now().uptimeNanoseconds - start > timeLimit {
            break
        }
    }
}

func semantic(useFileStream: Bool) throws -> Program {
    let builtin = ANTLRInputStream(
        """
    void putchar(int x) {}

    int 很想听 () {}
    void 输出 (int n) {}

    void print(string str) {}
    void println(string str) {}
    void printInt(int n) {}
    void printlnInt(int n) {}
    string getString() {}
    int getInt() {}
    string toString(int i) {}
    class s {
        int length() {}
        string substring(int left, int right) {}
        int parseInt() {}
        int ord(int pos) {}
    };
    """
    )
    let builder = ASTBuilder(), listener = ErrorListener()
    
    preOperation = true
    let _t = try MxsParser(CommonTokenStream(MxsLexer(builtin))).declarations()
    _ = builder.visit(_t)
    preOperation = false
    
    let lexer: MxsLexer
    if useFileStream {
        let sourceFilePath = "/Users/oscar/Documents/Classes/1920_Spring/Compiler/tmp/in.mx"
        let input = try ANTLRFileStream(sourceFilePath, String.Encoding.utf8)
        lexer = MxsLexer(input)
    } else {
        var source = ""
        while let str = readLine() {
            source += str
            source += "\n"
        }
        let input = ANTLRInputStream(source)
        lexer = MxsLexer(input)
    }
    lexer.addErrorListener(listener)
    
    let parser = try MxsParser(CommonTokenStream(lexer))
    parser.addErrorListener(listener)
    
    let tree = try parser.declarations()
    if listener.count > 0 {
        throw error
    }
    
    let prog = builder.visit(tree) as! Program
    if error.message.count > 0 {
        throw error
    }
    
    SemanticChecker().visit(node: prog)
    if error.message.count > 0 {
        throw error
    }
    
    return prog
}

do {
    try compile()
} catch let e as CompilationError {
    e.show()
    exit(-1)
} catch let e {
    print("[Error] \(e)")
    exit(-1)
}
