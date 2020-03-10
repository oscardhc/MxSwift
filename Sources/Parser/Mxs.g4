
grammar Mxs;

// top rule - declarations
declarations: declaration*;
declaration: functionDeclaration | variableDeclaration | classDeclaration;

functionDeclaration: type Identifier '(' ((type Identifier ',')* type Identifier)? ')' '{' sentence* '}';

initialDeclaration: Identifier '(' ((type Identifier ',')* type Identifier)? ')' '{' sentence* '}';

singleVarDeclaration: Identifier ('=' expression)?;
variableDeclaration: type (singleVarDeclaration ',')* singleVarDeclaration ';';

classDeclaration
    : Class Identifier '{' (variableDeclaration | functionDeclaration | initialDeclaration)* '}' ';'
    ;

declSentence: variableDeclaration;
ifSentence: If '(' expression ')' sentence (Else sentence)?;
whileSentence: While '(' expression ')' sentence;
forSentence: For '(' (expressionSentence | declSentence | ';') cod=expression? ';' inc=expression? ')' body=sentence;
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
StringLiteral   : '"' (~["\\\n\r] | '\\' ["n\\])* '"';
BoolLiteral     : 'true' | 'false';
NullLiteral     : 'null';
IntLiteral      : [1-9][0-9]* | '0';

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
