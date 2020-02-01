
import Foundation
import Antlr4
import Parser

func compile() throws -> Void {
    
    let sourceFilePath = FileManager.default.currentDirectoryPath + "/program.cpp"
    
//    let sourceFilePath = "/Users/oscar/Documents/Classes/1920_Spring/Compiler/program.cpp"
//    let data = FileManager.default.contents(atPath: "/Users/oscar/Documents/Classes/1920_Spring/Compiler/program.cpp")
//    let data = try Data(contentsOf: URL(string: sourceFilePath)!)
    
    let error = CompilationError()
    
    let input = try ANTLRFileStream(sourceFilePath, String.Encoding.utf8)
    print(input.toString())
    let lexer = MxsLexer(input)
    
    let tokens = CommonTokenStream(lexer)
    let parser = try MxsParser(tokens)
    let tree = try parser.declarations()

//    let walker = ParseTreeWalker()
    
//    let builder = SymbolTableBuilder(_error: error)
//    try walker.walk(builder, tree)
    
    let builder = ASTBuilder()
    let prog = builder.visit(tree) as! Program
    print(prog)
    print(prog.declarations)
    
    ASTPrinter().visit(node: prog)
    
    if !error.message.isEmpty {
        throw error
    }
    
//    let checker = StaticTypeChecker(_error: error, _scopeMap: builder.scopeMap)
//    try walker.walk(checker, tree)
    if !error.message.isEmpty {
        throw error
    }
    
//    print(builder.current.scopeName, ":", builder.current.table)
    print("Compilation exited normally.")
    
}

do {
    try compile()
} catch let e as CompilationError {
    print(e.message)
} catch let e {
    print("[Error] \(e)")
}
