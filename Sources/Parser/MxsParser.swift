// Generated from Mxs.g4 by ANTLR 4.8
import Antlr4

open class MxsParser: Parser {

	internal static var _decisionToDFA: [DFA] = {
          var decisionToDFA = [DFA]()
          let length = MxsParser._ATN.getNumberOfDecisions()
          for i in 0..<length {
            decisionToDFA.append(DFA(MxsParser._ATN.getDecisionState(i)!, i))
           }
           return decisionToDFA
     }()

	internal static let _sharedContextCache = PredictionContextCache()

	public
	enum Tokens: Int {
		case EOF = -1, T__0 = 1, T__1 = 2, T__2 = 3, T__3 = 4, T__4 = 5, T__5 = 6, 
                 T__6 = 7, T__7 = 8, T__8 = 9, T__9 = 10, T__10 = 11, T__11 = 12, 
                 T__12 = 13, T__13 = 14, Bool = 15, Int = 16, String = 17, 
                 Void = 18, If = 19, Else = 20, For = 21, While = 22, Break = 23, 
                 Continue = 24, Return = 25, New = 26, Class = 27, This = 28, 
                 StringLiteral = 29, BoolLiteral = 30, NullLiteral = 31, 
                 IntLiteral = 32, Assign = 33, Mul = 34, Div = 35, Add = 36, 
                 Sub = 37, Mod = 38, Negation = 39, Bitwise = 40, SelfAdd = 41, 
                 SelfSub = 42, RightShift = 43, LeftShift = 44, GreaterEq = 45, 
                 LessEq = 46, Greater = 47, Less = 48, Equal = 49, Inequal = 50, 
                 BitAnd = 51, BitOr = 52, BitXor = 53, LogicAnd = 54, LogicOr = 55, 
                 LeftBr = 56, RightBr = 57, Semicolon = 58, Identifier = 59, 
                 Whitespace = 60, Newline = 61, BlockComment = 62, LineComment = 63
	}

	public
	static let RULE_declarations = 0, RULE_declaration = 1, RULE_functionDeclaration = 2, 
            RULE_initialDeclaration = 3, RULE_singleVarDeclaration = 4, 
            RULE_variableDeclaration = 5, RULE_classDeclaration = 6, RULE_declSentence = 7, 
            RULE_ifSentence = 8, RULE_whileSentence = 9, RULE_forSentence = 10, 
            RULE_returnSentence = 11, RULE_breakSentence = 12, RULE_continueSentence = 13, 
            RULE_expressionSentence = 14, RULE_sentence = 15, RULE_codeBlock = 16, 
            RULE_emptySet = 17, RULE_type = 18, RULE_functionExpression = 19, 
            RULE_newIndex = 20, RULE_expression = 21

