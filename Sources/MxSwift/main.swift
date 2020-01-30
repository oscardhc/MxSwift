
import Foundation
import Antlr4
import Parser


do {
//    let sourceFilePath = FileManager.default.currentDirectoryPath + "/program.cpp"
    let sourceFilePath = "/Users/oscar/Documents/Classes/1920_Spring/Compiler/program.cpp"
//    let data = FileManager.default.contents(atPath: "/Users/oscar/Documents/Classes/1920_Spring/Compiler/program.cpp")
//    let data = try Data(contentsOf: URL(string: sourceFilePath)!)
    let input = try ANTLRFileStream(sourceFilePath, String.Encoding.utf8)
    let lexer = MxsLexer(input)
    let tokens = CommonTokenStream(lexer)
    let parser = try MxsParser(tokens)
    let tree = try parser.declarations()

    let walker = ParseTreeWalker()
    let listener = ASTListener()
    try walker.walk(listener, tree)
    print("done")
} catch {
    print("Error \(error)")
}
