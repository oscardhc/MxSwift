
grammar Mxs;

// top rule - declarations
declarations: declaration*;
declaration: functionDeclaration | variableDeclaration | classDeclaration;

functionDeclaration: type Identifier '(' ((type Identifier ',')* type Identifier)? ')' '{' sentence* '}';

initialDeclaration: Identifier '(' ((type Identifier ',')* type Identifier)? ')' '{' sentence* '}';

variableDeclaration: type (Identifier ('=' expression)? ',')* Identifier ('=' expression)? ';';

classDeclaration
    : Class Identifier '{' (variableDeclaration | functionDeclaration | initialDeclaration)* '}' ';'
    ;

declSentence: variableDeclaration;
ifSentence: If '(' expression ')' sentence (Else sentence)?;
whileSentence: While '(' expression ')' sentence;
forSentence: For '(' ini=expression? ';' cod=expression? ';' inc=expression? ')' sentence;
returnSentence: Return expression? ';';
breakSentence: Break ';';
continueSentence: Continue ';';
expressionSentence: expression ';';

sentence: (declSentence | ifSentence | whileSentence | forSentence | returnSentence | breakSentence | continueSentence | expressionSentence | codeBlock | ';');

codeBlock
    : '{' sentence* '}'
    ;

emptySet        : ('[' ']');
type: (Bool | Int | String | Void | Identifier) emptySet*;

functionExpression: Identifier '(' ((expression ',')* expression)? ')';

expression
    : Identifier                                                                    #idExpr
    | (This | BoolLiteral | IntLiteral | StringLiteral | NullLiteral)               #literalExpr
    | op='(' expression ')'                                                         #paraExpr
    | expression op='.' (Identifier | functionExpression)                           #memberExpr
    | array=expression op='[' idx=expression ']'                                    #arrayExpr
    | functionExpression                                                            #funcExpr
    | expression op=(SelfAdd | SelfSub)                                             #sufExpr
    | op=(SelfAdd | SelfSub | Add | Sub | Negation | Bitwise) expression            #unaryExpr
    | New (functionExpression | Identifier)                                         #instExpr
    | New ty=(Bool | Int | String | Void | Identifier) '[' expression ']' (emptySet*)       #newExpr
    | New ty=(Bool | Int | String | Void | Identifier) ('[' expression ']')*        #newExpr
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

Assign      : '=';
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