	public
	static let ruleNames: [String] = [
		"declarations", "declaration", "functionDeclaration", "initialDeclaration", 
		"singleVarDeclaration", "variableDeclaration", "classDeclaration", "declSentence", 
		"ifSentence", "whileSentence", "forSentence", "returnSentence", "breakSentence", 
		"continueSentence", "expressionSentence", "sentence", "codeBlock", "emptySet", 
		"type", "functionExpression", "newIndex", "expression"
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
	func getGrammarFileName() -> String { return "Mxs.g4" }

	override open
	func getRuleNames() -> [String] { return MxsParser.ruleNames }

	override open
	func getSerializedATN() -> String { return MxsParser._serializedATN }

	override open
	func getATN() -> ATN { return MxsParser._ATN }


	override open
	func getVocabulary() -> Vocabulary {
	    return MxsParser.VOCABULARY
	}

	override public
	init(_ input:TokenStream) throws {
	    RuntimeMetaData.checkVersion("4.8", RuntimeMetaData.VERSION)
		try super.init(input)
		_interp = ParserATNSimulator(self,MxsParser._ATN,MxsParser._decisionToDFA, MxsParser._sharedContextCache)
	}


	public class DeclarationsContext: ParserRuleContext {
			open
			func declaration() -> [DeclarationContext] {
				return getRuleContexts(DeclarationContext.self)
			}
			open
			func declaration(_ i: Int) -> DeclarationContext? {
				return getRuleContext(DeclarationContext.self, i)
			}
		override open
		func getRuleIndex() -> Int {
			return MxsParser.RULE_declarations
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.enterDeclarations(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.exitDeclarations(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MxsVisitor {
			    return visitor.visitDeclarations(self)
			}
			else if let visitor = visitor as? MxsBaseVisitor {
			    return visitor.visitDeclarations(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func declarations() throws -> DeclarationsContext {
		var _localctx: DeclarationsContext = DeclarationsContext(_ctx, getState())
		try enterRule(_localctx, 0, MxsParser.RULE_declarations)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(47)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, MxsParser.Tokens.T__3.rawValue,MxsParser.Tokens.Bool.rawValue,MxsParser.Tokens.Int.rawValue,MxsParser.Tokens.String.rawValue,MxsParser.Tokens.Void.rawValue,MxsParser.Tokens.Class.rawValue,MxsParser.Tokens.Identifier.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	      return testSet
		 	 }()) {
		 		setState(44)
		 		try declaration()


		 		setState(49)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class DeclarationContext: ParserRuleContext {
			open
			func functionDeclaration() -> FunctionDeclarationContext? {
				return getRuleContext(FunctionDeclarationContext.self, 0)
			}
			open
			func variableDeclaration() -> VariableDeclarationContext? {
				return getRuleContext(VariableDeclarationContext.self, 0)
			}
			open
			func classDeclaration() -> ClassDeclarationContext? {
				return getRuleContext(ClassDeclarationContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return MxsParser.RULE_declaration
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.enterDeclaration(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.exitDeclaration(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MxsVisitor {
			    return visitor.visitDeclaration(self)
			}
			else if let visitor = visitor as? MxsBaseVisitor {
			    return visitor.visitDeclaration(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func declaration() throws -> DeclarationContext {
		var _localctx: DeclarationContext = DeclarationContext(_ctx, getState())
		try enterRule(_localctx, 2, MxsParser.RULE_declaration)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(53)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,1, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(50)
		 		try functionDeclaration()

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(51)
		 		try variableDeclaration()

		 		break
		 	case 3:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(52)
		 		try classDeclaration()

		 		break
		 	default: break
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class FunctionDeclarationContext: ParserRuleContext {
			open
			func type() -> [TypeContext] {
				return getRuleContexts(TypeContext.self)
			}
			open
			func type(_ i: Int) -> TypeContext? {
				return getRuleContext(TypeContext.self, i)
			}
			open
			func Identifier() -> [TerminalNode] {
				return getTokens(MxsParser.Tokens.Identifier.rawValue)
			}
			open
			func Identifier(_ i:Int) -> TerminalNode? {
				return getToken(MxsParser.Tokens.Identifier.rawValue, i)
			}
			open
			func LeftBr() -> TerminalNode? {
				return getToken(MxsParser.Tokens.LeftBr.rawValue, 0)
			}
			open
			func RightBr() -> TerminalNode? {
				return getToken(MxsParser.Tokens.RightBr.rawValue, 0)
			}
			open
			func sentence() -> [SentenceContext] {
				return getRuleContexts(SentenceContext.self)
			}
			open
			func sentence(_ i: Int) -> SentenceContext? {
				return getRuleContext(SentenceContext.self, i)
			}
		override open
		func getRuleIndex() -> Int {
			return MxsParser.RULE_functionDeclaration
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.enterFunctionDeclaration(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.exitFunctionDeclaration(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MxsVisitor {
			    return visitor.visitFunctionDeclaration(self)
			}
			else if let visitor = visitor as? MxsBaseVisitor {
			    return visitor.visitFunctionDeclaration(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func functionDeclaration() throws -> FunctionDeclarationContext {
		var _localctx: FunctionDeclarationContext = FunctionDeclarationContext(_ctx, getState())
		try enterRule(_localctx, 4, MxsParser.RULE_functionDeclaration)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	setState(109)
		 	try _errHandler.sync(self)
		 	switch (MxsParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .Bool:fallthrough
		 	case .Int:fallthrough
		 	case .String:fallthrough
		 	case .Void:fallthrough
		 	case .Identifier:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(55)
		 		try type()
		 		setState(56)
		 		try match(MxsParser.Tokens.Identifier.rawValue)
		 		setState(57)
		 		try match(MxsParser.Tokens.T__0.rawValue)
		 		setState(70)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = {  () -> Bool in
		 		   let testArray: [Int] = [_la, MxsParser.Tokens.Bool.rawValue,MxsParser.Tokens.Int.rawValue,MxsParser.Tokens.String.rawValue,MxsParser.Tokens.Void.rawValue,MxsParser.Tokens.Identifier.rawValue]
		 		    return  Utils.testBitLeftShiftArray(testArray, 0)
		 		}()
		 		      return testSet
		 		 }()) {
		 			setState(64)
		 			try _errHandler.sync(self)
		 			_alt = try getInterpreter().adaptivePredict(_input,2,_ctx)
		 			while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 				if ( _alt==1 ) {
		 					setState(58)
		 					try type()
		 					setState(59)
		 					try match(MxsParser.Tokens.Identifier.rawValue)
		 					setState(60)
		 					try match(MxsParser.Tokens.T__1.rawValue)

		 			 
		 				}
		 				setState(66)
		 				try _errHandler.sync(self)
		 				_alt = try getInterpreter().adaptivePredict(_input,2,_ctx)
		 			}
		 			setState(67)
		 			try type()
		 			setState(68)
		 			try match(MxsParser.Tokens.Identifier.rawValue)

		 		}

		 		setState(72)
		 		try match(MxsParser.Tokens.T__2.rawValue)
		 		setState(73)
		 		try match(MxsParser.Tokens.LeftBr.rawValue)
		 		setState(77)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		while (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = {  () -> Bool in
		 		   let testArray: [Int] = [_la, MxsParser.Tokens.T__0.rawValue,MxsParser.Tokens.T__7.rawValue,MxsParser.Tokens.T__9.rawValue,MxsParser.Tokens.T__12.rawValue,MxsParser.Tokens.Bool.rawValue,MxsParser.Tokens.Int.rawValue,MxsParser.Tokens.String.rawValue,MxsParser.Tokens.Void.rawValue,MxsParser.Tokens.If.rawValue,MxsParser.Tokens.For.rawValue,MxsParser.Tokens.While.rawValue,MxsParser.Tokens.Break.rawValue,MxsParser.Tokens.Continue.rawValue,MxsParser.Tokens.Return.rawValue,MxsParser.Tokens.New.rawValue,MxsParser.Tokens.This.rawValue,MxsParser.Tokens.StringLiteral.rawValue,MxsParser.Tokens.BoolLiteral.rawValue,MxsParser.Tokens.NullLiteral.rawValue,MxsParser.Tokens.IntLiteral.rawValue,MxsParser.Tokens.Add.rawValue,MxsParser.Tokens.Sub.rawValue,MxsParser.Tokens.Negation.rawValue,MxsParser.Tokens.Bitwise.rawValue,MxsParser.Tokens.SelfAdd.rawValue,MxsParser.Tokens.SelfSub.rawValue,MxsParser.Tokens.LeftBr.rawValue,MxsParser.Tokens.Semicolon.rawValue,MxsParser.Tokens.Identifier.rawValue]
		 		    return  Utils.testBitLeftShiftArray(testArray, 0)
		 		}()
		 		      return testSet
		 		 }()) {
		 			setState(74)
		 			try sentence()


		 			setState(79)
		 			try _errHandler.sync(self)
		 			_la = try _input.LA(1)
		 		}
		 		setState(80)
		 		try match(MxsParser.Tokens.RightBr.rawValue)

		 		break

		 	case .T__3:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(82)
		 		try match(MxsParser.Tokens.T__3.rawValue)
		 		setState(83)
		 		try match(MxsParser.Tokens.Identifier.rawValue)
		 		setState(84)
		 		try match(MxsParser.Tokens.T__4.rawValue)
		 		setState(85)
		 		try type()
		 		setState(99)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == MxsParser.Tokens.T__5.rawValue
		 		      return testSet
		 		 }()) {
		 			setState(86)
		 			try match(MxsParser.Tokens.T__5.rawValue)
		 			setState(93)
		 			try _errHandler.sync(self)
		 			_alt = try getInterpreter().adaptivePredict(_input,5,_ctx)
		 			while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 				if ( _alt==1 ) {
		 					setState(87)
		 					try type()
		 					setState(88)
		 					try match(MxsParser.Tokens.Identifier.rawValue)
		 					setState(89)
		 					try match(MxsParser.Tokens.T__1.rawValue)

		 			 
		 				}
		 				setState(95)
		 				try _errHandler.sync(self)
		 				_alt = try getInterpreter().adaptivePredict(_input,5,_ctx)
		 			}
		 			setState(96)
		 			try type()
		 			setState(97)
		 			try match(MxsParser.Tokens.Identifier.rawValue)

		 		}

		 		setState(104)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		while (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = {  () -> Bool in
		 		   let testArray: [Int] = [_la, MxsParser.Tokens.T__0.rawValue,MxsParser.Tokens.T__7.rawValue,MxsParser.Tokens.T__9.rawValue,MxsParser.Tokens.T__12.rawValue,MxsParser.Tokens.Bool.rawValue,MxsParser.Tokens.Int.rawValue,MxsParser.Tokens.String.rawValue,MxsParser.Tokens.Void.rawValue,MxsParser.Tokens.If.rawValue,MxsParser.Tokens.For.rawValue,MxsParser.Tokens.While.rawValue,MxsParser.Tokens.Break.rawValue,MxsParser.Tokens.Continue.rawValue,MxsParser.Tokens.Return.rawValue,MxsParser.Tokens.New.rawValue,MxsParser.Tokens.This.rawValue,MxsParser.Tokens.StringLiteral.rawValue,MxsParser.Tokens.BoolLiteral.rawValue,MxsParser.Tokens.NullLiteral.rawValue,MxsParser.Tokens.IntLiteral.rawValue,MxsParser.Tokens.Add.rawValue,MxsParser.Tokens.Sub.rawValue,MxsParser.Tokens.Negation.rawValue,MxsParser.Tokens.Bitwise.rawValue,MxsParser.Tokens.SelfAdd.rawValue,MxsParser.Tokens.SelfSub.rawValue,MxsParser.Tokens.LeftBr.rawValue,MxsParser.Tokens.Semicolon.rawValue,MxsParser.Tokens.Identifier.rawValue]
		 		    return  Utils.testBitLeftShiftArray(testArray, 0)
		 		}()
		 		      return testSet
		 		 }()) {
		 			setState(101)
		 			try sentence()


		 			setState(106)
		 			try _errHandler.sync(self)
		 			_la = try _input.LA(1)
		 		}
		 		setState(107)
		 		try match(MxsParser.Tokens.T__6.rawValue)

		 		break
		 	default:
		 		throw ANTLRException.recognition(e: NoViableAltException(self))
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class InitialDeclarationContext: ParserRuleContext {
			open
			func Identifier() -> [TerminalNode] {
				return getTokens(MxsParser.Tokens.Identifier.rawValue)
			}
			open
			func Identifier(_ i:Int) -> TerminalNode? {
				return getToken(MxsParser.Tokens.Identifier.rawValue, i)
			}
			open
			func LeftBr() -> TerminalNode? {
				return getToken(MxsParser.Tokens.LeftBr.rawValue, 0)
			}
			open
			func RightBr() -> TerminalNode? {
				return getToken(MxsParser.Tokens.RightBr.rawValue, 0)
			}
			open
			func type() -> [TypeContext] {
				return getRuleContexts(TypeContext.self)
			}
			open
			func type(_ i: Int) -> TypeContext? {
				return getRuleContext(TypeContext.self, i)
			}
			open
			func sentence() -> [SentenceContext] {
				return getRuleContexts(SentenceContext.self)
			}
			open
			func sentence(_ i: Int) -> SentenceContext? {
				return getRuleContext(SentenceContext.self, i)
			}
		override open
		func getRuleIndex() -> Int {
			return MxsParser.RULE_initialDeclaration
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.enterInitialDeclaration(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.exitInitialDeclaration(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MxsVisitor {
			    return visitor.visitInitialDeclaration(self)
			}
			else if let visitor = visitor as? MxsBaseVisitor {
			    return visitor.visitInitialDeclaration(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func initialDeclaration() throws -> InitialDeclarationContext {
		var _localctx: InitialDeclarationContext = InitialDeclarationContext(_ctx, getState())
		try enterRule(_localctx, 6, MxsParser.RULE_initialDeclaration)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	try enterOuterAlt(_localctx, 1)
		 	setState(111)
		 	try match(MxsParser.Tokens.Identifier.rawValue)
		 	setState(112)
		 	try match(MxsParser.Tokens.T__0.rawValue)
		 	setState(125)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, MxsParser.Tokens.Bool.rawValue,MxsParser.Tokens.Int.rawValue,MxsParser.Tokens.String.rawValue,MxsParser.Tokens.Void.rawValue,MxsParser.Tokens.Identifier.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	      return testSet
		 	 }()) {
		 		setState(119)
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,9,_ctx)
		 		while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 			if ( _alt==1 ) {
		 				setState(113)
		 				try type()
		 				setState(114)
		 				try match(MxsParser.Tokens.Identifier.rawValue)
		 				setState(115)
		 				try match(MxsParser.Tokens.T__1.rawValue)

		 		 
		 			}
		 			setState(121)
		 			try _errHandler.sync(self)
		 			_alt = try getInterpreter().adaptivePredict(_input,9,_ctx)
		 		}
		 		setState(122)
		 		try type()
		 		setState(123)
		 		try match(MxsParser.Tokens.Identifier.rawValue)

		 	}

		 	setState(127)
		 	try match(MxsParser.Tokens.T__2.rawValue)
		 	setState(128)
		 	try match(MxsParser.Tokens.LeftBr.rawValue)
		 	setState(132)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, MxsParser.Tokens.T__0.rawValue,MxsParser.Tokens.T__7.rawValue,MxsParser.Tokens.T__9.rawValue,MxsParser.Tokens.T__12.rawValue,MxsParser.Tokens.Bool.rawValue,MxsParser.Tokens.Int.rawValue,MxsParser.Tokens.String.rawValue,MxsParser.Tokens.Void.rawValue,MxsParser.Tokens.If.rawValue,MxsParser.Tokens.For.rawValue,MxsParser.Tokens.While.rawValue,MxsParser.Tokens.Break.rawValue,MxsParser.Tokens.Continue.rawValue,MxsParser.Tokens.Return.rawValue,MxsParser.Tokens.New.rawValue,MxsParser.Tokens.This.rawValue,MxsParser.Tokens.StringLiteral.rawValue,MxsParser.Tokens.BoolLiteral.rawValue,MxsParser.Tokens.NullLiteral.rawValue,MxsParser.Tokens.IntLiteral.rawValue,MxsParser.Tokens.Add.rawValue,MxsParser.Tokens.Sub.rawValue,MxsParser.Tokens.Negation.rawValue,MxsParser.Tokens.Bitwise.rawValue,MxsParser.Tokens.SelfAdd.rawValue,MxsParser.Tokens.SelfSub.rawValue,MxsParser.Tokens.LeftBr.rawValue,MxsParser.Tokens.Semicolon.rawValue,MxsParser.Tokens.Identifier.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	      return testSet
		 	 }()) {
		 		setState(129)
		 		try sentence()


		 		setState(134)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 	}
		 	setState(135)
		 	try match(MxsParser.Tokens.RightBr.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class SingleVarDeclarationContext: ParserRuleContext {
			open
			func Identifier() -> TerminalNode? {
				return getToken(MxsParser.Tokens.Identifier.rawValue, 0)
			}
			open
			func Assign() -> TerminalNode? {
				return getToken(MxsParser.Tokens.Assign.rawValue, 0)
			}
			open
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return MxsParser.RULE_singleVarDeclaration
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.enterSingleVarDeclaration(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.exitSingleVarDeclaration(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MxsVisitor {
			    return visitor.visitSingleVarDeclaration(self)
			}
			else if let visitor = visitor as? MxsBaseVisitor {
			    return visitor.visitSingleVarDeclaration(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func singleVarDeclaration() throws -> SingleVarDeclarationContext {
		var _localctx: SingleVarDeclarationContext = SingleVarDeclarationContext(_ctx, getState())
		try enterRule(_localctx, 8, MxsParser.RULE_singleVarDeclaration)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(137)
		 	try match(MxsParser.Tokens.Identifier.rawValue)
		 	setState(140)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == MxsParser.Tokens.Assign.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(138)
		 		try match(MxsParser.Tokens.Assign.rawValue)
		 		setState(139)
		 		try expression(0)

		 	}


		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class VariableDeclarationContext: ParserRuleContext {
			open
			func type() -> TypeContext? {
				return getRuleContext(TypeContext.self, 0)
			}
			open
			func singleVarDeclaration() -> [SingleVarDeclarationContext] {
				return getRuleContexts(SingleVarDeclarationContext.self)
			}
			open
			func singleVarDeclaration(_ i: Int) -> SingleVarDeclarationContext? {
				return getRuleContext(SingleVarDeclarationContext.self, i)
			}
			open
			func Semicolon() -> TerminalNode? {
				return getToken(MxsParser.Tokens.Semicolon.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return MxsParser.RULE_variableDeclaration
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.enterVariableDeclaration(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.exitVariableDeclaration(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MxsVisitor {
			    return visitor.visitVariableDeclaration(self)
			}
			else if let visitor = visitor as? MxsBaseVisitor {
			    return visitor.visitVariableDeclaration(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func variableDeclaration() throws -> VariableDeclarationContext {
		var _localctx: VariableDeclarationContext = VariableDeclarationContext(_ctx, getState())
		try enterRule(_localctx, 10, MxsParser.RULE_variableDeclaration)
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	try enterOuterAlt(_localctx, 1)
		 	setState(142)
		 	try type()
		 	setState(148)
		 	try _errHandler.sync(self)
		 	_alt = try getInterpreter().adaptivePredict(_input,13,_ctx)
		 	while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 		if ( _alt==1 ) {
		 			setState(143)
		 			try singleVarDeclaration()
		 			setState(144)
		 			try match(MxsParser.Tokens.T__1.rawValue)

		 	 
		 		}
		 		setState(150)
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,13,_ctx)
		 	}
		 	setState(151)
		 	try singleVarDeclaration()
		 	setState(152)
		 	try match(MxsParser.Tokens.Semicolon.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ClassDeclarationContext: ParserRuleContext {
			open
			func Class() -> TerminalNode? {
				return getToken(MxsParser.Tokens.Class.rawValue, 0)
			}
			open
			func Identifier() -> TerminalNode? {
				return getToken(MxsParser.Tokens.Identifier.rawValue, 0)
			}
			open
			func LeftBr() -> TerminalNode? {
				return getToken(MxsParser.Tokens.LeftBr.rawValue, 0)
			}
			open
			func RightBr() -> TerminalNode? {
				return getToken(MxsParser.Tokens.RightBr.rawValue, 0)
			}
			open
			func Semicolon() -> TerminalNode? {
				return getToken(MxsParser.Tokens.Semicolon.rawValue, 0)
			}
			open
			func variableDeclaration() -> [VariableDeclarationContext] {
				return getRuleContexts(VariableDeclarationContext.self)
			}
			open
			func variableDeclaration(_ i: Int) -> VariableDeclarationContext? {
				return getRuleContext(VariableDeclarationContext.self, i)
			}
			open
			func functionDeclaration() -> [FunctionDeclarationContext] {
				return getRuleContexts(FunctionDeclarationContext.self)
			}
			open
			func functionDeclaration(_ i: Int) -> FunctionDeclarationContext? {
				return getRuleContext(FunctionDeclarationContext.self, i)
			}
			open
			func initialDeclaration() -> [InitialDeclarationContext] {
				return getRuleContexts(InitialDeclarationContext.self)
			}
			open
			func initialDeclaration(_ i: Int) -> InitialDeclarationContext? {
				return getRuleContext(InitialDeclarationContext.self, i)
			}
		override open
		func getRuleIndex() -> Int {
			return MxsParser.RULE_classDeclaration
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.enterClassDeclaration(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.exitClassDeclaration(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MxsVisitor {
			    return visitor.visitClassDeclaration(self)
			}
			else if let visitor = visitor as? MxsBaseVisitor {
			    return visitor.visitClassDeclaration(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func classDeclaration() throws -> ClassDeclarationContext {
		var _localctx: ClassDeclarationContext = ClassDeclarationContext(_ctx, getState())
		try enterRule(_localctx, 12, MxsParser.RULE_classDeclaration)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(154)
		 	try match(MxsParser.Tokens.Class.rawValue)
		 	setState(155)
		 	try match(MxsParser.Tokens.Identifier.rawValue)
		 	setState(156)
		 	try match(MxsParser.Tokens.LeftBr.rawValue)
		 	setState(162)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, MxsParser.Tokens.T__3.rawValue,MxsParser.Tokens.Bool.rawValue,MxsParser.Tokens.Int.rawValue,MxsParser.Tokens.String.rawValue,MxsParser.Tokens.Void.rawValue,MxsParser.Tokens.Identifier.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	      return testSet
		 	 }()) {
		 		setState(160)
		 		try _errHandler.sync(self)
		 		switch(try getInterpreter().adaptivePredict(_input,14, _ctx)) {
		 		case 1:
		 			setState(157)
		 			try variableDeclaration()

		 			break
		 		case 2:
		 			setState(158)
		 			try functionDeclaration()

		 			break
		 		case 3:
		 			setState(159)
		 			try initialDeclaration()

		 			break
		 		default: break
		 		}

		 		setState(164)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 	}
		 	setState(165)
		 	try match(MxsParser.Tokens.RightBr.rawValue)
		 	setState(166)
		 	try match(MxsParser.Tokens.Semicolon.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class DeclSentenceContext: ParserRuleContext {
			open
			func variableDeclaration() -> VariableDeclarationContext? {
				return getRuleContext(VariableDeclarationContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return MxsParser.RULE_declSentence
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.enterDeclSentence(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.exitDeclSentence(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MxsVisitor {
			    return visitor.visitDeclSentence(self)
			}
			else if let visitor = visitor as? MxsBaseVisitor {
			    return visitor.visitDeclSentence(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func declSentence() throws -> DeclSentenceContext {
		var _localctx: DeclSentenceContext = DeclSentenceContext(_ctx, getState())
		try enterRule(_localctx, 14, MxsParser.RULE_declSentence)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(168)
		 	try variableDeclaration()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class IfSentenceContext: ParserRuleContext {
			open
			func If() -> TerminalNode? {
				return getToken(MxsParser.Tokens.If.rawValue, 0)
			}
			open
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}
			open
			func sentence() -> [SentenceContext] {
				return getRuleContexts(SentenceContext.self)
			}
			open
			func sentence(_ i: Int) -> SentenceContext? {
				return getRuleContext(SentenceContext.self, i)
			}
			open
			func Else() -> TerminalNode? {
				return getToken(MxsParser.Tokens.Else.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return MxsParser.RULE_ifSentence
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.enterIfSentence(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.exitIfSentence(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MxsVisitor {
			    return visitor.visitIfSentence(self)
			}
			else if let visitor = visitor as? MxsBaseVisitor {
			    return visitor.visitIfSentence(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func ifSentence() throws -> IfSentenceContext {
		var _localctx: IfSentenceContext = IfSentenceContext(_ctx, getState())
		try enterRule(_localctx, 16, MxsParser.RULE_ifSentence)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(186)
		 	try _errHandler.sync(self)
		 	switch (MxsParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .If:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(170)
		 		try match(MxsParser.Tokens.If.rawValue)
		 		setState(171)
		 		try match(MxsParser.Tokens.T__0.rawValue)
		 		setState(172)
		 		try expression(0)
		 		setState(173)
		 		try match(MxsParser.Tokens.T__2.rawValue)
		 		setState(174)
		 		try sentence()
		 		setState(177)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,16,_ctx)) {
		 		case 1:
		 			setState(175)
		 			try match(MxsParser.Tokens.Else.rawValue)
		 			setState(176)
		 			try sentence()

		 			break
		 		default: break
		 		}

		 		break

		 	case .T__7:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(179)
		 		try match(MxsParser.Tokens.T__7.rawValue)
		 		setState(180)
		 		try expression(0)
		 		setState(181)
		 		try sentence()
		 		setState(184)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,17,_ctx)) {
		 		case 1:
		 			setState(182)
		 			try match(MxsParser.Tokens.T__8.rawValue)
		 			setState(183)
		 			try sentence()

		 			break
		 		default: break
		 		}

		 		break
		 	default:
		 		throw ANTLRException.recognition(e: NoViableAltException(self))
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class WhileSentenceContext: ParserRuleContext {
			open
			func While() -> TerminalNode? {
				return getToken(MxsParser.Tokens.While.rawValue, 0)
			}
			open
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}
			open
			func sentence() -> SentenceContext? {
				return getRuleContext(SentenceContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return MxsParser.RULE_whileSentence
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.enterWhileSentence(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.exitWhileSentence(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MxsVisitor {
			    return visitor.visitWhileSentence(self)
			}
			else if let visitor = visitor as? MxsBaseVisitor {
			    return visitor.visitWhileSentence(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func whileSentence() throws -> WhileSentenceContext {
		var _localctx: WhileSentenceContext = WhileSentenceContext(_ctx, getState())
		try enterRule(_localctx, 18, MxsParser.RULE_whileSentence)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(198)
		 	try _errHandler.sync(self)
		 	switch (MxsParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .While:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(188)
		 		try match(MxsParser.Tokens.While.rawValue)
		 		setState(189)
		 		try match(MxsParser.Tokens.T__0.rawValue)
		 		setState(190)
		 		try expression(0)
		 		setState(191)
		 		try match(MxsParser.Tokens.T__2.rawValue)
		 		setState(192)
		 		try sentence()

		 		break

		 	case .T__9:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(194)
		 		try match(MxsParser.Tokens.T__9.rawValue)
		 		setState(195)
		 		try expression(0)
		 		setState(196)
		 		try sentence()

		 		break
		 	default:
		 		throw ANTLRException.recognition(e: NoViableAltException(self))
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ForSentenceContext: ParserRuleContext {
		open var cod: ExpressionContext!
		open var inc: ExpressionContext!
		open var body: SentenceContext!
			open
			func For() -> TerminalNode? {
				return getToken(MxsParser.Tokens.For.rawValue, 0)
			}
			open
			func Semicolon() -> [TerminalNode] {
				return getTokens(MxsParser.Tokens.Semicolon.rawValue)
			}
			open
			func Semicolon(_ i:Int) -> TerminalNode? {
				return getToken(MxsParser.Tokens.Semicolon.rawValue, i)
			}
			open
			func sentence() -> SentenceContext? {
				return getRuleContext(SentenceContext.self, 0)
			}
			open
			func expressionSentence() -> ExpressionSentenceContext? {
				return getRuleContext(ExpressionSentenceContext.self, 0)
			}
			open
			func declSentence() -> DeclSentenceContext? {
				return getRuleContext(DeclSentenceContext.self, 0)
			}
			open
			func expression() -> [ExpressionContext] {
				return getRuleContexts(ExpressionContext.self)
			}
			open
			func expression(_ i: Int) -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, i)
			}
		override open
		func getRuleIndex() -> Int {
			return MxsParser.RULE_forSentence
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.enterForSentence(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.exitForSentence(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MxsVisitor {
			    return visitor.visitForSentence(self)
			}
			else if let visitor = visitor as? MxsBaseVisitor {
			    return visitor.visitForSentence(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func forSentence() throws -> ForSentenceContext {
		var _localctx: ForSentenceContext = ForSentenceContext(_ctx, getState())
		try enterRule(_localctx, 20, MxsParser.RULE_forSentence)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(200)
		 	try match(MxsParser.Tokens.For.rawValue)
		 	setState(201)
		 	try match(MxsParser.Tokens.T__0.rawValue)
		 	setState(205)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,20, _ctx)) {
		 	case 1:
		 		setState(202)
		 		try expressionSentence()

		 		break
		 	case 2:
		 		setState(203)
		 		try declSentence()

		 		break
		 	case 3:
		 		setState(204)
		 		try match(MxsParser.Tokens.Semicolon.rawValue)

		 		break
		 	default: break
		 	}
		 	setState(208)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, MxsParser.Tokens.T__0.rawValue,MxsParser.Tokens.T__12.rawValue,MxsParser.Tokens.New.rawValue,MxsParser.Tokens.This.rawValue,MxsParser.Tokens.StringLiteral.rawValue,MxsParser.Tokens.BoolLiteral.rawValue,MxsParser.Tokens.NullLiteral.rawValue,MxsParser.Tokens.IntLiteral.rawValue,MxsParser.Tokens.Add.rawValue,MxsParser.Tokens.Sub.rawValue,MxsParser.Tokens.Negation.rawValue,MxsParser.Tokens.Bitwise.rawValue,MxsParser.Tokens.SelfAdd.rawValue,MxsParser.Tokens.SelfSub.rawValue,MxsParser.Tokens.Identifier.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	      return testSet
		 	 }()) {
		 		setState(207)
		 		try {
		 				let assignmentValue = try expression(0)
		 				_localctx.castdown(ForSentenceContext.self).cod = assignmentValue
		 		     }()


		 	}

		 	setState(210)
		 	try match(MxsParser.Tokens.Semicolon.rawValue)
		 	setState(212)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, MxsParser.Tokens.T__0.rawValue,MxsParser.Tokens.T__12.rawValue,MxsParser.Tokens.New.rawValue,MxsParser.Tokens.This.rawValue,MxsParser.Tokens.StringLiteral.rawValue,MxsParser.Tokens.BoolLiteral.rawValue,MxsParser.Tokens.NullLiteral.rawValue,MxsParser.Tokens.IntLiteral.rawValue,MxsParser.Tokens.Add.rawValue,MxsParser.Tokens.Sub.rawValue,MxsParser.Tokens.Negation.rawValue,MxsParser.Tokens.Bitwise.rawValue,MxsParser.Tokens.SelfAdd.rawValue,MxsParser.Tokens.SelfSub.rawValue,MxsParser.Tokens.Identifier.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	      return testSet
		 	 }()) {
		 		setState(211)
		 		try {
		 				let assignmentValue = try expression(0)
		 				_localctx.castdown(ForSentenceContext.self).inc = assignmentValue
		 		     }()


		 	}

		 	setState(214)
		 	try match(MxsParser.Tokens.T__2.rawValue)
		 	setState(215)
		 	try {
		 			let assignmentValue = try sentence()
		 			_localctx.castdown(ForSentenceContext.self).body = assignmentValue
		 	     }()


		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ReturnSentenceContext: ParserRuleContext {
			open
			func Return() -> TerminalNode? {
				return getToken(MxsParser.Tokens.Return.rawValue, 0)
			}
			open
			func Semicolon() -> TerminalNode? {
				return getToken(MxsParser.Tokens.Semicolon.rawValue, 0)
			}
			open
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return MxsParser.RULE_returnSentence
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.enterReturnSentence(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.exitReturnSentence(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MxsVisitor {
			    return visitor.visitReturnSentence(self)
			}
			else if let visitor = visitor as? MxsBaseVisitor {
			    return visitor.visitReturnSentence(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func returnSentence() throws -> ReturnSentenceContext {
		var _localctx: ReturnSentenceContext = ReturnSentenceContext(_ctx, getState())
		try enterRule(_localctx, 22, MxsParser.RULE_returnSentence)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(217)
		 	try match(MxsParser.Tokens.Return.rawValue)
		 	setState(219)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, MxsParser.Tokens.T__0.rawValue,MxsParser.Tokens.T__12.rawValue,MxsParser.Tokens.New.rawValue,MxsParser.Tokens.This.rawValue,MxsParser.Tokens.StringLiteral.rawValue,MxsParser.Tokens.BoolLiteral.rawValue,MxsParser.Tokens.NullLiteral.rawValue,MxsParser.Tokens.IntLiteral.rawValue,MxsParser.Tokens.Add.rawValue,MxsParser.Tokens.Sub.rawValue,MxsParser.Tokens.Negation.rawValue,MxsParser.Tokens.Bitwise.rawValue,MxsParser.Tokens.SelfAdd.rawValue,MxsParser.Tokens.SelfSub.rawValue,MxsParser.Tokens.Identifier.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	      return testSet
		 	 }()) {
		 		setState(218)
		 		try expression(0)

		 	}

		 	setState(221)
		 	try match(MxsParser.Tokens.Semicolon.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class BreakSentenceContext: ParserRuleContext {
			open
			func Break() -> TerminalNode? {
				return getToken(MxsParser.Tokens.Break.rawValue, 0)
			}
			open
			func Semicolon() -> TerminalNode? {
				return getToken(MxsParser.Tokens.Semicolon.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return MxsParser.RULE_breakSentence
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.enterBreakSentence(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.exitBreakSentence(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MxsVisitor {
			    return visitor.visitBreakSentence(self)
			}
			else if let visitor = visitor as? MxsBaseVisitor {
			    return visitor.visitBreakSentence(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func breakSentence() throws -> BreakSentenceContext {
		var _localctx: BreakSentenceContext = BreakSentenceContext(_ctx, getState())
		try enterRule(_localctx, 24, MxsParser.RULE_breakSentence)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(223)
		 	try match(MxsParser.Tokens.Break.rawValue)
		 	setState(224)
		 	try match(MxsParser.Tokens.Semicolon.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ContinueSentenceContext: ParserRuleContext {
			open
			func Continue() -> TerminalNode? {
				return getToken(MxsParser.Tokens.Continue.rawValue, 0)
			}
			open
			func Semicolon() -> TerminalNode? {
				return getToken(MxsParser.Tokens.Semicolon.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return MxsParser.RULE_continueSentence
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.enterContinueSentence(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.exitContinueSentence(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MxsVisitor {
			    return visitor.visitContinueSentence(self)
			}
			else if let visitor = visitor as? MxsBaseVisitor {
			    return visitor.visitContinueSentence(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func continueSentence() throws -> ContinueSentenceContext {
		var _localctx: ContinueSentenceContext = ContinueSentenceContext(_ctx, getState())
		try enterRule(_localctx, 26, MxsParser.RULE_continueSentence)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(226)
		 	try match(MxsParser.Tokens.Continue.rawValue)
		 	setState(227)
		 	try match(MxsParser.Tokens.Semicolon.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ExpressionSentenceContext: ParserRuleContext {
			open
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}
			open
			func Semicolon() -> TerminalNode? {
				return getToken(MxsParser.Tokens.Semicolon.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return MxsParser.RULE_expressionSentence
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.enterExpressionSentence(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.exitExpressionSentence(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MxsVisitor {
			    return visitor.visitExpressionSentence(self)
			}
			else if let visitor = visitor as? MxsBaseVisitor {
			    return visitor.visitExpressionSentence(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func expressionSentence() throws -> ExpressionSentenceContext {
		var _localctx: ExpressionSentenceContext = ExpressionSentenceContext(_ctx, getState())
		try enterRule(_localctx, 28, MxsParser.RULE_expressionSentence)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(229)
		 	try expression(0)
		 	setState(230)
		 	try match(MxsParser.Tokens.Semicolon.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class SentenceContext: ParserRuleContext {
			open
			func declSentence() -> DeclSentenceContext? {
				return getRuleContext(DeclSentenceContext.self, 0)
			}
			open
			func ifSentence() -> IfSentenceContext? {
				return getRuleContext(IfSentenceContext.self, 0)
			}
			open
			func whileSentence() -> WhileSentenceContext? {
				return getRuleContext(WhileSentenceContext.self, 0)
			}
			open
			func forSentence() -> ForSentenceContext? {
				return getRuleContext(ForSentenceContext.self, 0)
			}
			open
			func returnSentence() -> ReturnSentenceContext? {
				return getRuleContext(ReturnSentenceContext.self, 0)
			}
			open
			func breakSentence() -> BreakSentenceContext? {
				return getRuleContext(BreakSentenceContext.self, 0)
			}
			open
			func continueSentence() -> ContinueSentenceContext? {
				return getRuleContext(ContinueSentenceContext.self, 0)
			}
			open
			func expressionSentence() -> ExpressionSentenceContext? {
				return getRuleContext(ExpressionSentenceContext.self, 0)
			}
			open
			func codeBlock() -> CodeBlockContext? {
				return getRuleContext(CodeBlockContext.self, 0)
			}
			open
			func Semicolon() -> TerminalNode? {
				return getToken(MxsParser.Tokens.Semicolon.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return MxsParser.RULE_sentence
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.enterSentence(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.exitSentence(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MxsVisitor {
			    return visitor.visitSentence(self)
			}
			else if let visitor = visitor as? MxsBaseVisitor {
			    return visitor.visitSentence(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func sentence() throws -> SentenceContext {
		var _localctx: SentenceContext = SentenceContext(_ctx, getState())
		try enterRule(_localctx, 30, MxsParser.RULE_sentence)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(242)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,24, _ctx)) {
		 	case 1:
		 		setState(232)
		 		try declSentence()

		 		break
		 	case 2:
		 		setState(233)
		 		try ifSentence()

		 		break
		 	case 3:
		 		setState(234)
		 		try whileSentence()

		 		break
		 	case 4:
		 		setState(235)
		 		try forSentence()

		 		break
		 	case 5:
		 		setState(236)
		 		try returnSentence()

		 		break
		 	case 6:
		 		setState(237)
		 		try breakSentence()

		 		break
		 	case 7:
		 		setState(238)
		 		try continueSentence()

		 		break
		 	case 8:
		 		setState(239)
		 		try expressionSentence()

		 		break
		 	case 9:
		 		setState(240)
		 		try codeBlock()

		 		break
		 	case 10:
		 		setState(241)
		 		try match(MxsParser.Tokens.Semicolon.rawValue)

		 		break
		 	default: break
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class CodeBlockContext: ParserRuleContext {
			open
			func LeftBr() -> TerminalNode? {
				return getToken(MxsParser.Tokens.LeftBr.rawValue, 0)
			}
			open
			func RightBr() -> TerminalNode? {
				return getToken(MxsParser.Tokens.RightBr.rawValue, 0)
			}
			open
			func sentence() -> [SentenceContext] {
				return getRuleContexts(SentenceContext.self)
			}
			open
			func sentence(_ i: Int) -> SentenceContext? {
				return getRuleContext(SentenceContext.self, i)
			}
		override open
		func getRuleIndex() -> Int {
			return MxsParser.RULE_codeBlock
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.enterCodeBlock(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.exitCodeBlock(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MxsVisitor {
			    return visitor.visitCodeBlock(self)
			}
			else if let visitor = visitor as? MxsBaseVisitor {
			    return visitor.visitCodeBlock(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func codeBlock() throws -> CodeBlockContext {
		var _localctx: CodeBlockContext = CodeBlockContext(_ctx, getState())
		try enterRule(_localctx, 32, MxsParser.RULE_codeBlock)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(244)
		 	try match(MxsParser.Tokens.LeftBr.rawValue)
		 	setState(248)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, MxsParser.Tokens.T__0.rawValue,MxsParser.Tokens.T__7.rawValue,MxsParser.Tokens.T__9.rawValue,MxsParser.Tokens.T__12.rawValue,MxsParser.Tokens.Bool.rawValue,MxsParser.Tokens.Int.rawValue,MxsParser.Tokens.String.rawValue,MxsParser.Tokens.Void.rawValue,MxsParser.Tokens.If.rawValue,MxsParser.Tokens.For.rawValue,MxsParser.Tokens.While.rawValue,MxsParser.Tokens.Break.rawValue,MxsParser.Tokens.Continue.rawValue,MxsParser.Tokens.Return.rawValue,MxsParser.Tokens.New.rawValue,MxsParser.Tokens.This.rawValue,MxsParser.Tokens.StringLiteral.rawValue,MxsParser.Tokens.BoolLiteral.rawValue,MxsParser.Tokens.NullLiteral.rawValue,MxsParser.Tokens.IntLiteral.rawValue,MxsParser.Tokens.Add.rawValue,MxsParser.Tokens.Sub.rawValue,MxsParser.Tokens.Negation.rawValue,MxsParser.Tokens.Bitwise.rawValue,MxsParser.Tokens.SelfAdd.rawValue,MxsParser.Tokens.SelfSub.rawValue,MxsParser.Tokens.LeftBr.rawValue,MxsParser.Tokens.Semicolon.rawValue,MxsParser.Tokens.Identifier.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	      return testSet
		 	 }()) {
		 		setState(245)
		 		try sentence()


		 		setState(250)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 	}
		 	setState(251)
		 	try match(MxsParser.Tokens.RightBr.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class EmptySetContext: ParserRuleContext {
		override open
		func getRuleIndex() -> Int {
			return MxsParser.RULE_emptySet
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.enterEmptySet(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.exitEmptySet(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MxsVisitor {
			    return visitor.visitEmptySet(self)
			}
			else if let visitor = visitor as? MxsBaseVisitor {
			    return visitor.visitEmptySet(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func emptySet() throws -> EmptySetContext {
		var _localctx: EmptySetContext = EmptySetContext(_ctx, getState())
		try enterRule(_localctx, 34, MxsParser.RULE_emptySet)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(253)
		 	try match(MxsParser.Tokens.T__10.rawValue)
		 	setState(254)
		 	try match(MxsParser.Tokens.T__11.rawValue)


		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class TypeContext: ParserRuleContext {
			open
			func Bool() -> TerminalNode? {
				return getToken(MxsParser.Tokens.Bool.rawValue, 0)
			}
			open
			func Int() -> TerminalNode? {
				return getToken(MxsParser.Tokens.Int.rawValue, 0)
			}
			open
			func String() -> TerminalNode? {
				return getToken(MxsParser.Tokens.String.rawValue, 0)
			}
			open
			func Void() -> TerminalNode? {
				return getToken(MxsParser.Tokens.Void.rawValue, 0)
			}
			open
			func Identifier() -> TerminalNode? {
				return getToken(MxsParser.Tokens.Identifier.rawValue, 0)
			}
			open
			func emptySet() -> [EmptySetContext] {
				return getRuleContexts(EmptySetContext.self)
			}
			open
			func emptySet(_ i: Int) -> EmptySetContext? {
				return getRuleContext(EmptySetContext.self, i)
			}
		override open
		func getRuleIndex() -> Int {
			return MxsParser.RULE_type
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.enterType(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.exitType(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MxsVisitor {
			    return visitor.visitType(self)
			}
			else if let visitor = visitor as? MxsBaseVisitor {
			    return visitor.visitType(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func type() throws -> TypeContext {
		var _localctx: TypeContext = TypeContext(_ctx, getState())
		try enterRule(_localctx, 36, MxsParser.RULE_type)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(256)
		 	_la = try _input.LA(1)
		 	if (!(//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, MxsParser.Tokens.Bool.rawValue,MxsParser.Tokens.Int.rawValue,MxsParser.Tokens.String.rawValue,MxsParser.Tokens.Void.rawValue,MxsParser.Tokens.Identifier.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	      return testSet
		 	 }())) {
		 	try _errHandler.recoverInline(self)
		 	}
		 	else {
		 		_errHandler.reportMatch(self)
		 		try consume()
		 	}
		 	setState(260)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == MxsParser.Tokens.T__10.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(257)
		 		try emptySet()


		 		setState(262)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class FunctionExpressionContext: ParserRuleContext {
			open
			func Identifier() -> TerminalNode? {
				return getToken(MxsParser.Tokens.Identifier.rawValue, 0)
			}
			open
			func expression() -> [ExpressionContext] {
				return getRuleContexts(ExpressionContext.self)
			}
			open
			func expression(_ i: Int) -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, i)
			}
		override open
		func getRuleIndex() -> Int {
			return MxsParser.RULE_functionExpression
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.enterFunctionExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.exitFunctionExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MxsVisitor {
			    return visitor.visitFunctionExpression(self)
			}
			else if let visitor = visitor as? MxsBaseVisitor {
			    return visitor.visitFunctionExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func functionExpression() throws -> FunctionExpressionContext {
		var _localctx: FunctionExpressionContext = FunctionExpressionContext(_ctx, getState())
		try enterRule(_localctx, 38, MxsParser.RULE_functionExpression)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	setState(291)
		 	try _errHandler.sync(self)
		 	switch (MxsParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .Identifier:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(263)
		 		try match(MxsParser.Tokens.Identifier.rawValue)
		 		setState(264)
		 		try match(MxsParser.Tokens.T__0.rawValue)
		 		setState(274)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = {  () -> Bool in
		 		   let testArray: [Int] = [_la, MxsParser.Tokens.T__0.rawValue,MxsParser.Tokens.T__12.rawValue,MxsParser.Tokens.New.rawValue,MxsParser.Tokens.This.rawValue,MxsParser.Tokens.StringLiteral.rawValue,MxsParser.Tokens.BoolLiteral.rawValue,MxsParser.Tokens.NullLiteral.rawValue,MxsParser.Tokens.IntLiteral.rawValue,MxsParser.Tokens.Add.rawValue,MxsParser.Tokens.Sub.rawValue,MxsParser.Tokens.Negation.rawValue,MxsParser.Tokens.Bitwise.rawValue,MxsParser.Tokens.SelfAdd.rawValue,MxsParser.Tokens.SelfSub.rawValue,MxsParser.Tokens.Identifier.rawValue]
		 		    return  Utils.testBitLeftShiftArray(testArray, 0)
		 		}()
		 		      return testSet
		 		 }()) {
		 			setState(270)
		 			try _errHandler.sync(self)
		 			_alt = try getInterpreter().adaptivePredict(_input,27,_ctx)
		 			while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 				if ( _alt==1 ) {
		 					setState(265)
		 					try expression(0)
		 					setState(266)
		 					try match(MxsParser.Tokens.T__1.rawValue)

		 			 
		 				}
		 				setState(272)
		 				try _errHandler.sync(self)
		 				_alt = try getInterpreter().adaptivePredict(_input,27,_ctx)
		 			}
		 			setState(273)
		 			try expression(0)

		 		}

		 		setState(276)
		 		try match(MxsParser.Tokens.T__2.rawValue)

		 		break

		 	case .T__12:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(277)
		 		try match(MxsParser.Tokens.T__12.rawValue)
		 		setState(278)
		 		try match(MxsParser.Tokens.Identifier.rawValue)
		 		setState(289)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,30,_ctx)) {
		 		case 1:
		 			setState(279)
		 			try match(MxsParser.Tokens.T__5.rawValue)
		 			setState(285)
		 			try _errHandler.sync(self)
		 			_alt = try getInterpreter().adaptivePredict(_input,29,_ctx)
		 			while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 				if ( _alt==1 ) {
		 					setState(280)
		 					try expression(0)
		 					setState(281)
		 					try match(MxsParser.Tokens.T__1.rawValue)

		 			 
		 				}
		 				setState(287)
		 				try _errHandler.sync(self)
		 				_alt = try getInterpreter().adaptivePredict(_input,29,_ctx)
		 			}
		 			setState(288)
		 			try expression(0)

		 			break
		 		default: break
		 		}

		 		break
		 	default:
		 		throw ANTLRException.recognition(e: NoViableAltException(self))
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class NewIndexContext: ParserRuleContext {
			open
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return MxsParser.RULE_newIndex
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.enterNewIndex(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.exitNewIndex(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MxsVisitor {
			    return visitor.visitNewIndex(self)
			}
			else if let visitor = visitor as? MxsBaseVisitor {
			    return visitor.visitNewIndex(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func newIndex() throws -> NewIndexContext {
		var _localctx: NewIndexContext = NewIndexContext(_ctx, getState())
		try enterRule(_localctx, 40, MxsParser.RULE_newIndex)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(293)
		 	try match(MxsParser.Tokens.T__10.rawValue)
		 	setState(295)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, MxsParser.Tokens.T__0.rawValue,MxsParser.Tokens.T__12.rawValue,MxsParser.Tokens.New.rawValue,MxsParser.Tokens.This.rawValue,MxsParser.Tokens.StringLiteral.rawValue,MxsParser.Tokens.BoolLiteral.rawValue,MxsParser.Tokens.NullLiteral.rawValue,MxsParser.Tokens.IntLiteral.rawValue,MxsParser.Tokens.Add.rawValue,MxsParser.Tokens.Sub.rawValue,MxsParser.Tokens.Negation.rawValue,MxsParser.Tokens.Bitwise.rawValue,MxsParser.Tokens.SelfAdd.rawValue,MxsParser.Tokens.SelfSub.rawValue,MxsParser.Tokens.Identifier.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	      return testSet
		 	 }()) {
		 		setState(294)
		 		try expression(0)

		 	}

		 	setState(297)
		 	try match(MxsParser.Tokens.T__11.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}


	public class ExpressionContext: ParserRuleContext {
		override open
		func getRuleIndex() -> Int {
			return MxsParser.RULE_expression
		}
	}
	public class NewExprContext: ExpressionContext {
		public var ty: Token!
			open
			func New() -> TerminalNode? {
				return getToken(MxsParser.Tokens.New.rawValue, 0)
			}
			open
			func Bool() -> TerminalNode? {
				return getToken(MxsParser.Tokens.Bool.rawValue, 0)
			}
			open
			func Int() -> TerminalNode? {
				return getToken(MxsParser.Tokens.Int.rawValue, 0)
			}
			open
			func String() -> TerminalNode? {
				return getToken(MxsParser.Tokens.String.rawValue, 0)
			}
			open
			func Void() -> TerminalNode? {
				return getToken(MxsParser.Tokens.Void.rawValue, 0)
			}
			open
			func Identifier() -> TerminalNode? {
				return getToken(MxsParser.Tokens.Identifier.rawValue, 0)
			}
			open
			func newIndex() -> [NewIndexContext] {
				return getRuleContexts(NewIndexContext.self)
			}
			open
			func newIndex(_ i: Int) -> NewIndexContext? {
				return getRuleContext(NewIndexContext.self, i)
			}

		public
		init(_ ctx: ExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.enterNewExpr(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.exitNewExpr(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MxsVisitor {
			    return visitor.visitNewExpr(self)
			}
			else if let visitor = visitor as? MxsBaseVisitor {
			    return visitor.visitNewExpr(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class InstExprContext: ExpressionContext {
			open
			func New() -> TerminalNode? {
				return getToken(MxsParser.Tokens.New.rawValue, 0)
			}
			open
			func Identifier() -> TerminalNode? {
				return getToken(MxsParser.Tokens.Identifier.rawValue, 0)
			}

		public
		init(_ ctx: ExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.enterInstExpr(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.exitInstExpr(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MxsVisitor {
			    return visitor.visitInstExpr(self)
			}
			else if let visitor = visitor as? MxsBaseVisitor {
			    return visitor.visitInstExpr(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class FuncExprContext: ExpressionContext {
			open
			func functionExpression() -> FunctionExpressionContext? {
				return getRuleContext(FunctionExpressionContext.self, 0)
			}

		public
		init(_ ctx: ExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.enterFuncExpr(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.exitFuncExpr(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MxsVisitor {
			    return visitor.visitFuncExpr(self)
			}
			else if let visitor = visitor as? MxsBaseVisitor {
			    return visitor.visitFuncExpr(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class UnaryExprContext: ExpressionContext {
		public var op: Token!
			open
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}
			open
			func SelfAdd() -> TerminalNode? {
				return getToken(MxsParser.Tokens.SelfAdd.rawValue, 0)
			}
			open
			func SelfSub() -> TerminalNode? {
				return getToken(MxsParser.Tokens.SelfSub.rawValue, 0)
			}
			open
			func Add() -> TerminalNode? {
				return getToken(MxsParser.Tokens.Add.rawValue, 0)
			}
			open
			func Sub() -> TerminalNode? {
				return getToken(MxsParser.Tokens.Sub.rawValue, 0)
			}
			open
			func Negation() -> TerminalNode? {
				return getToken(MxsParser.Tokens.Negation.rawValue, 0)
			}
			open
			func Bitwise() -> TerminalNode? {
				return getToken(MxsParser.Tokens.Bitwise.rawValue, 0)
			}

		public
		init(_ ctx: ExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.enterUnaryExpr(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.exitUnaryExpr(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MxsVisitor {
			    return visitor.visitUnaryExpr(self)
			}
			else if let visitor = visitor as? MxsBaseVisitor {
			    return visitor.visitUnaryExpr(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class ArrayExprContext: ExpressionContext {
		public var array: ExpressionContext!
		public var op: Token!
		public var idx: ExpressionContext!
			open
			func expression() -> [ExpressionContext] {
				return getRuleContexts(ExpressionContext.self)
			}
			open
			func expression(_ i: Int) -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, i)
			}

		public
		init(_ ctx: ExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.enterArrayExpr(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.exitArrayExpr(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MxsVisitor {
			    return visitor.visitArrayExpr(self)
			}
			else if let visitor = visitor as? MxsBaseVisitor {
			    return visitor.visitArrayExpr(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class ParaExprContext: ExpressionContext {
		public var op: Token!
			open
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}

		public
		init(_ ctx: ExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.enterParaExpr(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.exitParaExpr(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MxsVisitor {
			    return visitor.visitParaExpr(self)
			}
			else if let visitor = visitor as? MxsBaseVisitor {
			    return visitor.visitParaExpr(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class LiteralExprContext: ExpressionContext {
			open
			func This() -> TerminalNode? {
				return getToken(MxsParser.Tokens.This.rawValue, 0)
			}
			open
			func BoolLiteral() -> TerminalNode? {
				return getToken(MxsParser.Tokens.BoolLiteral.rawValue, 0)
			}
			open
			func IntLiteral() -> TerminalNode? {
				return getToken(MxsParser.Tokens.IntLiteral.rawValue, 0)
			}
			open
			func StringLiteral() -> TerminalNode? {
				return getToken(MxsParser.Tokens.StringLiteral.rawValue, 0)
			}
			open
			func NullLiteral() -> TerminalNode? {
				return getToken(MxsParser.Tokens.NullLiteral.rawValue, 0)
			}

		public
		init(_ ctx: ExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.enterLiteralExpr(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.exitLiteralExpr(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MxsVisitor {
			    return visitor.visitLiteralExpr(self)
			}
			else if let visitor = visitor as? MxsBaseVisitor {
			    return visitor.visitLiteralExpr(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class MemberExprContext: ExpressionContext {
		public var op: Token!
			open
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}
			open
			func Identifier() -> TerminalNode? {
				return getToken(MxsParser.Tokens.Identifier.rawValue, 0)
			}
			open
			func This() -> TerminalNode? {
				return getToken(MxsParser.Tokens.This.rawValue, 0)
			}
			open
			func functionExpression() -> FunctionExpressionContext? {
				return getRuleContext(FunctionExpressionContext.self, 0)
			}

		public
		init(_ ctx: ExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.enterMemberExpr(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.exitMemberExpr(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MxsVisitor {
			    return visitor.visitMemberExpr(self)
			}
			else if let visitor = visitor as? MxsBaseVisitor {
			    return visitor.visitMemberExpr(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class BinaryExprContext: ExpressionContext {
		public var op: Token!
			open
			func expression() -> [ExpressionContext] {
				return getRuleContexts(ExpressionContext.self)
			}
			open
			func expression(_ i: Int) -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, i)
			}
			open
			func Mul() -> TerminalNode? {
				return getToken(MxsParser.Tokens.Mul.rawValue, 0)
			}
			open
			func Div() -> TerminalNode? {
				return getToken(MxsParser.Tokens.Div.rawValue, 0)
			}
			open
			func Mod() -> TerminalNode? {
				return getToken(MxsParser.Tokens.Mod.rawValue, 0)
			}
			open
			func Add() -> TerminalNode? {
				return getToken(MxsParser.Tokens.Add.rawValue, 0)
			}
			open
			func Sub() -> TerminalNode? {
				return getToken(MxsParser.Tokens.Sub.rawValue, 0)
			}
			open
			func RightShift() -> TerminalNode? {
				return getToken(MxsParser.Tokens.RightShift.rawValue, 0)
			}
			open
			func LeftShift() -> TerminalNode? {
				return getToken(MxsParser.Tokens.LeftShift.rawValue, 0)
			}
			open
			func Greater() -> TerminalNode? {
				return getToken(MxsParser.Tokens.Greater.rawValue, 0)
			}
			open
			func GreaterEq() -> TerminalNode? {
				return getToken(MxsParser.Tokens.GreaterEq.rawValue, 0)
			}
			open
			func Less() -> TerminalNode? {
				return getToken(MxsParser.Tokens.Less.rawValue, 0)
			}
			open
			func LessEq() -> TerminalNode? {
				return getToken(MxsParser.Tokens.LessEq.rawValue, 0)
			}
			open
			func Equal() -> TerminalNode? {
				return getToken(MxsParser.Tokens.Equal.rawValue, 0)
			}
			open
			func Inequal() -> TerminalNode? {
				return getToken(MxsParser.Tokens.Inequal.rawValue, 0)
			}
			open
			func BitAnd() -> TerminalNode? {
				return getToken(MxsParser.Tokens.BitAnd.rawValue, 0)
			}
			open
			func BitXor() -> TerminalNode? {
				return getToken(MxsParser.Tokens.BitXor.rawValue, 0)
			}
			open
			func BitOr() -> TerminalNode? {
				return getToken(MxsParser.Tokens.BitOr.rawValue, 0)
			}
			open
			func LogicAnd() -> TerminalNode? {
				return getToken(MxsParser.Tokens.LogicAnd.rawValue, 0)
			}
			open
			func LogicOr() -> TerminalNode? {
				return getToken(MxsParser.Tokens.LogicOr.rawValue, 0)
			}

		public
		init(_ ctx: ExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.enterBinaryExpr(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.exitBinaryExpr(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MxsVisitor {
			    return visitor.visitBinaryExpr(self)
			}
			else if let visitor = visitor as? MxsBaseVisitor {
			    return visitor.visitBinaryExpr(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class SufExprContext: ExpressionContext {
		public var op: Token!
			open
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}
			open
			func SelfAdd() -> TerminalNode? {
				return getToken(MxsParser.Tokens.SelfAdd.rawValue, 0)
			}
			open
			func SelfSub() -> TerminalNode? {
				return getToken(MxsParser.Tokens.SelfSub.rawValue, 0)
			}

		public
		init(_ ctx: ExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.enterSufExpr(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.exitSufExpr(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MxsVisitor {
			    return visitor.visitSufExpr(self)
			}
			else if let visitor = visitor as? MxsBaseVisitor {
			    return visitor.visitSufExpr(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class AssignExprContext: ExpressionContext {
		public var op: Token!
			open
			func expression() -> [ExpressionContext] {
				return getRuleContexts(ExpressionContext.self)
			}
			open
			func expression(_ i: Int) -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, i)
			}
			open
			func Assign() -> TerminalNode? {
				return getToken(MxsParser.Tokens.Assign.rawValue, 0)
			}

		public
		init(_ ctx: ExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.enterAssignExpr(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.exitAssignExpr(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MxsVisitor {
			    return visitor.visitAssignExpr(self)
			}
			else if let visitor = visitor as? MxsBaseVisitor {
			    return visitor.visitAssignExpr(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class IdExprContext: ExpressionContext {
			open
			func Identifier() -> TerminalNode? {
				return getToken(MxsParser.Tokens.Identifier.rawValue, 0)
			}

		public
		init(_ ctx: ExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.enterIdExpr(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.exitIdExpr(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MxsVisitor {
			    return visitor.visitIdExpr(self)
			}
			else if let visitor = visitor as? MxsBaseVisitor {
			    return visitor.visitIdExpr(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}

	 public final  func expression( ) throws -> ExpressionContext   {
		return try expression(0)
	}
	@discardableResult
	private func expression(_ _p: Int) throws -> ExpressionContext   {
		let _parentctx: ParserRuleContext? = _ctx
		var _parentState: Int = getState()
		var _localctx: ExpressionContext = ExpressionContext(_ctx, _parentState)
		var  _prevctx: ExpressionContext = _localctx
		var _startState: Int = 42
		try enterRecursionRule(_localctx, 42, MxsParser.RULE_expression, _p)
		var _la: Int = 0
		defer {
	    		try! unrollRecursionContexts(_parentctx)
	    }
		do {
			var _alt: Int
			try enterOuterAlt(_localctx, 1)
			setState(322)
			try _errHandler.sync(self)
			switch(try getInterpreter().adaptivePredict(_input,35, _ctx)) {
			case 1:
				_localctx = IdExprContext(_localctx)
				_ctx = _localctx
				_prevctx = _localctx

				setState(300)
				try match(MxsParser.Tokens.Identifier.rawValue)

				break
			case 2:
				_localctx = LiteralExprContext(_localctx)
				_ctx = _localctx
				_prevctx = _localctx
				setState(301)
				_la = try _input.LA(1)
				if (!(//closure
				 { () -> Bool in
				      let testSet: Bool = {  () -> Bool in
				   let testArray: [Int] = [_la, MxsParser.Tokens.This.rawValue,MxsParser.Tokens.StringLiteral.rawValue,MxsParser.Tokens.BoolLiteral.rawValue,MxsParser.Tokens.NullLiteral.rawValue,MxsParser.Tokens.IntLiteral.rawValue]
				    return  Utils.testBitLeftShiftArray(testArray, 0)
				}()
				      return testSet
				 }())) {
				try _errHandler.recoverInline(self)
				}
				else {
					_errHandler.reportMatch(self)
					try consume()
				}

				break
			case 3:
				_localctx = ParaExprContext(_localctx)
				_ctx = _localctx
				_prevctx = _localctx
				setState(302)
				try {
						let assignmentValue = try match(MxsParser.Tokens.T__0.rawValue)
						_localctx.castdown(ParaExprContext.self).op = assignmentValue
				     }()

				setState(303)
				try expression(0)
				setState(304)
				try match(MxsParser.Tokens.T__2.rawValue)

				break
			case 4:
				_localctx = FuncExprContext(_localctx)
				_ctx = _localctx
				_prevctx = _localctx
				setState(306)
				try functionExpression()

				break
			case 5:
				_localctx = NewExprContext(_localctx)
				_ctx = _localctx
				_prevctx = _localctx
				setState(307)
				try match(MxsParser.Tokens.New.rawValue)
				setState(308)
				_localctx.castdown(NewExprContext.self).ty = try _input.LT(1)
				_la = try _input.LA(1)
				if (!(//closure
				 { () -> Bool in
				      let testSet: Bool = {  () -> Bool in
				   let testArray: [Int] = [_la, MxsParser.Tokens.Bool.rawValue,MxsParser.Tokens.Int.rawValue,MxsParser.Tokens.String.rawValue,MxsParser.Tokens.Void.rawValue,MxsParser.Tokens.Identifier.rawValue]
				    return  Utils.testBitLeftShiftArray(testArray, 0)
				}()
				      return testSet
				 }())) {
					_localctx.castdown(NewExprContext.self).ty = try _errHandler.recoverInline(self) as Token
				}
				else {
					_errHandler.reportMatch(self)
					try consume()
				}
				setState(310); 
				try _errHandler.sync(self)
				_alt = 1;
				repeat {
					switch (_alt) {
					case 1:
						setState(309)
						try newIndex()


						break
					default:
						throw ANTLRException.recognition(e: NoViableAltException(self))
					}
					setState(312); 
					try _errHandler.sync(self)
					_alt = try getInterpreter().adaptivePredict(_input,33,_ctx)
				} while (_alt != 2 && _alt !=  ATN.INVALID_ALT_NUMBER)

				break
			case 6:
				_localctx = UnaryExprContext(_localctx)
				_ctx = _localctx
				_prevctx = _localctx
				setState(314)
				_localctx.castdown(UnaryExprContext.self).op = try _input.LT(1)
				_la = try _input.LA(1)
				if (!(//closure
				 { () -> Bool in
				      let testSet: Bool = {  () -> Bool in
				   let testArray: [Int] = [_la, MxsParser.Tokens.Add.rawValue,MxsParser.Tokens.Sub.rawValue,MxsParser.Tokens.Negation.rawValue,MxsParser.Tokens.Bitwise.rawValue,MxsParser.Tokens.SelfAdd.rawValue,MxsParser.Tokens.SelfSub.rawValue]
				    return  Utils.testBitLeftShiftArray(testArray, 0)
				}()
				      return testSet
				 }())) {
					_localctx.castdown(UnaryExprContext.self).op = try _errHandler.recoverInline(self) as Token
				}
				else {
					_errHandler.reportMatch(self)
					try consume()
				}
				setState(315)
				try expression(13)

				break
			case 7:
				_localctx = InstExprContext(_localctx)
				_ctx = _localctx
				_prevctx = _localctx
				setState(316)
				try match(MxsParser.Tokens.New.rawValue)
				setState(317)
				try match(MxsParser.Tokens.Identifier.rawValue)
				setState(320)
				try _errHandler.sync(self)
				switch (try getInterpreter().adaptivePredict(_input,34,_ctx)) {
				case 1:
					setState(318)
					try match(MxsParser.Tokens.T__0.rawValue)
					setState(319)
					try match(MxsParser.Tokens.T__2.rawValue)

					break
				default: break
				}

				break
			default: break
			}
			_ctx!.stop = try _input.LT(-1)
			setState(373)
			try _errHandler.sync(self)
			_alt = try getInterpreter().adaptivePredict(_input,38,_ctx)
			while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
				if ( _alt==1 ) {
					if _parseListeners != nil {
					   try triggerExitRuleEvent()
					}
					_prevctx = _localctx
					setState(371)
					try _errHandler.sync(self)
					switch(try getInterpreter().adaptivePredict(_input,37, _ctx)) {
					case 1:
						_localctx = BinaryExprContext(  ExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, MxsParser.RULE_expression)
						setState(324)
						if (!(precpred(_ctx, 11))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 11)"))
						}
						setState(325)
						_localctx.castdown(BinaryExprContext.self).op = try _input.LT(1)
						_la = try _input.LA(1)
						if (!(//closure
						 { () -> Bool in
						      let testSet: Bool = {  () -> Bool in
						   let testArray: [Int] = [_la, MxsParser.Tokens.Mul.rawValue,MxsParser.Tokens.Div.rawValue,MxsParser.Tokens.Mod.rawValue]
						    return  Utils.testBitLeftShiftArray(testArray, 0)
						}()
						      return testSet
						 }())) {
							_localctx.castdown(BinaryExprContext.self).op = try _errHandler.recoverInline(self) as Token
						}
						else {
							_errHandler.reportMatch(self)
							try consume()
						}
						setState(326)
						try expression(12)

						break
					case 2:
						_localctx = BinaryExprContext(  ExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, MxsParser.RULE_expression)
						setState(327)
						if (!(precpred(_ctx, 10))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 10)"))
						}
						setState(328)
						_localctx.castdown(BinaryExprContext.self).op = try _input.LT(1)
						_la = try _input.LA(1)
						if (!(//closure
						 { () -> Bool in
						      let testSet: Bool = _la == MxsParser.Tokens.Add.rawValue || _la == MxsParser.Tokens.Sub.rawValue
						      return testSet
						 }())) {
							_localctx.castdown(BinaryExprContext.self).op = try _errHandler.recoverInline(self) as Token
						}
						else {
							_errHandler.reportMatch(self)
							try consume()
						}
						setState(329)
						try expression(11)

						break
					case 3:
						_localctx = BinaryExprContext(  ExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, MxsParser.RULE_expression)
						setState(330)
						if (!(precpred(_ctx, 9))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 9)"))
						}
						setState(331)
						_localctx.castdown(BinaryExprContext.self).op = try _input.LT(1)
						_la = try _input.LA(1)
						if (!(//closure
						 { () -> Bool in
						      let testSet: Bool = _la == MxsParser.Tokens.RightShift.rawValue || _la == MxsParser.Tokens.LeftShift.rawValue
						      return testSet
						 }())) {
							_localctx.castdown(BinaryExprContext.self).op = try _errHandler.recoverInline(self) as Token
						}
						else {
							_errHandler.reportMatch(self)
							try consume()
						}
						setState(332)
						try expression(10)

						break
					case 4:
						_localctx = BinaryExprContext(  ExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, MxsParser.RULE_expression)
						setState(333)
						if (!(precpred(_ctx, 8))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 8)"))
						}
						setState(334)
						_localctx.castdown(BinaryExprContext.self).op = try _input.LT(1)
						_la = try _input.LA(1)
						if (!(//closure
						 { () -> Bool in
						      let testSet: Bool = {  () -> Bool in
						   let testArray: [Int] = [_la, MxsParser.Tokens.GreaterEq.rawValue,MxsParser.Tokens.LessEq.rawValue,MxsParser.Tokens.Greater.rawValue,MxsParser.Tokens.Less.rawValue]
						    return  Utils.testBitLeftShiftArray(testArray, 0)
						}()
						      return testSet
						 }())) {
							_localctx.castdown(BinaryExprContext.self).op = try _errHandler.recoverInline(self) as Token
						}
						else {
							_errHandler.reportMatch(self)
							try consume()
						}
						setState(335)
						try expression(9)

						break
					case 5:
						_localctx = BinaryExprContext(  ExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, MxsParser.RULE_expression)
						setState(336)
						if (!(precpred(_ctx, 7))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 7)"))
						}
						setState(337)
						_localctx.castdown(BinaryExprContext.self).op = try _input.LT(1)
						_la = try _input.LA(1)
						if (!(//closure
						 { () -> Bool in
						      let testSet: Bool = _la == MxsParser.Tokens.Equal.rawValue || _la == MxsParser.Tokens.Inequal.rawValue
						      return testSet
						 }())) {
							_localctx.castdown(BinaryExprContext.self).op = try _errHandler.recoverInline(self) as Token
						}
						else {
							_errHandler.reportMatch(self)
							try consume()
						}
						setState(338)
						try expression(8)

						break
					case 6:
						_localctx = BinaryExprContext(  ExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, MxsParser.RULE_expression)
						setState(339)
						if (!(precpred(_ctx, 6))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 6)"))
						}
						setState(340)
						try {
								let assignmentValue = try match(MxsParser.Tokens.BitAnd.rawValue)
								_localctx.castdown(BinaryExprContext.self).op = assignmentValue
						     }()

						setState(341)
						try expression(7)

						break
					case 7:
						_localctx = BinaryExprContext(  ExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, MxsParser.RULE_expression)
						setState(342)
						if (!(precpred(_ctx, 5))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 5)"))
						}
						setState(343)
						try {
								let assignmentValue = try match(MxsParser.Tokens.BitXor.rawValue)
								_localctx.castdown(BinaryExprContext.self).op = assignmentValue
						     }()

						setState(344)
						try expression(6)

						break
					case 8:
						_localctx = BinaryExprContext(  ExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, MxsParser.RULE_expression)
						setState(345)
						if (!(precpred(_ctx, 4))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 4)"))
						}
						setState(346)
						try {
								let assignmentValue = try match(MxsParser.Tokens.BitOr.rawValue)
								_localctx.castdown(BinaryExprContext.self).op = assignmentValue
						     }()

						setState(347)
						try expression(5)

						break
					case 9:
						_localctx = BinaryExprContext(  ExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, MxsParser.RULE_expression)
						setState(348)
						if (!(precpred(_ctx, 3))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 3)"))
						}
						setState(349)
						try {
								let assignmentValue = try match(MxsParser.Tokens.LogicAnd.rawValue)
								_localctx.castdown(BinaryExprContext.self).op = assignmentValue
						     }()

						setState(350)
						try expression(4)

						break
					case 10:
						_localctx = BinaryExprContext(  ExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, MxsParser.RULE_expression)
						setState(351)
						if (!(precpred(_ctx, 2))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 2)"))
						}
						setState(352)
						try {
								let assignmentValue = try match(MxsParser.Tokens.LogicOr.rawValue)
								_localctx.castdown(BinaryExprContext.self).op = assignmentValue
						     }()

						setState(353)
						try expression(3)

						break
					case 11:
						_localctx = AssignExprContext(  ExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, MxsParser.RULE_expression)
						setState(354)
						if (!(precpred(_ctx, 1))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 1)"))
						}
						setState(355)
						try {
								let assignmentValue = try match(MxsParser.Tokens.Assign.rawValue)
								_localctx.castdown(AssignExprContext.self).op = assignmentValue
						     }()

						setState(356)
						try expression(1)

						break
					case 12:
						_localctx = MemberExprContext(  ExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, MxsParser.RULE_expression)
						setState(357)
						if (!(precpred(_ctx, 18))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 18)"))
						}
						setState(358)
						try {
								let assignmentValue = try match(MxsParser.Tokens.T__13.rawValue)
								_localctx.castdown(MemberExprContext.self).op = assignmentValue
						     }()

						setState(362)
						try _errHandler.sync(self)
						switch(try getInterpreter().adaptivePredict(_input,36, _ctx)) {
						case 1:
							setState(359)
							try match(MxsParser.Tokens.Identifier.rawValue)

							break
						case 2:
							setState(360)
							try match(MxsParser.Tokens.This.rawValue)

							break
						case 3:
							setState(361)
							try functionExpression()

							break
						default: break
						}

						break
					case 13:
						_localctx = ArrayExprContext(  ExpressionContext(_parentctx, _parentState))
						(_localctx as! ArrayExprContext).array = _prevctx
						try pushNewRecursionContext(_localctx, _startState, MxsParser.RULE_expression)
						setState(364)
						if (!(precpred(_ctx, 17))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 17)"))
						}
						setState(365)
						try {
								let assignmentValue = try match(MxsParser.Tokens.T__10.rawValue)
								_localctx.castdown(ArrayExprContext.self).op = assignmentValue
						     }()

						setState(366)
						try {
								let assignmentValue = try expression(0)
								_localctx.castdown(ArrayExprContext.self).idx = assignmentValue
						     }()

						setState(367)
						try match(MxsParser.Tokens.T__11.rawValue)

						break
					case 14:
						_localctx = SufExprContext(  ExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, MxsParser.RULE_expression)
						setState(369)
						if (!(precpred(_ctx, 14))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 14)"))
						}
						setState(370)
						_localctx.castdown(SufExprContext.self).op = try _input.LT(1)
						_la = try _input.LA(1)
						if (!(//closure
						 { () -> Bool in
						      let testSet: Bool = _la == MxsParser.Tokens.SelfAdd.rawValue || _la == MxsParser.Tokens.SelfSub.rawValue
						      return testSet
						 }())) {
							_localctx.castdown(SufExprContext.self).op = try _errHandler.recoverInline(self) as Token
						}
						else {
							_errHandler.reportMatch(self)
							try consume()
						}

						break
					default: break
					}
			 
				}
				setState(375)
				try _errHandler.sync(self)
				_alt = try getInterpreter().adaptivePredict(_input,38,_ctx)
			}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx;
	}

	override open
	func sempred(_ _localctx: RuleContext?, _ ruleIndex: Int,  _ predIndex: Int)throws -> Bool {
		switch (ruleIndex) {
		case  21:
			return try expression_sempred(_localctx?.castdown(ExpressionContext.self), predIndex)
	    default: return true
		}
	}
	private func expression_sempred(_ _localctx: ExpressionContext!,  _ predIndex: Int) throws -> Bool {
		switch (predIndex) {
		    case 0:return precpred(_ctx, 11)
		    case 1:return precpred(_ctx, 10)
		    case 2:return precpred(_ctx, 9)
		    case 3:return precpred(_ctx, 8)
		    case 4:return precpred(_ctx, 7)
		    case 5:return precpred(_ctx, 6)
		    case 6:return precpred(_ctx, 5)
		    case 7:return precpred(_ctx, 4)
		    case 8:return precpred(_ctx, 3)
		    case 9:return precpred(_ctx, 2)
		    case 10:return precpred(_ctx, 1)
		    case 11:return precpred(_ctx, 18)
		    case 12:return precpred(_ctx, 17)
		    case 13:return precpred(_ctx, 14)
		    default: return true
		}
	}


	public
	static let _serializedATN = MxsParserATN().jsonString

	public
	static let _ATN = ATNDeserializer().deserializeFromJson(_serializedATN)
}