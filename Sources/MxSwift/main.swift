
import Foundation
import Antlr4
import Parser

class ErrorListener: ANTLRErrorListener {

    var count = 0

    func syntaxError<T>(_ recognizer: Recognizer<T>, _ offendingSymbol: AnyObject?, _ line: Int, _ charPositionInLine: Int, _ msg: String, _ e: AnyObject?) where T : ATNSimulator {
        count += 1
    }

    func reportAmbiguity(_ recognizer: Parser, _ dfa: DFA, _ startIndex: Int, _ stopIndex: Int, _ exact: Bool, _ ambigAlts: BitSet, _ configs: ATNConfigSet) {
//        count += 1
    }

    func reportAttemptingFullContext(_ recognizer: Parser, _ dfa: DFA, _ startIndex: Int, _ stopIndex: Int, _ conflictingAlts: BitSet?, _ configs: ATNConfigSet) {
//        count += 1
    }

    func reportContextSensitivity(_ recognizer: Parser, _ dfa: DFA, _ startIndex: Int, _ stopIndex: Int, _ prediction: Int, _ configs: ATNConfigSet) {
//        count += 1
    }

}

func compile() throws {
    
//    let sourceFilePath = FileManager.default.currentDirectoryPath + "/program.cpp"
    let testName = "expression"
    let testNo = "1"
    let sourceFilePath = "/Users/oscar/Documents/Classes/1920_Spring/Compiler/Compiler-2020/dataset/sema/\(testName)-package/\(testName)-\(testNo).mx"
    
    let builtin = ANTLRInputStream(
"""
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
    
    preOperation = true
    let _t = try MxsParser(CommonTokenStream(MxsLexer(builtin))).declarations()
    _ = builder.visit(_t)
    
    preOperation = false
    
    let input = try ANTLRFileStream(sourceFilePath, String.Encoding.utf8)
    print(input.toString())
    
    let listener = ErrorListener()
    
    let lexer = MxsLexer(input)
//    lexer.removeErrorListeners()
    lexer.addErrorListener(listener)
    
    let tokens = CommonTokenStream(lexer)
    let parser = try MxsParser(tokens)
//    parser.removeErrorListeners()
    parser.addErrorListener(listener)
    
//    parser.setErrorHandler(BailErrorStrategy())
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
    
    ASTPrinter().visit(node: prog)
    
//    print(builder.current.scopeName, ":", builder.current.table)
    print("Compilation exited normally.")
    
}

do {
    try compile()
} catch let e as CompilationError {
    e.show()
} catch let e {
    print("[Error] \(e)")
}
