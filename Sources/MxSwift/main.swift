
import Foundation
import Antlr4
import Parser

func compile(useFileStream: Bool) throws {
    
    let welcome =
"""
                                           .............  ........
                                     .. . ..~8MMDNMMNNMMMMMMMMNMMO:. ..
                                 . . +MDMMMDD8O88O8OOO8OOO888OO888MMMM,..
                             ... ,MMMDO888O8ONMOMDM8MOOO88888888888OZNMM. ..
                            .. MMD8O888OO8888ONMOMMNZ8888888888ONMMM7?$MM..   ..  ....
                           ..=MOO888888888888OND=7+=MOO8OO8MMMMD?ZMMMMMMMMMMNMMNNMMMMI~,... ... .
                         . .+M8888888888888888OOMMMNONMMMM$I?8MMMMO,.,MN::,,,,,,,,,.,=?MMNMMNMM? ...
                         ..D888888OO88O88O8OO8NMMMMMI==+$MNMMM?,,,,,,,,,$Z,,,,,,,,,,,,,,,,,?+??8MMM.
                  .  .... DMNI77MMMNMNNMMMOI====:7MNMMMM$.,,,,,,,,,,,,,,,,.,,,,,,,,,,,,,,=++?++OMN .
                ....7MNMN::,,+MMMMMMMMMMMMMMMMMNMM?.,M.,~:,,,,,,,,,,,,,,,,,=M.,,,,,,,,,,+?+?MMM8.
             . ,MMDM,,,,,,,,,,,,,,.,,~.,,.,,,,,,,,,,,+M,,M,,,,,,,,,,,,,,,,,.~M,,,,,,,,+?++=8MM  .
       ... .8NND.:,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,M:,M,,,,,,,,,,,,,,,,,,,~M~,,,,,+?+?+MNM..
   .....ONN7.,,,,,,,,,,,.,,,,,,,,,,,,,,II,,,,,,,,,,,,=M,:?,,,,,,,,.,,,,,,,,..,,M8.,:=++$MM...      .
  ...7DM$?+,,,,,,,,,,,,,M,,,,,,,,,,,,,,:N,,,,,,,,,,,,N,=$,,,,,,,,,7M,,,...,. .,.MM?++++?NM.. .     .
 ..DMM++++?+?:,,,,,,,,,,M,,..,,,,,,,,,,,M,,,,,,,,,,,,DM.,   .. ...:M,,,,,,,. ..,~MD+NMN8....       .
..MM++?7MM++++++?++~,,,N8, ..., .... ...$N:,,,,,,,,,,,,,,,,,,,,,,,:M,,,,.,,,,,. ,OMMM . .
.. ~I~ ..MM$?7MMZ++?+?+M,, ..,,,,,,,,,,,,M7,,,,,,,,,,,,,,,,,,,,,O.MM,.,8MM:.,,,.,,$M+ .
       . . ?+=, MNNNMN$M,...,,,,,,,,,,,,,.M:,.,,,,,,,,,,,,,,,,MMMMMI7MMM+MMZ,,,,,,,MM..
       .   ..  .   ...MM,.,,,,N.,,,,,,,,.:+MMDMO,,,,,,,,,,,,,,ZN77=NM?=:NM+M,,,,,,,,MM.
                     .MZ.,,,,:NM,NM,,,,MM,:,MIMDMNM+,.,,,,:,,IMM7M$Z?+,,.,.M,,MM?N,:IM...
                   . NM?,,,,,,,IM+M?DNDNMMZ$7DMM:,:++?I$?=,,,7NMMMMMMMNNMM,M,,,MMM=,.NM~.
                   ..MM,,,,,,,,,,IMMM=+?==ZMNMMMN$.,,,,.M,,,.,MIIII?MN...IMM:7NM~MM,,,MM,.
                   .$MM,,,,,,,,,,.M$:,,MMMMMN7ON$.,,,,,,M,,,,$MI==+IOM....MM?+=MMMN,,,?M: ..
                  ..DMM,,,,,,,,,,,ZM~MMM8M8I?II?M7..,,,,M,,,,,M?IIIINM...MDM?,,,MMM=,,,8M .
                  ..MMM,,,,,,,,,,,:MMM...MM?I==IIM.,,,,,,M,,,,,$NMDM..7I.,,M?,,MN,~M~:,+MD.
                 . ZMMN:,,,,,,,,,,,MMM....DM?I??N.,,,,,,,,,,,,,,,,,,,:MM.M.M?,,,,,,,,,,,MM.
                . .MMNM,,,,,,,,,,,,MM,NM~,,.,~,.,,,,,,,,,,,,,,,,,,,,,MM.Z.:M+,,,,,,,,,,,IM, .
                 . M8M$,,,,,,,,,,,,,MM,O.,.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,MM+,,,,,,,,,,,,MM .
                 .,MIMM,,,,,,,,,,,,,MMMM:D.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,MM+,,,,,,,,,,,,~M:..
                ..NN:M=,,,,,,,,,,,,,.MM,.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,NMM+,,,,,,,,,,,,~M8.
                 .MM.M7,,,,,,,,,,,,,,DM~,,,,,,,,,,,,,,,,,~,,,,,,,,,,,,,,NMMN?,,,,,,,,,,,,,MM .
                ..MM,MM,,,,,,,,,,,,,,,MM7,,,,,,,,,,,,,,,,,,,,,,,,,,,,,=MMMM++,,,,,,,,,,,,,MM.
                ..MM,MM,,,,,,,,,,,,,,,ZMMM,,,,,,,,,,,,,,,,,,,,,,,,,,~NMMMMM++,,,,,,,,,,,,,IM.
                ..MM,MM,,,,,,,,,,,,,,,+MMMMMM7..,,,,,,,,,,,,,,,,,,+MMMMMMMM?:,,,,,,,,,,,,,MM..
                ..NM,MM,,,,,,,,,,,,,,,?IMMMMMMMMM$.,,:,,,,,,,,:,MMMMMMMMMM++,,,,,,,,,,,,,,NM,
                 ..MMMM,,,,,,,,,,,,,,,:+MMMMMMMMMMMMMNNMMO7?8NMMMMMMMMMMMN+,,,,,,,,,,,,,,,MM.
                 ...MMM,,,,,,,,,,,,,,,.++MMMMMMMMMDMO?++78MMMNMZ+=++MMMMM+,,,,,,,,,,,,,,,,MM
                     .M,,,,,,,,,,,,,,,,+++MMMMMMM=+=+++==++++++++++7MMMM=,,,,,,,,,,,,,,,,,M8.
                    ..MM,,,,,,,,,,,,,,,,++?MMMMMMMMI7I?==++++++I777IMMM,,,,,,,,,,,,,,,,,,ZM ....
                     .8M,,,,,,,,,,,,,,,,+++IMMMMMMMI777777++++=II?==MN,,,,,.,,,,,,,,,,,,,M+:. ....
                    ..~MD,,,,,,,,,,,,,,,,?+?+MMM$MMI777I=++++++=?7MM,,,,~MM,,,,,,,,,,,,,7+,:,.?MMM .
                    ...MM,,,,,,,,,,,,,,,,,+++?NM+IMMM++++++++77IMMMMMMMMMNM,,,,,,,,,,,,NMM,,,,,,::MM
                   ...MNMZ,,,,,,,,,,,,,,,,,,++??MM=MM=++=+++++++=MMO=ZZZMM,,,,,,,,,,,,MMM:,,,,ZMMO:N
                ..  MM?:MM.,,,:,,,,,,,,,,,,,.,,:.7NM+==MMD=MO=MM+++++ZZNM.,,,,,,,,,,:MMMM~,,,,,MMM=8
               ..MNM,,,,,MM:.:MO,,,,,,,,,,,,,8MNMMMMM+++++=I+=+=++++=MM.,,,,,,,:.,IMMNMM?+?=,,,,,,MM
          .. 7NNM,,,,,,,=?MM$,,NMM,,,,,,,,,,,.,,7NM8=+++==MNMMMN=+++=MNMDNMMMMNMNM777IM=MM=+++?=,,,.
         .MMMMMDMMMZ:,,:+++INM:,ZMZNNNDMMMMMDMNMZNOM7+++=M$DZD=MM++++M$OM77IM77777777MM++MM+???=,,?D
       .. . ....DM,:,,,++?+++=MMMMI77I7III7I7MI7IDM8M?+++MM?DDZM~=+=OM$ZM77IM77777I77M=MM+MMI++:MMM.
"""
    
    print(welcome)
    
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
//        let testName = "t17"
//        let testNo = "1"
//        let sourceFilePath = "/Users/oscar/Documents/Classes/1920_Spring/Compiler/Compiler-2020/local-judge/testcase/sema/\(testName)-package/\(testName)-\(testNo).mx"
        let sourceFilePath = "/Users/oscar/Documents/Classes/1920_Spring/Compiler/tmp/in.mx"
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
   
//    return
    
    let ir = IRBuilder()
    ir.visit(node: prog)
    
    
    if error.message.count > 0 {
        throw error
    }
    
//    return
    
    DeadCleaner().work(on: ir.module)
    
    IRPrinter(filename: "/Users/oscar/Documents/Classes/1920_Spring/Compiler/tmp/out0.ll").work(on: ir.module)
//    CFGSimplifier().work(on: ir.module)
    MemToReg().work(on: ir.module)
    IRPrinter(filename: "/Users/oscar/Documents/Classes/1920_Spring/Compiler/tmp/out1.ll").work(on: ir.module)
    

    for _ in 0..<2 {
        SCCPropagation().work(on: ir.module)
        DCElimination().work(on: ir.module)
        CFGSimplifier().work(on: ir.module)
        IRPrinter(filename: "/Users/oscar/Documents/Classes/1920_Spring/Compiler/tmp/out1.ll").work(on: ir.module)
        GVNumberer().work(on: ir.module)
//        CSElimination().work(on: ir.module)
        SCCPropagation().work(on: ir.module)
        DCElimination().work(on: ir.module)
        CFGSimplifier().work(on: ir.module)
    }

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
