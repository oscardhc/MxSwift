
import Foundation
import Antlr4
import Parser

func compile(useFileStream: Bool) throws {
    
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
    
    let builder = ASTBuilder()
    let listener = ErrorListener()
    
    preOperation = true
    let _t = try MxsParser(CommonTokenStream(MxsLexer(builtin))).declarations()
    _ = builder.visit(_t)
    
    preOperation = false
    
    let lexer: MxsLexer
    if useFileStream {
        let testName = "t2"
        let testNo = "1"
//        let sourceFilePath = "/Users/oscar/Documents/Classes/1920_Spring/Compiler/Compiler-2020/local-judge/testcase/sema/\(testName)-package/\(testName)-\(testNo).mx"
        let sourceFilePath = "/Users/oscar/Documents/Classes/1920_Spring/Compiler/Compiler-2020/local-judge/testcase/codegen/\(testName).mx"
        let input = try ANTLRFileStream(sourceFilePath, String.Encoding.utf8)
//        print(input.toString())
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
    
    let ir = IRBuilder()
    ir.visit(node: prog)
    
    TruncateTerminal().work(on: ir.module)
    MemToReg().work(on: ir.module)
    
    IRPrinter(filename: "/Users/oscar/Documents/Classes/1920_Spring/Compiler/tmp/out.ll").work(on: ir.module)
    
    DCElimination().work(on: ir.module)
    TruncateTerminal().work(on: ir.module)
    EmptyBlockRemover().work(on: ir.module)
    
    IRPrinter(filename: "/Users/oscar/Documents/Classes/1920_Spring/Compiler/tmp/out2.ll").work(on: ir.module)
    
    print("Compilation exited normally.")
    
}

do {
    try compile(useFileStream: true)
//    try compile(useFileStream: false)
} catch let e as CompilationError {
    e.show()
    exit(-1)
} catch let e {
    print("[Error] \(e)")
    exit(-1)
}
