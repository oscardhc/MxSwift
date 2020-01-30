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
                 T__6 = 7, T__7 = 8, T__8 = 9, T__9 = 10, Bool = 11, Int = 12, 
                 String = 13, Void = 14, If = 15, Else = 16, For = 17, While = 18, 
                 Break = 19, Continue = 20, Return = 21, New = 22, Class = 23, 
                 This = 24, BoolLiteral = 25, IntLiteral = 26, StringLiteral = 27, 
                 NullLiteral = 28, Mul = 29, Div = 30, Add = 31, Sub = 32, 
                 Mod = 33, Negation = 34, Bitwise = 35, SelfAdd = 36, SelfSub = 37, 
                 RightShift = 38, LeftShift = 39, GreaterEq = 40, LessEq = 41, 
                 Greater = 42, Less = 43, Equal = 44, Inequal = 45, BitAnd = 46, 
                 BitOr = 47, BitXor = 48, LogicAnd = 49, LogicOr = 50, Identifier = 51, 
                 Whitespace = 52, Newline = 53, BlockComment = 54, LineComment = 55
	}

	public
	static let RULE_declarations = 0, RULE_functionDeclaration = 1, RULE_parameterList = 2, 
            RULE_variableDeclaration = 3, RULE_classDeclaration = 4, RULE_declarationSentence = 5, 
            RULE_ifSentence = 6, RULE_whileSentence = 7, RULE_forSentence = 8, 
            RULE_returnSentence = 9, RULE_breakSentence = 10, RULE_continueSentence = 11, 
            RULE_expressionSentence = 12, RULE_sentence = 13, RULE_codeBlock = 14, 
            RULE_type = 15, RULE_argumentList = 16, RULE_functionExpression = 17, 
            RULE_expression = 18

	public
	static let ruleNames: [String] = [
		"declarations", "functionDeclaration", "parameterList", "variableDeclaration", 
		"classDeclaration", "declarationSentence", "ifSentence", "whileSentence", 
		"forSentence", "returnSentence", "breakSentence", "continueSentence", 
		"expressionSentence", "sentence", "codeBlock", "type", "argumentList", 
		"functionExpression", "expression"
	]

	private static let _LITERAL_NAMES: [String?] = [
		nil, "';'", "'('", "')'", "','", "'='", "'{'", "'}'", "'['", "']'", "'.'", 
		"'bool'", "'int'", "'string'", "'void'", "'if'", "'else'", "'for'", "'while'", 
		"'break'", "'continue'", "'return'", "'new'", "'class'", "'this'", nil, 
		nil, nil, "'null'", "'*'", "'/'", "'+'", "'-'", "'%'", "'!'", "'~'", "'++'", 
		"'--'", "'>>'", "'<<'", "'>='", "'<='", "'>'", "'<'", "'=='", "'!='", 
		"'&'", "'|'", "'^'", "'&&'", "'||'"
	]
	private static let _SYMBOLIC_NAMES: [String?] = [
		nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "Bool", "Int", 
		"String", "Void", "If", "Else", "For", "While", "Break", "Continue", "Return", 
		"New", "Class", "This", "BoolLiteral", "IntLiteral", "StringLiteral", 
		"NullLiteral", "Mul", "Div", "Add", "Sub", "Mod", "Negation", "Bitwise", 
		"SelfAdd", "SelfSub", "RightShift", "LeftShift", "GreaterEq", "LessEq", 
		"Greater", "Less", "Equal", "Inequal", "BitAnd", "BitOr", "BitXor", "LogicAnd", 
		"LogicOr", "Identifier", "Whitespace", "Newline", "BlockComment", "LineComment"
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
			func functionDeclaration() -> [FunctionDeclarationContext] {
				return getRuleContexts(FunctionDeclarationContext.self)
			}
			open
			func functionDeclaration(_ i: Int) -> FunctionDeclarationContext? {
				return getRuleContext(FunctionDeclarationContext.self, i)
			}
			open
			func classDeclaration() -> [ClassDeclarationContext] {
				return getRuleContexts(ClassDeclarationContext.self)
			}
			open
			func classDeclaration(_ i: Int) -> ClassDeclarationContext? {
				return getRuleContext(ClassDeclarationContext.self, i)
			}
			open
			func variableDeclaration() -> [VariableDeclarationContext] {
				return getRuleContexts(VariableDeclarationContext.self)
			}
			open
			func variableDeclaration(_ i: Int) -> VariableDeclarationContext? {
				return getRuleContext(VariableDeclarationContext.self, i)
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
		 	setState(49)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, MxsParser.Tokens.Bool.rawValue,MxsParser.Tokens.Int.rawValue,MxsParser.Tokens.String.rawValue,MxsParser.Tokens.Void.rawValue,MxsParser.Tokens.Class.rawValue,MxsParser.Tokens.Identifier.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	      return testSet
		 	 }()) {
		 		setState(45)
		 		try _errHandler.sync(self)
		 		switch(try getInterpreter().adaptivePredict(_input,0, _ctx)) {
		 		case 1:
		 			setState(38)
		 			try functionDeclaration()

		 			break
		 		case 2:
		 			setState(39)
		 			try variableDeclaration()
		 			setState(40)
		 			try match(MxsParser.Tokens.T__0.rawValue)


		 			break
		 		case 3:
		 			setState(42)
		 			try classDeclaration()
		 			setState(43)
		 			try match(MxsParser.Tokens.T__0.rawValue)

		 			break
		 		default: break
		 		}


		 		setState(51)
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

	public class FunctionDeclarationContext: ParserRuleContext {
			open
			func type() -> TypeContext? {
				return getRuleContext(TypeContext.self, 0)
			}
			open
			func Identifier() -> TerminalNode? {
				return getToken(MxsParser.Tokens.Identifier.rawValue, 0)
			}
			open
			func codeBlock() -> CodeBlockContext? {
				return getRuleContext(CodeBlockContext.self, 0)
			}
			open
			func parameterList() -> ParameterListContext? {
				return getRuleContext(ParameterListContext.self, 0)
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
	}
	@discardableResult
	 open func functionDeclaration() throws -> FunctionDeclarationContext {
		var _localctx: FunctionDeclarationContext = FunctionDeclarationContext(_ctx, getState())
		try enterRule(_localctx, 2, MxsParser.RULE_functionDeclaration)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(52)
		 	try type()
		 	setState(53)
		 	try match(MxsParser.Tokens.Identifier.rawValue)
		 	setState(54)
		 	try match(MxsParser.Tokens.T__1.rawValue)
		 	setState(56)
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
		 		setState(55)
		 		try parameterList()

		 	}

		 	setState(58)
		 	try match(MxsParser.Tokens.T__2.rawValue)
		 	setState(59)
		 	try codeBlock()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ParameterListContext: ParserRuleContext {
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
		override open
		func getRuleIndex() -> Int {
			return MxsParser.RULE_parameterList
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.enterParameterList(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.exitParameterList(self)
			}
		}
	}
	@discardableResult
	 open func parameterList() throws -> ParameterListContext {
		var _localctx: ParameterListContext = ParameterListContext(_ctx, getState())
		try enterRule(_localctx, 4, MxsParser.RULE_parameterList)
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	try enterOuterAlt(_localctx, 1)
		 	setState(67)
		 	try _errHandler.sync(self)
		 	_alt = try getInterpreter().adaptivePredict(_input,3,_ctx)
		 	while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 		if ( _alt==1 ) {
		 			setState(61)
		 			try type()
		 			setState(62)
		 			try match(MxsParser.Tokens.Identifier.rawValue)
		 			setState(63)
		 			try match(MxsParser.Tokens.T__3.rawValue)

		 	 
		 		}
		 		setState(69)
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,3,_ctx)
		 	}
		 	setState(70)
		 	try type()
		 	setState(71)
		 	try match(MxsParser.Tokens.Identifier.rawValue)

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
			func Identifier() -> [TerminalNode] {
				return getTokens(MxsParser.Tokens.Identifier.rawValue)
			}
			open
			func Identifier(_ i:Int) -> TerminalNode? {
				return getToken(MxsParser.Tokens.Identifier.rawValue, i)
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
	}
	@discardableResult
	 open func variableDeclaration() throws -> VariableDeclarationContext {
		var _localctx: VariableDeclarationContext = VariableDeclarationContext(_ctx, getState())
		try enterRule(_localctx, 6, MxsParser.RULE_variableDeclaration)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	try enterOuterAlt(_localctx, 1)
		 	setState(73)
		 	try type()
		 	setState(82)
		 	try _errHandler.sync(self)
		 	_alt = try getInterpreter().adaptivePredict(_input,5,_ctx)
		 	while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 		if ( _alt==1 ) {
		 			setState(74)
		 			try match(MxsParser.Tokens.Identifier.rawValue)
		 			setState(77)
		 			try _errHandler.sync(self)
		 			_la = try _input.LA(1)
		 			if (//closure
		 			 { () -> Bool in
		 			      let testSet: Bool = _la == MxsParser.Tokens.T__4.rawValue
		 			      return testSet
		 			 }()) {
		 				setState(75)
		 				try match(MxsParser.Tokens.T__4.rawValue)
		 				setState(76)
		 				try expression(0)

		 			}

		 			setState(79)
		 			try match(MxsParser.Tokens.T__3.rawValue)

		 	 
		 		}
		 		setState(84)
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,5,_ctx)
		 	}
		 	setState(85)
		 	try match(MxsParser.Tokens.Identifier.rawValue)
		 	setState(88)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == MxsParser.Tokens.T__4.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(86)
		 		try match(MxsParser.Tokens.T__4.rawValue)
		 		setState(87)
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
			func functionDeclaration() -> [FunctionDeclarationContext] {
				return getRuleContexts(FunctionDeclarationContext.self)
			}
			open
			func functionDeclaration(_ i: Int) -> FunctionDeclarationContext? {
				return getRuleContext(FunctionDeclarationContext.self, i)
			}
			open
			func variableDeclaration() -> [VariableDeclarationContext] {
				return getRuleContexts(VariableDeclarationContext.self)
			}
			open
			func variableDeclaration(_ i: Int) -> VariableDeclarationContext? {
				return getRuleContext(VariableDeclarationContext.self, i)
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
	}
	@discardableResult
	 open func classDeclaration() throws -> ClassDeclarationContext {
		var _localctx: ClassDeclarationContext = ClassDeclarationContext(_ctx, getState())
		try enterRule(_localctx, 8, MxsParser.RULE_classDeclaration)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(90)
		 	try match(MxsParser.Tokens.Class.rawValue)
		 	setState(91)
		 	try match(MxsParser.Tokens.Identifier.rawValue)
		 	setState(92)
		 	try match(MxsParser.Tokens.T__5.rawValue)
		 	setState(99)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, MxsParser.Tokens.Bool.rawValue,MxsParser.Tokens.Int.rawValue,MxsParser.Tokens.String.rawValue,MxsParser.Tokens.Void.rawValue,MxsParser.Tokens.Identifier.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	      return testSet
		 	 }()) {
		 		setState(97)
		 		try _errHandler.sync(self)
		 		switch(try getInterpreter().adaptivePredict(_input,7, _ctx)) {
		 		case 1:
		 			setState(93)
		 			try variableDeclaration()
		 			setState(94)
		 			try match(MxsParser.Tokens.T__0.rawValue)


		 			break
		 		case 2:
		 			setState(96)
		 			try functionDeclaration()

		 			break
		 		default: break
		 		}

		 		setState(101)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 	}
		 	setState(102)
		 	try match(MxsParser.Tokens.T__6.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class DeclarationSentenceContext: ParserRuleContext {
			open
			func variableDeclaration() -> VariableDeclarationContext? {
				return getRuleContext(VariableDeclarationContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return MxsParser.RULE_declarationSentence
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.enterDeclarationSentence(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.exitDeclarationSentence(self)
			}
		}
	}
	@discardableResult
	 open func declarationSentence() throws -> DeclarationSentenceContext {
		var _localctx: DeclarationSentenceContext = DeclarationSentenceContext(_ctx, getState())
		try enterRule(_localctx, 10, MxsParser.RULE_declarationSentence)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(104)
		 	try variableDeclaration()
		 	setState(105)
		 	try match(MxsParser.Tokens.T__0.rawValue)

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
			func If() -> [TerminalNode] {
				return getTokens(MxsParser.Tokens.If.rawValue)
			}
			open
			func If(_ i:Int) -> TerminalNode? {
				return getToken(MxsParser.Tokens.If.rawValue, i)
			}
			open
			func expression() -> [ExpressionContext] {
				return getRuleContexts(ExpressionContext.self)
			}
			open
			func expression(_ i: Int) -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, i)
			}
			open
			func codeBlock() -> [CodeBlockContext] {
				return getRuleContexts(CodeBlockContext.self)
			}
			open
			func codeBlock(_ i: Int) -> CodeBlockContext? {
				return getRuleContext(CodeBlockContext.self, i)
			}
			open
			func Else() -> [TerminalNode] {
				return getTokens(MxsParser.Tokens.Else.rawValue)
			}
			open
			func Else(_ i:Int) -> TerminalNode? {
				return getToken(MxsParser.Tokens.Else.rawValue, i)
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
	}
	@discardableResult
	 open func ifSentence() throws -> IfSentenceContext {
		var _localctx: IfSentenceContext = IfSentenceContext(_ctx, getState())
		try enterRule(_localctx, 12, MxsParser.RULE_ifSentence)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(107)
		 	try match(MxsParser.Tokens.If.rawValue)
		 	setState(108)
		 	try match(MxsParser.Tokens.T__1.rawValue)
		 	setState(109)
		 	try expression(0)
		 	setState(110)
		 	try match(MxsParser.Tokens.T__2.rawValue)
		 	setState(111)
		 	try codeBlock()
		 	setState(119)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,9,_ctx)) {
		 	case 1:
		 		setState(112)
		 		try match(MxsParser.Tokens.Else.rawValue)
		 		setState(113)
		 		try match(MxsParser.Tokens.If.rawValue)
		 		setState(114)
		 		try match(MxsParser.Tokens.T__1.rawValue)
		 		setState(115)
		 		try expression(0)
		 		setState(116)
		 		try match(MxsParser.Tokens.T__2.rawValue)
		 		setState(117)
		 		try codeBlock()

		 		break
		 	default: break
		 	}
		 	setState(123)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,10,_ctx)) {
		 	case 1:
		 		setState(121)
		 		try match(MxsParser.Tokens.Else.rawValue)
		 		setState(122)
		 		try codeBlock()

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
			func codeBlock() -> CodeBlockContext? {
				return getRuleContext(CodeBlockContext.self, 0)
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
	}
	@discardableResult
	 open func whileSentence() throws -> WhileSentenceContext {
		var _localctx: WhileSentenceContext = WhileSentenceContext(_ctx, getState())
		try enterRule(_localctx, 14, MxsParser.RULE_whileSentence)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(125)
		 	try match(MxsParser.Tokens.While.rawValue)
		 	setState(126)
		 	try match(MxsParser.Tokens.T__1.rawValue)
		 	setState(127)
		 	try expression(0)
		 	setState(128)
		 	try match(MxsParser.Tokens.T__2.rawValue)
		 	setState(129)
		 	try codeBlock()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ForSentenceContext: ParserRuleContext {
			open
			func For() -> TerminalNode? {
				return getToken(MxsParser.Tokens.For.rawValue, 0)
			}
			open
			func codeBlock() -> CodeBlockContext? {
				return getRuleContext(CodeBlockContext.self, 0)
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
	}
	@discardableResult
	 open func forSentence() throws -> ForSentenceContext {
		var _localctx: ForSentenceContext = ForSentenceContext(_ctx, getState())
		try enterRule(_localctx, 16, MxsParser.RULE_forSentence)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(131)
		 	try match(MxsParser.Tokens.For.rawValue)
		 	setState(132)
		 	try match(MxsParser.Tokens.T__1.rawValue)
		 	setState(134)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, MxsParser.Tokens.T__1.rawValue,MxsParser.Tokens.New.rawValue,MxsParser.Tokens.This.rawValue,MxsParser.Tokens.BoolLiteral.rawValue,MxsParser.Tokens.IntLiteral.rawValue,MxsParser.Tokens.StringLiteral.rawValue,MxsParser.Tokens.NullLiteral.rawValue,MxsParser.Tokens.Add.rawValue,MxsParser.Tokens.Sub.rawValue,MxsParser.Tokens.Negation.rawValue,MxsParser.Tokens.Bitwise.rawValue,MxsParser.Tokens.SelfAdd.rawValue,MxsParser.Tokens.SelfSub.rawValue,MxsParser.Tokens.Identifier.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	      return testSet
		 	 }()) {
		 		setState(133)
		 		try expression(0)

		 	}

		 	setState(136)
		 	try match(MxsParser.Tokens.T__0.rawValue)
		 	setState(138)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, MxsParser.Tokens.T__1.rawValue,MxsParser.Tokens.New.rawValue,MxsParser.Tokens.This.rawValue,MxsParser.Tokens.BoolLiteral.rawValue,MxsParser.Tokens.IntLiteral.rawValue,MxsParser.Tokens.StringLiteral.rawValue,MxsParser.Tokens.NullLiteral.rawValue,MxsParser.Tokens.Add.rawValue,MxsParser.Tokens.Sub.rawValue,MxsParser.Tokens.Negation.rawValue,MxsParser.Tokens.Bitwise.rawValue,MxsParser.Tokens.SelfAdd.rawValue,MxsParser.Tokens.SelfSub.rawValue,MxsParser.Tokens.Identifier.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	      return testSet
		 	 }()) {
		 		setState(137)
		 		try expression(0)

		 	}

		 	setState(140)
		 	try match(MxsParser.Tokens.T__0.rawValue)
		 	setState(142)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, MxsParser.Tokens.T__1.rawValue,MxsParser.Tokens.New.rawValue,MxsParser.Tokens.This.rawValue,MxsParser.Tokens.BoolLiteral.rawValue,MxsParser.Tokens.IntLiteral.rawValue,MxsParser.Tokens.StringLiteral.rawValue,MxsParser.Tokens.NullLiteral.rawValue,MxsParser.Tokens.Add.rawValue,MxsParser.Tokens.Sub.rawValue,MxsParser.Tokens.Negation.rawValue,MxsParser.Tokens.Bitwise.rawValue,MxsParser.Tokens.SelfAdd.rawValue,MxsParser.Tokens.SelfSub.rawValue,MxsParser.Tokens.Identifier.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	      return testSet
		 	 }()) {
		 		setState(141)
		 		try expression(0)

		 	}

		 	setState(144)
		 	try match(MxsParser.Tokens.T__2.rawValue)
		 	setState(145)
		 	try codeBlock()

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
	}
	@discardableResult
	 open func returnSentence() throws -> ReturnSentenceContext {
		var _localctx: ReturnSentenceContext = ReturnSentenceContext(_ctx, getState())
		try enterRule(_localctx, 18, MxsParser.RULE_returnSentence)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(147)
		 	try match(MxsParser.Tokens.Return.rawValue)
		 	setState(149)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, MxsParser.Tokens.T__1.rawValue,MxsParser.Tokens.New.rawValue,MxsParser.Tokens.This.rawValue,MxsParser.Tokens.BoolLiteral.rawValue,MxsParser.Tokens.IntLiteral.rawValue,MxsParser.Tokens.StringLiteral.rawValue,MxsParser.Tokens.NullLiteral.rawValue,MxsParser.Tokens.Add.rawValue,MxsParser.Tokens.Sub.rawValue,MxsParser.Tokens.Negation.rawValue,MxsParser.Tokens.Bitwise.rawValue,MxsParser.Tokens.SelfAdd.rawValue,MxsParser.Tokens.SelfSub.rawValue,MxsParser.Tokens.Identifier.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	      return testSet
		 	 }()) {
		 		setState(148)
		 		try expression(0)

		 	}

		 	setState(151)
		 	try match(MxsParser.Tokens.T__0.rawValue)

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
	}
	@discardableResult
	 open func breakSentence() throws -> BreakSentenceContext {
		var _localctx: BreakSentenceContext = BreakSentenceContext(_ctx, getState())
		try enterRule(_localctx, 20, MxsParser.RULE_breakSentence)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(153)
		 	try match(MxsParser.Tokens.Break.rawValue)
		 	setState(154)
		 	try match(MxsParser.Tokens.T__0.rawValue)

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
	}
	@discardableResult
	 open func continueSentence() throws -> ContinueSentenceContext {
		var _localctx: ContinueSentenceContext = ContinueSentenceContext(_ctx, getState())
		try enterRule(_localctx, 22, MxsParser.RULE_continueSentence)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(156)
		 	try match(MxsParser.Tokens.Continue.rawValue)
		 	setState(157)
		 	try match(MxsParser.Tokens.T__0.rawValue)

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
	}
	@discardableResult
	 open func expressionSentence() throws -> ExpressionSentenceContext {
		var _localctx: ExpressionSentenceContext = ExpressionSentenceContext(_ctx, getState())
		try enterRule(_localctx, 24, MxsParser.RULE_expressionSentence)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(159)
		 	try expression(0)
		 	setState(160)
		 	try match(MxsParser.Tokens.T__0.rawValue)

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
			func declarationSentence() -> DeclarationSentenceContext? {
				return getRuleContext(DeclarationSentenceContext.self, 0)
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
	}
	@discardableResult
	 open func sentence() throws -> SentenceContext {
		var _localctx: SentenceContext = SentenceContext(_ctx, getState())
		try enterRule(_localctx, 26, MxsParser.RULE_sentence)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(170)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,15, _ctx)) {
		 	case 1:
		 		setState(162)
		 		try declarationSentence()

		 		break
		 	case 2:
		 		setState(163)
		 		try ifSentence()

		 		break
		 	case 3:
		 		setState(164)
		 		try whileSentence()

		 		break
		 	case 4:
		 		setState(165)
		 		try forSentence()

		 		break
		 	case 5:
		 		setState(166)
		 		try returnSentence()

		 		break
		 	case 6:
		 		setState(167)
		 		try breakSentence()

		 		break
		 	case 7:
		 		setState(168)
		 		try continueSentence()

		 		break
		 	case 8:
		 		setState(169)
		 		try expressionSentence()

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
	}
	@discardableResult
	 open func codeBlock() throws -> CodeBlockContext {
		var _localctx: CodeBlockContext = CodeBlockContext(_ctx, getState())
		try enterRule(_localctx, 28, MxsParser.RULE_codeBlock)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(181)
		 	try _errHandler.sync(self)
		 	switch (MxsParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .T__5:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(172)
		 		try match(MxsParser.Tokens.T__5.rawValue)
		 		setState(176)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		while (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = {  () -> Bool in
		 		   let testArray: [Int] = [_la, MxsParser.Tokens.T__1.rawValue,MxsParser.Tokens.Bool.rawValue,MxsParser.Tokens.Int.rawValue,MxsParser.Tokens.String.rawValue,MxsParser.Tokens.Void.rawValue,MxsParser.Tokens.If.rawValue,MxsParser.Tokens.For.rawValue,MxsParser.Tokens.While.rawValue,MxsParser.Tokens.Break.rawValue,MxsParser.Tokens.Continue.rawValue,MxsParser.Tokens.Return.rawValue,MxsParser.Tokens.New.rawValue,MxsParser.Tokens.This.rawValue,MxsParser.Tokens.BoolLiteral.rawValue,MxsParser.Tokens.IntLiteral.rawValue,MxsParser.Tokens.StringLiteral.rawValue,MxsParser.Tokens.NullLiteral.rawValue,MxsParser.Tokens.Add.rawValue,MxsParser.Tokens.Sub.rawValue,MxsParser.Tokens.Negation.rawValue,MxsParser.Tokens.Bitwise.rawValue,MxsParser.Tokens.SelfAdd.rawValue,MxsParser.Tokens.SelfSub.rawValue,MxsParser.Tokens.Identifier.rawValue]
		 		    return  Utils.testBitLeftShiftArray(testArray, 0)
		 		}()
		 		      return testSet
		 		 }()) {
		 			setState(173)
		 			try sentence()


		 			setState(178)
		 			try _errHandler.sync(self)
		 			_la = try _input.LA(1)
		 		}
		 		setState(179)
		 		try match(MxsParser.Tokens.T__6.rawValue)

		 		break
		 	case .T__1:fallthrough
		 	case .Bool:fallthrough
		 	case .Int:fallthrough
		 	case .String:fallthrough
		 	case .Void:fallthrough
		 	case .If:fallthrough
		 	case .For:fallthrough
		 	case .While:fallthrough
		 	case .Break:fallthrough
		 	case .Continue:fallthrough
		 	case .Return:fallthrough
		 	case .New:fallthrough
		 	case .This:fallthrough
		 	case .BoolLiteral:fallthrough
		 	case .IntLiteral:fallthrough
		 	case .StringLiteral:fallthrough
		 	case .NullLiteral:fallthrough
		 	case .Add:fallthrough
		 	case .Sub:fallthrough
		 	case .Negation:fallthrough
		 	case .Bitwise:fallthrough
		 	case .SelfAdd:fallthrough
		 	case .SelfSub:fallthrough
		 	case .Identifier:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(180)
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
			func expression() -> [ExpressionContext] {
				return getRuleContexts(ExpressionContext.self)
			}
			open
			func expression(_ i: Int) -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, i)
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
	}
	@discardableResult
	 open func type() throws -> TypeContext {
		var _localctx: TypeContext = TypeContext(_ctx, getState())
		try enterRule(_localctx, 30, MxsParser.RULE_type)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(183)
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
		 	setState(191)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == MxsParser.Tokens.T__7.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(184)
		 		try match(MxsParser.Tokens.T__7.rawValue)
		 		setState(186)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = {  () -> Bool in
		 		   let testArray: [Int] = [_la, MxsParser.Tokens.T__1.rawValue,MxsParser.Tokens.New.rawValue,MxsParser.Tokens.This.rawValue,MxsParser.Tokens.BoolLiteral.rawValue,MxsParser.Tokens.IntLiteral.rawValue,MxsParser.Tokens.StringLiteral.rawValue,MxsParser.Tokens.NullLiteral.rawValue,MxsParser.Tokens.Add.rawValue,MxsParser.Tokens.Sub.rawValue,MxsParser.Tokens.Negation.rawValue,MxsParser.Tokens.Bitwise.rawValue,MxsParser.Tokens.SelfAdd.rawValue,MxsParser.Tokens.SelfSub.rawValue,MxsParser.Tokens.Identifier.rawValue]
		 		    return  Utils.testBitLeftShiftArray(testArray, 0)
		 		}()
		 		      return testSet
		 		 }()) {
		 			setState(185)
		 			try expression(0)

		 		}

		 		setState(188)
		 		try match(MxsParser.Tokens.T__8.rawValue)


		 		setState(193)
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


	public class ArgumentListContext: ParserRuleContext {
			open
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}
			open
			func argumentList() -> ArgumentListContext? {
				return getRuleContext(ArgumentListContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return MxsParser.RULE_argumentList
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.enterArgumentList(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.exitArgumentList(self)
			}
		}
	}

	 public final  func argumentList( ) throws -> ArgumentListContext   {
		return try argumentList(0)
	}
	@discardableResult
	private func argumentList(_ _p: Int) throws -> ArgumentListContext   {
		let _parentctx: ParserRuleContext? = _ctx
		var _parentState: Int = getState()
		var _localctx: ArgumentListContext = ArgumentListContext(_ctx, _parentState)
		var  _prevctx: ArgumentListContext = _localctx
		var _startState: Int = 32
		try enterRecursionRule(_localctx, 32, MxsParser.RULE_argumentList, _p)
		defer {
	    		try! unrollRecursionContexts(_parentctx)
	    }
		do {
			var _alt: Int
			try enterOuterAlt(_localctx, 1)
			setState(195)
			try expression(0)

			_ctx!.stop = try _input.LT(-1)
			setState(202)
			try _errHandler.sync(self)
			_alt = try getInterpreter().adaptivePredict(_input,20,_ctx)
			while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
				if ( _alt==1 ) {
					if _parseListeners != nil {
					   try triggerExitRuleEvent()
					}
					_prevctx = _localctx
					_localctx = ArgumentListContext(_parentctx, _parentState);
					try pushNewRecursionContext(_localctx, _startState, MxsParser.RULE_argumentList)
					setState(197)
					if (!(precpred(_ctx, 1))) {
					    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 1)"))
					}
					setState(198)
					try match(MxsParser.Tokens.T__3.rawValue)
					setState(199)
					try expression(0)

			 
				}
				setState(204)
				try _errHandler.sync(self)
				_alt = try getInterpreter().adaptivePredict(_input,20,_ctx)
			}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx;
	}

	public class FunctionExpressionContext: ParserRuleContext {
			open
			func Identifier() -> TerminalNode? {
				return getToken(MxsParser.Tokens.Identifier.rawValue, 0)
			}
			open
			func argumentList() -> ArgumentListContext? {
				return getRuleContext(ArgumentListContext.self, 0)
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
	}
	@discardableResult
	 open func functionExpression() throws -> FunctionExpressionContext {
		var _localctx: FunctionExpressionContext = FunctionExpressionContext(_ctx, getState())
		try enterRule(_localctx, 34, MxsParser.RULE_functionExpression)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(205)
		 	try match(MxsParser.Tokens.Identifier.rawValue)
		 	setState(206)
		 	try match(MxsParser.Tokens.T__1.rawValue)
		 	setState(208)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, MxsParser.Tokens.T__1.rawValue,MxsParser.Tokens.New.rawValue,MxsParser.Tokens.This.rawValue,MxsParser.Tokens.BoolLiteral.rawValue,MxsParser.Tokens.IntLiteral.rawValue,MxsParser.Tokens.StringLiteral.rawValue,MxsParser.Tokens.NullLiteral.rawValue,MxsParser.Tokens.Add.rawValue,MxsParser.Tokens.Sub.rawValue,MxsParser.Tokens.Negation.rawValue,MxsParser.Tokens.Bitwise.rawValue,MxsParser.Tokens.SelfAdd.rawValue,MxsParser.Tokens.SelfSub.rawValue,MxsParser.Tokens.Identifier.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	      return testSet
		 	 }()) {
		 		setState(207)
		 		try argumentList(0)

		 	}

		 	setState(210)
		 	try match(MxsParser.Tokens.T__2.rawValue)

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
		public var op: Token!
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
				listener.enterNewExpr(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.exitNewExpr(self)
			}
		}
	}
	public class SingleExprContext: ExpressionContext {
		public var op: Token!
			open
			func Identifier() -> TerminalNode? {
				return getToken(MxsParser.Tokens.Identifier.rawValue, 0)
			}
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
			open
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
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
				listener.enterSingleExpr(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MxsListener {
				listener.exitSingleExpr(self)
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
	}
	public class ArrayExprContext: ExpressionContext {
		public var op: Token!
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
		var _startState: Int = 36
		try enterRecursionRule(_localctx, 36, MxsParser.RULE_expression, _p)
		var _la: Int = 0
		defer {
	    		try! unrollRecursionContexts(_parentctx)
	    }
		do {
			var _alt: Int
			try enterOuterAlt(_localctx, 1)
			setState(233)
			try _errHandler.sync(self)
			switch(try getInterpreter().adaptivePredict(_input,24, _ctx)) {
			case 1:
				_localctx = SingleExprContext(_localctx)
				_ctx = _localctx
				_prevctx = _localctx

				setState(213)
				try match(MxsParser.Tokens.Identifier.rawValue)

				break
			case 2:
				_localctx = SingleExprContext(_localctx)
				_ctx = _localctx
				_prevctx = _localctx
				setState(214)
				_la = try _input.LA(1)
				if (!(//closure
				 { () -> Bool in
				      let testSet: Bool = {  () -> Bool in
				   let testArray: [Int] = [_la, MxsParser.Tokens.This.rawValue,MxsParser.Tokens.BoolLiteral.rawValue,MxsParser.Tokens.IntLiteral.rawValue,MxsParser.Tokens.StringLiteral.rawValue,MxsParser.Tokens.NullLiteral.rawValue]
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
				_localctx = SingleExprContext(_localctx)
				_ctx = _localctx
				_prevctx = _localctx
				setState(215)
				try {
						let assignmentValue = try match(MxsParser.Tokens.T__1.rawValue)
						_localctx.castdown(SingleExprContext.self).op = assignmentValue
				     }()

				setState(216)
				try expression(0)
				setState(217)
				try match(MxsParser.Tokens.T__2.rawValue)

				break
			case 4:
				_localctx = FuncExprContext(_localctx)
				_ctx = _localctx
				_prevctx = _localctx
				setState(219)
				try functionExpression()

				break
			case 5:
				_localctx = UnaryExprContext(_localctx)
				_ctx = _localctx
				_prevctx = _localctx
				setState(220)
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
				setState(221)
				try expression(13)

				break
			case 6:
				_localctx = NewExprContext(_localctx)
				_ctx = _localctx
				_prevctx = _localctx
				setState(222)
				try match(MxsParser.Tokens.New.rawValue)
				setState(223)
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
				setState(229); 
				try _errHandler.sync(self)
				_alt = 1;
				repeat {
					switch (_alt) {
					case 1:
						setState(224)
						try {
								let assignmentValue = try match(MxsParser.Tokens.T__7.rawValue)
								_localctx.castdown(NewExprContext.self).op = assignmentValue
						     }()

						setState(226)
						try _errHandler.sync(self)
						_la = try _input.LA(1)
						if (//closure
						 { () -> Bool in
						      let testSet: Bool = {  () -> Bool in
						   let testArray: [Int] = [_la, MxsParser.Tokens.T__1.rawValue,MxsParser.Tokens.New.rawValue,MxsParser.Tokens.This.rawValue,MxsParser.Tokens.BoolLiteral.rawValue,MxsParser.Tokens.IntLiteral.rawValue,MxsParser.Tokens.StringLiteral.rawValue,MxsParser.Tokens.NullLiteral.rawValue,MxsParser.Tokens.Add.rawValue,MxsParser.Tokens.Sub.rawValue,MxsParser.Tokens.Negation.rawValue,MxsParser.Tokens.Bitwise.rawValue,MxsParser.Tokens.SelfAdd.rawValue,MxsParser.Tokens.SelfSub.rawValue,MxsParser.Tokens.Identifier.rawValue]
						    return  Utils.testBitLeftShiftArray(testArray, 0)
						}()
						      return testSet
						 }()) {
							setState(225)
							try expression(0)

						}

						setState(228)
						try match(MxsParser.Tokens.T__8.rawValue)


						break
					default:
						throw ANTLRException.recognition(e: NoViableAltException(self))
					}
					setState(231); 
					try _errHandler.sync(self)
					_alt = try getInterpreter().adaptivePredict(_input,23,_ctx)
				} while (_alt != 2 && _alt !=  ATN.INVALID_ALT_NUMBER)

				break
			default: break
			}
			_ctx!.stop = try _input.LT(-1)
			setState(283)
			try _errHandler.sync(self)
			_alt = try getInterpreter().adaptivePredict(_input,27,_ctx)
			while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
				if ( _alt==1 ) {
					if _parseListeners != nil {
					   try triggerExitRuleEvent()
					}
					_prevctx = _localctx
					setState(281)
					try _errHandler.sync(self)
					switch(try getInterpreter().adaptivePredict(_input,26, _ctx)) {
					case 1:
						_localctx = BinaryExprContext(  ExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, MxsParser.RULE_expression)
						setState(235)
						if (!(precpred(_ctx, 11))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 11)"))
						}
						setState(236)
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
						setState(237)
						try expression(12)

						break
					case 2:
						_localctx = BinaryExprContext(  ExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, MxsParser.RULE_expression)
						setState(238)
						if (!(precpred(_ctx, 10))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 10)"))
						}
						setState(239)
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
						setState(240)
						try expression(11)

						break
					case 3:
						_localctx = BinaryExprContext(  ExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, MxsParser.RULE_expression)
						setState(241)
						if (!(precpred(_ctx, 9))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 9)"))
						}
						setState(242)
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
						setState(243)
						try expression(10)

						break
					case 4:
						_localctx = BinaryExprContext(  ExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, MxsParser.RULE_expression)
						setState(244)
						if (!(precpred(_ctx, 8))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 8)"))
						}
						setState(245)
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
						setState(246)
						try expression(9)

						break
					case 5:
						_localctx = BinaryExprContext(  ExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, MxsParser.RULE_expression)
						setState(247)
						if (!(precpred(_ctx, 7))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 7)"))
						}
						setState(248)
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
						setState(249)
						try expression(8)

						break
					case 6:
						_localctx = BinaryExprContext(  ExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, MxsParser.RULE_expression)
						setState(250)
						if (!(precpred(_ctx, 6))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 6)"))
						}
						setState(251)
						try {
								let assignmentValue = try match(MxsParser.Tokens.BitAnd.rawValue)
								_localctx.castdown(BinaryExprContext.self).op = assignmentValue
						     }()

						setState(252)
						try expression(7)

						break
					case 7:
						_localctx = BinaryExprContext(  ExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, MxsParser.RULE_expression)
						setState(253)
						if (!(precpred(_ctx, 5))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 5)"))
						}
						setState(254)
						try {
								let assignmentValue = try match(MxsParser.Tokens.BitXor.rawValue)
								_localctx.castdown(BinaryExprContext.self).op = assignmentValue
						     }()

						setState(255)
						try expression(6)

						break
					case 8:
						_localctx = BinaryExprContext(  ExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, MxsParser.RULE_expression)
						setState(256)
						if (!(precpred(_ctx, 4))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 4)"))
						}
						setState(257)
						try {
								let assignmentValue = try match(MxsParser.Tokens.BitOr.rawValue)
								_localctx.castdown(BinaryExprContext.self).op = assignmentValue
						     }()

						setState(258)
						try expression(5)

						break
					case 9:
						_localctx = BinaryExprContext(  ExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, MxsParser.RULE_expression)
						setState(259)
						if (!(precpred(_ctx, 3))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 3)"))
						}
						setState(260)
						try {
								let assignmentValue = try match(MxsParser.Tokens.LogicAnd.rawValue)
								_localctx.castdown(BinaryExprContext.self).op = assignmentValue
						     }()

						setState(261)
						try expression(4)

						break
					case 10:
						_localctx = BinaryExprContext(  ExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, MxsParser.RULE_expression)
						setState(262)
						if (!(precpred(_ctx, 2))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 2)"))
						}
						setState(263)
						try {
								let assignmentValue = try match(MxsParser.Tokens.LogicOr.rawValue)
								_localctx.castdown(BinaryExprContext.self).op = assignmentValue
						     }()

						setState(264)
						try expression(3)

						break
					case 11:
						_localctx = AssignExprContext(  ExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, MxsParser.RULE_expression)
						setState(265)
						if (!(precpred(_ctx, 1))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 1)"))
						}
						setState(266)
						try {
								let assignmentValue = try match(MxsParser.Tokens.T__4.rawValue)
								_localctx.castdown(AssignExprContext.self).op = assignmentValue
						     }()

						setState(267)
						try expression(1)

						break
					case 12:
						_localctx = SingleExprContext(  ExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, MxsParser.RULE_expression)
						setState(268)
						if (!(precpred(_ctx, 17))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 17)"))
						}
						setState(269)
						try {
								let assignmentValue = try match(MxsParser.Tokens.T__9.rawValue)
								_localctx.castdown(SingleExprContext.self).op = assignmentValue
						     }()

						setState(272)
						try _errHandler.sync(self)
						switch(try getInterpreter().adaptivePredict(_input,25, _ctx)) {
						case 1:
							setState(270)
							try match(MxsParser.Tokens.Identifier.rawValue)

							break
						case 2:
							setState(271)
							try functionExpression()

							break
						default: break
						}

						break
					case 13:
						_localctx = ArrayExprContext(  ExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, MxsParser.RULE_expression)
						setState(274)
						if (!(precpred(_ctx, 16))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 16)"))
						}
						setState(275)
						try {
								let assignmentValue = try match(MxsParser.Tokens.T__7.rawValue)
								_localctx.castdown(ArrayExprContext.self).op = assignmentValue
						     }()

						setState(276)
						try expression(0)
						setState(277)
						try match(MxsParser.Tokens.T__8.rawValue)

						break
					case 14:
						_localctx = SufExprContext(  ExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, MxsParser.RULE_expression)
						setState(279)
						if (!(precpred(_ctx, 14))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 14)"))
						}
						setState(280)
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
				setState(285)
				try _errHandler.sync(self)
				_alt = try getInterpreter().adaptivePredict(_input,27,_ctx)
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
		case  16:
			return try argumentList_sempred(_localctx?.castdown(ArgumentListContext.self), predIndex)
		case  18:
			return try expression_sempred(_localctx?.castdown(ExpressionContext.self), predIndex)
	    default: return true
		}
	}
	private func argumentList_sempred(_ _localctx: ArgumentListContext!,  _ predIndex: Int) throws -> Bool {
		switch (predIndex) {
		    case 0:return precpred(_ctx, 1)
		    default: return true
		}
	}
	private func expression_sempred(_ _localctx: ExpressionContext!,  _ predIndex: Int) throws -> Bool {
		switch (predIndex) {
		    case 1:return precpred(_ctx, 11)
		    case 2:return precpred(_ctx, 10)
		    case 3:return precpred(_ctx, 9)
		    case 4:return precpred(_ctx, 8)
		    case 5:return precpred(_ctx, 7)
		    case 6:return precpred(_ctx, 6)
		    case 7:return precpred(_ctx, 5)
		    case 8:return precpred(_ctx, 4)
		    case 9:return precpred(_ctx, 3)
		    case 10:return precpred(_ctx, 2)
		    case 11:return precpred(_ctx, 1)
		    case 12:return precpred(_ctx, 17)
		    case 13:return precpred(_ctx, 16)
		    case 14:return precpred(_ctx, 14)
		    default: return true
		}
	}


	public
	static let _serializedATN = MxsParserATN().jsonString

	public
	static let _ATN = ATNDeserializer().deserializeFromJson(_serializedATN)
}