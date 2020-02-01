// Generated from Mxs.g4 by ANTLR 4.8
import Antlr4

open class MxsLexer: Lexer {

	internal static var _decisionToDFA: [DFA] = {
          var decisionToDFA = [DFA]()
          let length = MxsLexer._ATN.getNumberOfDecisions()
          for i in 0..<length {
          	    decisionToDFA.append(DFA(MxsLexer._ATN.getDecisionState(i)!, i))
          }
           return decisionToDFA
     }()

	internal static let _sharedContextCache = PredictionContextCache()

	public
	static let T__0=1, T__1=2, T__2=3, T__3=4, T__4=5, T__5=6, T__6=7, T__7=8, 
            T__8=9, Bool=10, Int=11, String=12, Void=13, If=14, Else=15, 
            For=16, While=17, Break=18, Continue=19, Return=20, New=21, 
            Class=22, This=23, BoolLiteral=24, IntLiteral=25, StringLiteral=26, 
            NullLiteral=27, EmptySet=28, Assign=29, Mul=30, Div=31, Add=32, 
            Sub=33, Mod=34, Negation=35, Bitwise=36, SelfAdd=37, SelfSub=38, 
            RightShift=39, LeftShift=40, GreaterEq=41, LessEq=42, Greater=43, 
            Less=44, Equal=45, Inequal=46, BitAnd=47, BitOr=48, BitXor=49, 
            LogicAnd=50, LogicOr=51, Identifier=52, Whitespace=53, Newline=54, 
            BlockComment=55, LineComment=56

	public
	static let channelNames: [String] = [
		"DEFAULT_TOKEN_CHANNEL", "HIDDEN"
	]

	public
	static let modeNames: [String] = [
		"DEFAULT_MODE"
	]

	public
	static let ruleNames: [String] = [
		"T__0", "T__1", "T__2", "T__3", "T__4", "T__5", "T__6", "T__7", "T__8", 
		"Bool", "Int", "String", "Void", "If", "Else", "For", "While", "Break", 
		"Continue", "Return", "New", "Class", "This", "BoolLiteral", "IntLiteral", 
		"StringLiteral", "NullLiteral", "EmptySet", "Assign", "Mul", "Div", "Add", 
		"Sub", "Mod", "Negation", "Bitwise", "SelfAdd", "SelfSub", "RightShift", 
		"LeftShift", "GreaterEq", "LessEq", "Greater", "Less", "Equal", "Inequal", 
		"BitAnd", "BitOr", "BitXor", "LogicAnd", "LogicOr", "Identifier", "Whitespace", 
		"Newline", "BlockComment", "LineComment"
	]

	private static let _LITERAL_NAMES: [String?] = [
		nil, "';'", "'('", "','", "')'", "'{'", "'}'", "'['", "']'", "'.'", "'bool'", 
		"'int'", "'string'", "'void'", "'if'", "'else'", "'for'", "'while'", "'break'", 
		"'continue'", "'return'", "'new'", "'class'", "'this'", nil, nil, nil, 
		"'null'", "'[]'", "'='", "'*'", "'/'", "'+'", "'-'", "'%'", "'!'", "'~'", 
		"'++'", "'--'", "'>>'", "'<<'", "'>='", "'<='", "'>'", "'<'", "'=='", 
		"'!='", "'&'", "'|'", "'^'", "'&&'", "'||'"
	]
	private static let _SYMBOLIC_NAMES: [String?] = [
		nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "Bool", "Int", "String", 
		"Void", "If", "Else", "For", "While", "Break", "Continue", "Return", "New", 
		"Class", "This", "BoolLiteral", "IntLiteral", "StringLiteral", "NullLiteral", 
		"EmptySet", "Assign", "Mul", "Div", "Add", "Sub", "Mod", "Negation", "Bitwise", 
		"SelfAdd", "SelfSub", "RightShift", "LeftShift", "GreaterEq", "LessEq", 
		"Greater", "Less", "Equal", "Inequal", "BitAnd", "BitOr", "BitXor", "LogicAnd", 
		"LogicOr", "Identifier", "Whitespace", "Newline", "BlockComment", "LineComment"
	]
	public
	static let VOCABULARY = Vocabulary(_LITERAL_NAMES, _SYMBOLIC_NAMES)


	override open
	func getVocabulary() -> Vocabulary {
		return MxsLexer.VOCABULARY
	}

	public
	required init(_ input: CharStream) {
	    RuntimeMetaData.checkVersion("4.8", RuntimeMetaData.VERSION)
		super.init(input)
		_interp = LexerATNSimulator(self, MxsLexer._ATN, MxsLexer._decisionToDFA, MxsLexer._sharedContextCache)
	}

	override open
	func getGrammarFileName() -> String { return "Mxs.g4" }

	override open
	func getRuleNames() -> [String] { return MxsLexer.ruleNames }

	override open
	func getSerializedATN() -> String { return MxsLexer._serializedATN }

	override open
	func getChannelNames() -> [String] { return MxsLexer.channelNames }

	override open
	func getModeNames() -> [String] { return MxsLexer.modeNames }

	override open
	func getATN() -> ATN { return MxsLexer._ATN }


	public
	static let _serializedATN: String = MxsLexerATN().jsonString

	public
	static let _ATN: ATN = ATNDeserializer().deserializeFromJson(_serializedATN)
}