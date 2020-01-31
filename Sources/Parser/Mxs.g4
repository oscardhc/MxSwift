
grammar Mxs;

// top rule - declarations
declarations: ((functionDeclaration | (variableDeclaration ';') | classDeclaration ';'))*;

functionDeclaration: type Identifier '(' ((type Identifier ',')* type Identifier)? ')' codeBlock;

variableDeclaration: type (Identifier ('=' expression)? ',')* Identifier ('=' expression)?;

classDeclaration
    : Class Identifier '{' ((variableDeclaration ';') | functionDeclaration)* '}'
    ;

declarationSentence: variableDeclaration ';';
ifSentence: If '(' expression ')' codeBlock (Else If '(' expression ')' codeBlock)? (Else codeBlock)?;
whileSentence: While '(' expression ')' codeBlock;
forSentence: For '(' expression? ';' expression? ';' expression? ')' codeBlock;
returnSentence: Return expression? ';';
breakSentence: Break ';';
continueSentence: Continue ';';
expressionSentence: expression ';';

sentence: (declarationSentence | ifSentence | whileSentence | forSentence | returnSentence | breakSentence | continueSentence | expressionSentence);

codeBlock
    : '{' sentence* '}'
    | sentence
    ;

type: (Bool | Int | String | Void | Identifier)('[' expression? ']')*;

argumentList
    : expression
    | argumentList ',' expression
    ;

functionExpression: Identifier '(' argumentList? ')';

expression
    : Identifier                                                                    #singleExpr
    | (This | BoolLiteral | IntLiteral | StringLiteral | NullLiteral)               #singleExpr
    | op='(' expression ')'                                                         #singleExpr
    | expression op='.' (Identifier | functionExpression)                           #singleExpr
    | expression op='[' expression ']'                                              #arrayExpr
    | functionExpression                                                            #funcExpr
    | expression op=(SelfAdd | SelfSub)                                             #sufExpr
    | op=(SelfAdd | SelfSub | Add | Sub | Negation | Bitwise) expression            #unaryExpr
    | New (Bool | Int | String | Void | Identifier) (op='[' expression? ']')+       #newExpr
    | expression op=(Mul | Div | Mod) expression                                    #binaryExpr
    | expression op=(Add | Sub) expression                                          #binaryExpr
    | expression op=(RightShift | LeftShift) expression                             #binaryExpr
    | expression op=(Greater | GreaterEq | Less | LessEq) expression                #binaryExpr
    | expression op=(Equal | Inequal) expression                                    #binaryExpr
    | expression op=BitAnd expression                                               #binaryExpr
    | expression op=BitXor expression                                               #binaryExpr
    | expression op=BitOr expression                                                #binaryExpr
    | expression op=LogicAnd expression                                             #binaryExpr
    | expression op=LogicOr expression                                              #binaryExpr
    | <assoc=right> expression op='=' expression                                    #assignExpr
    ;

Bool            : 'bool';
Int             : 'int';
String          : 'string';
Void            : 'void';
If              : 'if';
Else            : 'else';
For             : 'for';
While           : 'while';
Break           : 'break';
Continue        : 'continue';
Return          : 'return';
New             : 'new';
Class           : 'class';
This            : 'this';
BoolLiteral     : 'true' | 'false';
IntLiteral      : [1-9][0-9]* | '0';
StringLiteral   : '"' (~["\\\n\r] | '\\' ["n\\])* '"';
NullLiteral     : 'null';

Mul         : '*';
Div         : '/';
Add         : '+';
Sub         : '-';
Mod         : '%';
Negation    : '!';
Bitwise     : '~';
SelfAdd     : '++';
SelfSub     : '--';
RightShift  : '>>';
LeftShift   : '<<';
GreaterEq   : '>=';
LessEq      : '<=';
Greater     : '>';
Less        : '<';
Equal       : '==';
Inequal     : '!=';
BitAnd      : '&';
BitOr       : '|';
BitXor      : '^';
LogicAnd    : '&&';
LogicOr     : '||';

Identifier      : [a-zA-Z][a-zA-Z0-9_]*;

Whitespace      : [ \t]+ -> skip;
Newline         : ('\r' '\n'? | '\n') -> skip;
BlockComment    : '/*' .*? '*/' -> skip;
LineComment     : '//' ~ [^\r\n]* -> skip;