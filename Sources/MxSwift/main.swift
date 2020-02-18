
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
        let testName = "t3"
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
    
    let tokens = CommonTokenStream(lexer)
    let parser = try MxsParser(tokens)
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
    
    IRNumberer().visit(v: ir.module)
    let pr = IRPrinter()
    pr.visit(v: ir.module)
    
//    try handle.close()
    
    TruncateTerminal().visit(v: ir.module)
    MemToReg().visit(v: ir.module)
    
    IRNumberer().visit(v: ir.module)
    let pr2 = IRPrinter()
    pr2.visit(v: ir.module)
//    print(pr2.str)
    
    pr.flushToFile(name: "/Users/oscar/Documents/Classes/1920_Spring/Compiler/tmp/out.ll")
    pr2.flushToFile(name: "/Users/oscar/Documents/Classes/1920_Spring/Compiler/tmp/out2.ll")
    
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
