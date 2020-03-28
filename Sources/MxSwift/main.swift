
import Foundation
import Antlr4
import Parser

func compile(useFileStream: Bool) throws {
    
    let start = DispatchTime.now().uptimeNanoseconds
    let timeLimit = Int(30 * 1e9), iterateLimit = 15
    var iteration = 0
    
    print(welcomeText)
    
    let builtin = ANTLRInputStream(
"""
void putchar(int x) {}

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
    
    if CommandLine.arguments.count > 1 && CommandLine.arguments[1] == "semantic" {
        return
    }
    
    let ir = IRBuilder()
    ir.visit(node: prog)
    DeadCleaner().work(on: ir.module)
    
    if error.message.count > 0 {
        throw error
    }
    
    var lastString = ""
    
    IRPrinter(filename: "/Users/oscar/Documents/Classes/1920_Spring/Compiler/tmp/out0.ll").print(on: ir.module)
    MemToReg().work(on: ir.module)
    lastString = IRPrinter(filename: "/Users/oscar/Documents/Classes/1920_Spring/Compiler/tmp/out1.ll").print(on: ir.module)
    
    while DispatchTime.now().uptimeNanoseconds - start < timeLimit && iteration < iterateLimit {
        
        print("iteration \(iteration):")
        iteration += 1
        
        SCCPropagation()    .work(on: ir.module)
        CSElimination()     .work(on: ir.module)
        GVNumberer()        .work(on: ir.module)

        DCElimination()     .work(on: ir.module)
        CFGSimplifier()     .work(on: ir.module)
        
        let aa = PTAnalysis()
        aa.work(on: ir.module)
        LSElimination(aa)   .work(on: ir.module)
        DCElimination(aa)   .work(on: ir.module)
        
        DCElimination()     .work(on: ir.module)
        CFGSimplifier()     .work(on: ir.module)
        
        Inliner()           .work(on: ir.module)
        
        let curString = IRPrinter().print(on: ir.module)
        if lastString != curString {
            lastString = curString
        } else {
            break
        }

    }
    
    IRPrinter(filename: "/Users/oscar/Documents/Classes/1920_Spring/Compiler/tmp/out2.ll").print(on: ir.module)
    
    print("Compilation exited normally in \((DispatchTime.now().uptimeNanoseconds - start) / 1000000) ms with \(iteration) iteration(s).")
}

do {
    if CommandLine.arguments.count > 1 {
        try compile(useFileStream: false)
    } else {
        try compile(useFileStream: true)
    }
} catch let e as CompilationError {
    e.show()
    exit(-1)
} catch let e {
    print("[Error] \(e)")
    exit(-1)
}
