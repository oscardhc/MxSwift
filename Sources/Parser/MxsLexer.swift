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
            T__8=9, T__9=10, T__10=11, T__11=12, T__12=13, T__13=14, Bool=15, 
            Int=16, String=17, Void=18, If=19, Else=20, For=21, While=22, 
            Break=23, Continue=24, Return=25, New=26, Class=27, This=28, 
            StringLiteral=29, BoolLiteral=30, NullLiteral=31, IntLiteral=32, 
            Assign=33, Mul=34, Div=35, Add=36, Sub=37, Mod=38, Negation=39, 
            Bitwise=40, SelfAdd=41, SelfSub=42, RightShift=43, LeftShift=44, 
            GreaterEq=45, LessEq=46, Greater=47, Less=48, Equal=49, Inequal=50, 
            BitAnd=51, BitOr=52, BitXor=53, LogicAnd=54, LogicOr=55, LeftBr=56, 
            RightBr=57, Semicolon=58, Identifier=59, Whitespace=60, Newline=61, 
            BlockComment=62, LineComment=63

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
		"T__9", "T__10", "T__11", "T__12", "T__13", "Bool", "Int", "String", "Void", 
		"If", "Else", "For", "While", "Break", "Continue", "Return", "New", "Class", 
		"This", "StringLiteral", "BoolLiteral", "NullLiteral", "IntLiteral", "Assign", 
		"Mul", "Div", "Add", "Sub", "Mod", "Negation", "Bitwise", "SelfAdd", "SelfSub", 
		"RightShift", "LeftShift", "GreaterEq", "LessEq", "Greater", "Less", "Equal", 
		"Inequal", "BitAnd", "BitOr", "BitXor", "LogicAnd", "LogicOr", "LeftBr", 
		"RightBr", "Semicolon", "Identifier", "Whitespace", "Newline", "BlockComment", 
		"LineComment"
	]

	private static let _LITERAL_NAMES: [String?] = [
		nil, "'('", "','", "')'", "'\u{666E}\u{901A}\u{8001}\u{767E}\u{59D3}\u{90FD}\u{61C2}\u{7684}'", 
		"'\u{5F97}\u{5230}'", "'\u{6839}\u{636E}'", "'\u{4F46}\u{6211}\u{4E0D}\u{60F3}\u{8BB2}\u{8BC1}\u{660E}'", 
		"'\u{5982}\u{679C}'", "'\u{6216}\u{8005}'", "'\u{53EA}\u{8981}'", "'['", 
		"']'", "'\u{5B8C}\u{6210}\u{4E60}\u{9898}'", "'.'", nil, nil, "'string'", 
		nil, "'if'", "'else'", "'for'", "'while'", "'break'", "'continue'", nil, 
		"'new'", "'class'", "'this'", nil, nil, "'null'"
	]
	private static let _SYMBOLIC_NAMES: [String?] = [
		nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 
		nil, "Bool", "Int", "String", "Void", "If", "Else", "For", "While", "Break", 
		"Continue", "Return", "New", "Class", "This", "StringLiteral", "BoolLiteral", 
		"NullLiteral", "IntLiteral", "Assign", "Mul", "Div", "Add", "Sub", "Mod", 
		"Negation", "Bitwise", "SelfAdd", "SelfSub", "RightShift", "LeftShift", 
		"GreaterEq", "LessEq", "Greater", "Less", "Equal", "Inequal", "BitAnd", 
		"BitOr", "BitXor", "LogicAnd", "LogicOr", "LeftBr", "RightBr", "Semicolon", 
		"Identifier", "Whitespace", "Newline", "BlockComment", "LineComment"
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