
import Foundation
import Antlr4
import Parser

func compile() throws -> Void {
    
//    let sourceFilePath = FileManager.default.currentDirectoryPath + "/program.cpp"
    let sourceFilePath = "/Users/oscar/Documents/Classes/1920_Spring/Compiler/Compiler-2020/dataset/sema/scope-package/scope-6.mx"
    
//    let data = FileManager.default.contents(atPath: "/Users/oscar/Documents/Classes/1920_Spring/Compiler/program.cpp")
//    let data = try Data(contentsOf: URL(string: sourceFilePath)!)
    
    let builtin = ANTLRInputStream(
"""
void print(string str) {}
void println(string str) {}
void printInt(int n) {}
void printlnInt(int n) {}
string getString() {}
int getInt() {}
string toString(int i) {}
"""
    )
    
    let builder = ASTBuilder()
    
    let _t = try MxsParser(CommonTokenStream(MxsLexer(builtin))).declarations()
    _ = builder.visit(_t)
    
    let input = try ANTLRFileStream(sourceFilePath, String.Encoding.utf8)
    print(input.toString())
    let lexer = MxsLexer(input)
    
    let tokens = CommonTokenStream(lexer)
    let parser = try MxsParser(tokens)
    let tree = try parser.declarations()

//    let walker = ParseTreeWalker()
    
//    let builder = SymbolTableBuilder(_error: error)
//    try walker.walk(builder, tree)
    
    
    let prog = builder.visit(tree) as! Program
    
    
    if error.message.count > 0 {
        throw error
    }
    SemanticChecker().visit(node: prog)
    if error.message.count > 0 {
        throw error
    }
    
    ASTPrinter().visit(node: prog)
    
//    print(builder.current.scopeName, ":", builder.current.table)
    print("Compilation exited normally.")
    
}

do {
    try compile()
} catch let e as CompilationError {
    error.show()
} catch let e {
    print("[Error] \(e)")
}
