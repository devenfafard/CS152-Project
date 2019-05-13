%{
 #include "heading.h"
 int yyerror(char *s);
 int yylex(void);
%}

%union
{
    int val;
    string* op_val;
}

%start input

%token FUNCTION BEGINPARAMS ENDPARAMS BEGINLOCALS ENDLOCALS BEGINBODY ENDBODY INTEGER 
       ARRAY OF IF THEN ENDIF ELSE WHILE DO BEGINLOOP ENDLOOP CONTINUE READ WRITE AND
       OR NOT TRUE FALSE RETURN SEMICOLON COLON COMMA L_PAREN R_PAREN L_SQUARE_BRACKET
       R_SQUARE_BRACKET ASSIGN

%token <val> NUMBER
%token <op_val> IDENTIFIER

%left MULT DIV MOD ADD SUB
%left LT LTE GT GTE EQ NEQ
%left AND OR

%right NOT
%right ASSIGN

%%

input:         functions { cout << "input -> functions" << endl; }
               ;

functions:     function functions { cout << "functions -> function functions" << endl; }
               | { cout << "function -> EMPTY" << endl; }
               ;

function:      FUNCTION IDENTIFIER SEMICOLON BEGINPARAMS declarations ENDPARAMS BEGINLOCALS
               declarations ENDLOCALS BEGINBODY statements ENDBODY
               { cout << "FUNCTION IDENT" << *($2) << "SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statements END_BODY" << endl; }

declarations:  declaration SEMICOLON declarations { cout << "declarations -> declaration SEMICOLON declarations" << endl; }
               | { cout << "declarations -> EMPTY" << endl; }
               ;

declaration:   id COLON assign { cout << "id COLON assign" << endl; }
               ;

id:            IDENTIFIER { cout << "id -> IDENTIFIER " << *($1) << endl; }
               | IDENTIFIER COMMA id { cout << "id -> IDENTIFIER " << *($1) << " COMMA id" << endl; }
               ;

assign:        INTEGER { cout << "assign -> INTEGER" << endl; }
               | ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER { cout << "ARRAY L_SQUARE_BRACKET " << $3 << " R_SQUARE_BRACKET OF INTEGER" << endl; }
               ;

statements:    statement SEMICOLON statements { cout << "statements -> statement SEMICOLON statements" << endl; }
               | statement SEMICOLON { cout << "statements -> statement SEMICOLON" << endl; }
               ;

statement:     vars { cout << "statement -> vars" << endl; }
               | ifs { cout << "statement -> ifs" << endl; }
               | whiles { cout << "statement -> whiles" << endl; }
               | dos { cout << "statement -> dos" << endl; }
               | read { cout << "statement -> read" << endl; }
               | write { cout << "statement -> write" << endl; }
               | continue { cout << "statement -> continue" << endl; }
               | return { cout << "statement -> return" << endl; }
               ;

vars:          var ASSIGN expression { cout << "vars -> var ASSIGN expression" << endl; }
               ;

ifs:           IF bool_expr THEN statements ENDIF { cout << "ifs -> IF bool_expr THEN statments" << endl; }
               | IF bool_expr THEN statements ELSE statements ENDIF { cout << "ifs -> IF bool_expr THEN statements ELSE statements ENDIF" << endl; }
               ;

whiles:        WHILE bool_expr BEGINLOOP statements ENDLOOP { cout << "whiles -> WHILE bool_expr BEGINLOOP statements ENDLOOP" << endl; }
               ;

dos:           DO BEGINLOOP statements ENDLOOP WHILE bool_expr { cout << "dos -> DO BEGINLOOP statements ENDLOOP WHILE bool_expr" << endl; }
               ;

read:          READ var empty { cout << "read -> READ var empty" << endl; }
               ;

write:         WRITE var empty { cout << "write -> WRITE var empty" << endl; }
               ;

empty:         { cout << "empty -> EMPTY" << endl; }
               | COMMA var empty { cout << "empty -> COMMA var empty" << endl; }
               ;

continue:      CONTINUE { cout << "continue -> CONTINUE" << endl; }
               ;

