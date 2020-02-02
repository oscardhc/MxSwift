// Generated from Mxs.g4 by ANTLR 4.8
import Antlr4

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link MxsParser}.
 */
public protocol MxsListener: ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link MxsParser#declarations}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterDeclarations(_ ctx: MxsParser.DeclarationsContext)
	/**
	 * Exit a parse tree produced by {@link MxsParser#declarations}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitDeclarations(_ ctx: MxsParser.DeclarationsContext)
	/**
	 * Enter a parse tree produced by {@link MxsParser#declaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterDeclaration(_ ctx: MxsParser.DeclarationContext)
	/**
	 * Exit a parse tree produced by {@link MxsParser#declaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitDeclaration(_ ctx: MxsParser.DeclarationContext)
	/**
	 * Enter a parse tree produced by {@link MxsParser#functionDeclaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterFunctionDeclaration(_ ctx: MxsParser.FunctionDeclarationContext)
	/**
	 * Exit a parse tree produced by {@link MxsParser#functionDeclaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitFunctionDeclaration(_ ctx: MxsParser.FunctionDeclarationContext)
	/**
	 * Enter a parse tree produced by {@link MxsParser#initialDeclaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterInitialDeclaration(_ ctx: MxsParser.InitialDeclarationContext)
	/**
	 * Exit a parse tree produced by {@link MxsParser#initialDeclaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitInitialDeclaration(_ ctx: MxsParser.InitialDeclarationContext)
	/**
	 * Enter a parse tree produced by {@link MxsParser#variableDeclaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterVariableDeclaration(_ ctx: MxsParser.VariableDeclarationContext)
	/**
	 * Exit a parse tree produced by {@link MxsParser#variableDeclaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitVariableDeclaration(_ ctx: MxsParser.VariableDeclarationContext)
	/**
	 * Enter a parse tree produced by {@link MxsParser#classDeclaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterClassDeclaration(_ ctx: MxsParser.ClassDeclarationContext)
	/**
	 * Exit a parse tree produced by {@link MxsParser#classDeclaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitClassDeclaration(_ ctx: MxsParser.ClassDeclarationContext)
	/**
	 * Enter a parse tree produced by {@link MxsParser#declSentence}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterDeclSentence(_ ctx: MxsParser.DeclSentenceContext)
	/**
	 * Exit a parse tree produced by {@link MxsParser#declSentence}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitDeclSentence(_ ctx: MxsParser.DeclSentenceContext)
	/**
	 * Enter a parse tree produced by {@link MxsParser#ifSentence}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterIfSentence(_ ctx: MxsParser.IfSentenceContext)
	/**
	 * Exit a parse tree produced by {@link MxsParser#ifSentence}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitIfSentence(_ ctx: MxsParser.IfSentenceContext)
	/**
	 * Enter a parse tree produced by {@link MxsParser#whileSentence}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterWhileSentence(_ ctx: MxsParser.WhileSentenceContext)
	/**
	 * Exit a parse tree produced by {@link MxsParser#whileSentence}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitWhileSentence(_ ctx: MxsParser.WhileSentenceContext)
	/**
	 * Enter a parse tree produced by {@link MxsParser#forSentence}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterForSentence(_ ctx: MxsParser.ForSentenceContext)
	/**
	 * Exit a parse tree produced by {@link MxsParser#forSentence}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitForSentence(_ ctx: MxsParser.ForSentenceContext)
	/**
	 * Enter a parse tree produced by {@link MxsParser#returnSentence}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterReturnSentence(_ ctx: MxsParser.ReturnSentenceContext)
	/**
	 * Exit a parse tree produced by {@link MxsParser#returnSentence}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitReturnSentence(_ ctx: MxsParser.ReturnSentenceContext)
	/**
	 * Enter a parse tree produced by {@link MxsParser#breakSentence}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterBreakSentence(_ ctx: MxsParser.BreakSentenceContext)
	/**
	 * Exit a parse tree produced by {@link MxsParser#breakSentence}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitBreakSentence(_ ctx: MxsParser.BreakSentenceContext)
	/**
	 * Enter a parse tree produced by {@link MxsParser#continueSentence}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterContinueSentence(_ ctx: MxsParser.ContinueSentenceContext)
	/**
	 * Exit a parse tree produced by {@link MxsParser#continueSentence}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitContinueSentence(_ ctx: MxsParser.ContinueSentenceContext)
	/**
	 * Enter a parse tree produced by {@link MxsParser#expressionSentence}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterExpressionSentence(_ ctx: MxsParser.ExpressionSentenceContext)
	/**
	 * Exit a parse tree produced by {@link MxsParser#expressionSentence}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitExpressionSentence(_ ctx: MxsParser.ExpressionSentenceContext)
	/**
	 * Enter a parse tree produced by {@link MxsParser#sentence}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterSentence(_ ctx: MxsParser.SentenceContext)
	/**
	 * Exit a parse tree produced by {@link MxsParser#sentence}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitSentence(_ ctx: MxsParser.SentenceContext)
	/**
	 * Enter a parse tree produced by {@link MxsParser#codeBlock}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterCodeBlock(_ ctx: MxsParser.CodeBlockContext)
	/**
	 * Exit a parse tree produced by {@link MxsParser#codeBlock}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitCodeBlock(_ ctx: MxsParser.CodeBlockContext)
	/**
	 * Enter a parse tree produced by {@link MxsParser#emptySet}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterEmptySet(_ ctx: MxsParser.EmptySetContext)
	/**
	 * Exit a parse tree produced by {@link MxsParser#emptySet}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitEmptySet(_ ctx: MxsParser.EmptySetContext)
	/**
	 * Enter a parse tree produced by {@link MxsParser#type}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterType(_ ctx: MxsParser.TypeContext)
	/**
	 * Exit a parse tree produced by {@link MxsParser#type}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitType(_ ctx: MxsParser.TypeContext)
	/**
	 * Enter a parse tree produced by {@link MxsParser#functionExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterFunctionExpression(_ ctx: MxsParser.FunctionExpressionContext)
	/**
	 * Exit a parse tree produced by {@link MxsParser#functionExpression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitFunctionExpression(_ ctx: MxsParser.FunctionExpressionContext)
	/**
	 * Enter a parse tree produced by the {@code newExpr}
	 * labeled alternative in {@link MxsParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterNewExpr(_ ctx: MxsParser.NewExprContext)
	/**
	 * Exit a parse tree produced by the {@code newExpr}
	 * labeled alternative in {@link MxsParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitNewExpr(_ ctx: MxsParser.NewExprContext)
	/**
	 * Enter a parse tree produced by the {@code instExpr}
	 * labeled alternative in {@link MxsParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterInstExpr(_ ctx: MxsParser.InstExprContext)
	/**
	 * Exit a parse tree produced by the {@code instExpr}
	 * labeled alternative in {@link MxsParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitInstExpr(_ ctx: MxsParser.InstExprContext)
	/**
	 * Enter a parse tree produced by the {@code funcExpr}
	 * labeled alternative in {@link MxsParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterFuncExpr(_ ctx: MxsParser.FuncExprContext)
	/**
	 * Exit a parse tree produced by the {@code funcExpr}
	 * labeled alternative in {@link MxsParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitFuncExpr(_ ctx: MxsParser.FuncExprContext)
	/**
	 * Enter a parse tree produced by the {@code unaryExpr}
	 * labeled alternative in {@link MxsParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterUnaryExpr(_ ctx: MxsParser.UnaryExprContext)
	/**
	 * Exit a parse tree produced by the {@code unaryExpr}
	 * labeled alternative in {@link MxsParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitUnaryExpr(_ ctx: MxsParser.UnaryExprContext)
	/**
	 * Enter a parse tree produced by the {@code arrayExpr}
	 * labeled alternative in {@link MxsParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterArrayExpr(_ ctx: MxsParser.ArrayExprContext)
	/**
	 * Exit a parse tree produced by the {@code arrayExpr}
	 * labeled alternative in {@link MxsParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitArrayExpr(_ ctx: MxsParser.ArrayExprContext)
	/**
	 * Enter a parse tree produced by the {@code paraExpr}
	 * labeled alternative in {@link MxsParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterParaExpr(_ ctx: MxsParser.ParaExprContext)
	/**
	 * Exit a parse tree produced by the {@code paraExpr}
	 * labeled alternative in {@link MxsParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitParaExpr(_ ctx: MxsParser.ParaExprContext)
	/**
	 * Enter a parse tree produced by the {@code literalExpr}
	 * labeled alternative in {@link MxsParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterLiteralExpr(_ ctx: MxsParser.LiteralExprContext)
	/**
	 * Exit a parse tree produced by the {@code literalExpr}
	 * labeled alternative in {@link MxsParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitLiteralExpr(_ ctx: MxsParser.LiteralExprContext)
	/**
	 * Enter a parse tree produced by the {@code memberExpr}
	 * labeled alternative in {@link MxsParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterMemberExpr(_ ctx: MxsParser.MemberExprContext)
	/**
	 * Exit a parse tree produced by the {@code memberExpr}
	 * labeled alternative in {@link MxsParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitMemberExpr(_ ctx: MxsParser.MemberExprContext)
	/**
	 * Enter a parse tree produced by the {@code binaryExpr}
	 * labeled alternative in {@link MxsParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterBinaryExpr(_ ctx: MxsParser.BinaryExprContext)
	/**
	 * Exit a parse tree produced by the {@code binaryExpr}
	 * labeled alternative in {@link MxsParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitBinaryExpr(_ ctx: MxsParser.BinaryExprContext)
	/**
	 * Enter a parse tree produced by the {@code sufExpr}
	 * labeled alternative in {@link MxsParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterSufExpr(_ ctx: MxsParser.SufExprContext)
	/**
	 * Exit a parse tree produced by the {@code sufExpr}
	 * labeled alternative in {@link MxsParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitSufExpr(_ ctx: MxsParser.SufExprContext)
	/**
	 * Enter a parse tree produced by the {@code assignExpr}
	 * labeled alternative in {@link MxsParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterAssignExpr(_ ctx: MxsParser.AssignExprContext)
	/**
	 * Exit a parse tree produced by the {@code assignExpr}
	 * labeled alternative in {@link MxsParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitAssignExpr(_ ctx: MxsParser.AssignExprContext)
	/**
	 * Enter a parse tree produced by the {@code idExpr}
	 * labeled alternative in {@link MxsParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterIdExpr(_ ctx: MxsParser.IdExprContext)
	/**
	 * Exit a parse tree produced by the {@code idExpr}
	 * labeled alternative in {@link MxsParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitIdExpr(_ ctx: MxsParser.IdExprContext)
}