
grammar Mxs;

// top rule - declarations
declarations: declaration*;
declaration: functionDeclaration | variableDeclaration | classDeclaration;

functionDeclaration
    : type Identifier '(' ((type Identifier ',')* type Identifier)? ')' LeftBr sentence* RightBr
    | '普通老百姓都懂的' Identifier '得到' type ('根据' (type Identifier ',')* type Identifier)? sentence* '但我不想讲证明'
    ;

initialDeclaration: Identifier '(' ((type Identifier ',')* type Identifier)? ')' LeftBr sentence* RightBr;

singleVarDeclaration: Identifier (Assign expression)?;
variableDeclaration: type (singleVarDeclaration ',')* singleVarDeclaration Semicolon;

classDeclaration
    : Class Identifier LeftBr (variableDeclaration | functionDeclaration | initialDeclaration)* RightBr Semicolon
    ;

declSentence: variableDeclaration;
ifSentence
    : If '(' expression ')' sentence (Else sentence)?
    | '如果' expression sentence ('或者' sentence)?
    ;
whileSentence
    : While '(' expression ')' sentence
    | '只要' expression sentence
    ;
forSentence: For '(' (expressionSentence | declSentence | Semicolon) cod=expression? Semicolon inc=expression? ')' body=sentence;
returnSentence: Return expression? Semicolon;
breakSentence: Break Semicolon;
continueSentence: Continue Semicolon;
expressionSentence: expression Semicolon;

sentence: (declSentence | ifSentence | whileSentence | forSentence | returnSentence | breakSentence | continueSentence | expressionSentence | codeBlock | Semicolon);

codeBlock
    : LeftBr sentence* RightBr
    ;

emptySet        : ('[' ']');
type: (Bool | Int | String | Void | Identifier) emptySet*;

functionExpression
    : Identifier '(' ((expression ',')* expression)? ')'
    | '完成习题' Identifier ('根据' (expression ',')* expression)?
    ;

newIndex: '[' expression? ']';

expression
    : Identifier                                                                    #idExpr
    | (This | BoolLiteral | IntLiteral | StringLiteral | NullLiteral)               #literalExpr
    | op='(' expression ')'                                                         #paraExpr
    | expression op='.' (Identifier | This | functionExpression)                    #memberExpr
    | array=expression op='[' idx=expression ']'                                    #arrayExpr
    | functionExpression                                                            #funcExpr
    | New ty=(Bool | Int | String | Void | Identifier) newIndex+                    #newExpr
    | expression op=(SelfAdd | SelfSub)                                             #sufExpr
    | op=(SelfAdd | SelfSub | Add | Sub | Negation | Bitwise) expression            #unaryExpr
    | New Identifier ('(' ')')?                                                     #instExpr
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
    | <assoc=right> expression op=Assign expression                                 #assignExpr
    ;

Bool            : 'bool' | '布尔';
Int             : 'int' | '整数';
String          : 'string';
Void            : 'void' | '空';
If              : 'if';
Else            : 'else';
For             : 'for';
While           : 'while';
Break           : 'break';
Continue        : 'continue';
Return          : 'return' | '就得到了';
New             : 'new';
Class           : 'class';
This            : 'this';
StringLiteral   : '"' (~["\\\n\r] | '\\' ["n\\])* '"';
BoolLiteral     : 'true' | 'false';
NullLiteral     : 'null';
IntLiteral      : [1-9][0-9]* | '0';

Assign      : '=' | '是';
Mul         : '*' | '乘';
Div         : '/' | '除以';
Add         : '+' | '加';
Sub         : '-' | '减';
Mod         : '%' | '模';
Negation    : '!' | '不';
Bitwise     : '~' | '取反';
SelfAdd     : '++' | '自增';
SelfSub     : '--' | '自减';
RightShift  : '>>' | '右移';
LeftShift   : '<<' | '左移';
GreaterEq   : '>=' | '大于等于';
LessEq      : '<=' | '小于等于';
Greater     : '>' | '大于';
Less        : '<' | '小于';
Equal       : '==' | '等于';
Inequal     : '!=' | '不等于';
BitAnd      : '&' | '按位与';
BitOr       : '|' | '按位或';
BitXor      : '^' | '按位异或';
LogicAnd    : '&&' | '而且';
LogicOr     : '||' | '或者';

LeftBr          : '{' | '采取行动';
RightBr         : '}' | '期待下次表现';
Semicolon       : ';' | '啊是';
Identifier      : [a-zA-Z][a-zA-Z0-9_]* | [\u4e00-\u9fa5]+;

Whitespace      : [ \t]+ -> skip;
Newline         : ('\r' '\n'? | '\n') -> skip;
BlockComment    : '/*' .*? '*/' -> skip;
LineComment     : '//' ~ [^\r\n]* -> skip;