return:        RETURN expression { cout << "return -> RETURN expression" << endl; }
               ;

bool_expr:     relation_and_expr { cout << "bool_expr -> relation_and_expr"<< endl; }
               | bool_expr OR relation_and_expr { cout << "bool_expr -> bool_expr OR relation_and_expr" << endl; }
               ;

relation_and_expr: relation_expr {cout << "relation_and_expr -> relation_expr" << endl; }
                   | relation_and_expr AND relation_expr {cout << "relation_and_expr -> relation_and_expr AND relation_expr" << endl; }
                   ;

relation_expr:     rexpr { cout << "relation_expr -> rexpr" << endl; }
                   | NOT rexpr {cout << "relation_expr -> NOT rexpr" << endl; }
                   ;

rexpr:             expression comp expression { cout << "rexpr -> expression comp expression" << endl;}
                   | TRUE { cout << "rexpr -> TRUE" << endl; }
                   | FALSE { cout << "rexpr -> FALSE" << endl; }
                   | L_PAREN bool_expr R_PAREN { cout << "rexpr -> L_PAREN bool_expr R_PAREN" << endl;}
                   ;

comp:              EQ {cout << "comp -> EQ" << endl; }
                   | NEQ { cout << "comp -> NEQ" << endl; }
                   | LT { cout << "comp -> LT" << endl; }
                   | GT {cout << "comp -> GT" << endl; }
                   | LTE { cout << "comp -> LTE" << endl; }
                   | GTE { cout << "comp -> GTE" << endl; }
                   ;

expression:        mult_expr add_expr { cout << "expression -> mult_expr add_expr" << endl;}
                   ;

add_expr:          ADD mult_expr add_expr { cout << "add_expr -> ADD mul_expr expradd" << endl;}
                   | SUB mult_expr add_expr { cout << " add_expr -> SUB mult_expr add_expr" << endl; }
                   | { cout << "add_expr -> EMPTY" << endl;}
                   ;

mult_expr:         term multi_term { cout << "mult_expr -> term multi_term" << endl; }
                   ;

multi_term:        MULT term multi_term { cout << "multi_term -> MULT term multi_term" << endl;}
                   | DIV term multi_term { cout << "multi_term -> DIV term multi_term" << endl;}
                   | MOD term multi_term { cout << "multi_term -> MOD term multi_term" << endl; }
                   | { cout << "multi_term -> EMPTY" << endl; }
                   ;

term:              positive_term { cout << "term -> positive_term" << endl;}
                   | SUB positive_term {cout << "term -> SUB positive_term" << endl;}
                   | IDENTIFIER term_iden { cout << "term -> IDENT " <<*($1)<<" term_iden" <<endl;}
                   ;

positive_term:     var {cout << "positive_term -> var" << endl; }
                   | NUMBER { cout << "positive_term -> NUMBER " << $1 << endl; }
                   | L_PAREN expression R_PAREN { cout << "positive_term -> L_PAREN expression R_PAREN" << endl; }
                   ;

term_iden:         L_PAREN term_ex R_PAREN { cout << "term_iden -> L_PAREN term_ex R_PAREN" << endl; }
                   | L_PAREN R_PAREN { cout << "term_iden -> L_PAREN R_PAREN" << endl; }
                   ;

term_ex:           expression { cout << "term_ex -> expression" << endl; }
                   | expression COMMA term_ex { cout << "term_ex -> expression COMMA term_ex" << endl; }
                   ;

var:               IDENTIFIER { cout << "var -> IDENT " <<*($1)<< endl;}
                   | IDENTIFIER L_SQUARE_BRACKET expression R_SQUARE_BRACKET { cout << "var -> IDENT " <<*($1)<< " L_SQUARE_BRACKET expression R_SQUARE_BRACKET" << endl; }
                   ;

%%

int yyerror(string s)
{
     extern int row, column;
     extern char *yytext;

     cerr << "Error at line " << row << ", column " << column <<" : unexpected symbol " << yytext << "." << endl;
     exit(1);
}

int yyerror(char *s)
{
     return yyerror(string(s));
} 
