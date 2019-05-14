%{
 #include <stdio.h>
 #include <stdlib.h>
 int yyerror(const char *s);
 int yylex(void);
%}

%union
{
    int val;
    char* op_val;
}

%start input

%token FUNCTION BEGIN_PARAMS END_PARAMS BEGIN_LOCALS END_LOCALS BEGIN_BODY END_BODY INTEGER 
       ARRAY OF IF THEN ENDIF ELSE WHILE DO BEGINLOOP ENDLOOP CONTINUE READ WRITE AND
       OR NOT TRUE FALSE RETURN SEMICOLON COLON COMMA L_PAREN R_PAREN L_SQUARE_BRACKET
       R_SQUARE_BRACKET ASSIGN END

%token <val> NUMBER
%token <op_val> IDENTIFIER

%left MULT DIV MOD ADD SUB
%left LT LTE GT GTE EQ NEQ
%left AND OR

%right NOT
%right ASSIGN

%%

input:         functions { printf("input -> functions\n"); }
               ;

functions:     function functions { printf("functions -> function functions\n"); }
               | { printf("function -> EMPTY\n"); }
               ;

function:      FUNCTION IDENTIFIER SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS
               declarations END_LOCALS BEGIN_BODY statements END_BODY
               { printf("FUNCTION IDENTIFIER SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statements END_BODY\n"); }

declarations:  declaration SEMICOLON declarations { printf( "declarations -> declaration SEMICOLON declarations\n"); }
               | { printf("declarations -> EMPTY\n"); }
               ;

declaration:   id COLON assign { printf("id COLON assign\n"); }
               ;

id:            IDENTIFIER { printf("id -> IDENTIFIER \n"); }
               | IDENTIFIER COMMA id { printf("id -> IDENTIFIER COMMA id\n"); }
               ;

assign:        INTEGER { printf("assign -> INTEGER\n"); }
               | ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER { printf("ARRAY L_SQUARE_BRACKET R_SQUARE_BRACKET OF INTEGER\n"); }
               ;

statements:    statement SEMICOLON statements { printf("statements -> statement SEMICOLON statements\n"); }
               | statement SEMICOLON { printf("statements -> statement SEMICOLON\n"); }
               ;

statement:     vars { printf("statement -> vars\n"); }
               | ifs { printf("statement -> ifs\n"); }
               | whiles { printf("statement -> whiles\n"); }
               | dos { printf("statement -> dos\n"); }
               | read { printf("statement -> read\n"); }
               | write { printf("statement -> write\n"); }
               | continue { printf("statement -> continue\n"); }
               | return { printf("statement -> return\n"); }
               ;

vars:          var ASSIGN expression { printf("vars -> var ASSIGN expression\n"); }
               ;

ifs:           IF bool_expr THEN statements ENDIF { printf("ifs -> IF bool_expr THEN statments\n"); }
               | IF bool_expr THEN statements ELSE statements ENDIF { printf("ifs -> IF bool_expr THEN statements ELSE statements ENDIF\n"); }
               ;

whiles:        WHILE bool_expr BEGINLOOP statements ENDLOOP { printf("whiles -> WHILE bool_expr BEGINLOOP statements ENDLOOP\n"); }
               ;

dos:           DO BEGINLOOP statements ENDLOOP WHILE bool_expr { printf("dos -> DO BEGINLOOP statements ENDLOOP WHILE bool_expr\n"); }
               ;

read:          READ var empty { printf("read -> READ var empty\n"); }
               ;

write:         WRITE var empty { printf("write -> WRITE var empty\n"); }
               ;

empty:         { printf("empty -> EMPTY\n"); }
               | COMMA var empty { printf("empty -> COMMA var empty\n"); }
               ;

continue:      CONTINUE { printf("continue -> CONTINUE\n"); }
               ;

return:        RETURN expression { printf("return -> RETURN expression\n"); }
               ;

bool_expr:     relation_and_expr { printf("bool_expr -> relation_and_expr\n"); }
               | bool_expr OR relation_and_expr { printf("bool_expr -> bool_expr OR relation_and_expr\n"); }
               ;

relation_and_expr: relation_expr {printf("relation_and_expr -> relation_expr\n"); }
                   | relation_and_expr AND relation_expr {printf("relation_and_expr -> relation_and_expr AND relation_expr\n"); }
                   ;

relation_expr:     rexpr { printf("relation_expr -> rexpr\n"); }
                   | NOT rexpr {printf("relation_expr -> NOT rexpr\n"); }
                   ;

rexpr:             expression comp expression { printf("rexpr -> expression comp expression\n");}
                   | TRUE { printf("rexpr -> TRUE\n"); }
                   | FALSE { printf("rexpr -> FALSE\n"); }
                   | L_PAREN bool_expr R_PAREN { printf("rexpr -> L_PAREN bool_expr R_PAREN\n");}
                   ;

comp:              EQ {printf("comp -> EQ\n"); }
                   | NEQ { printf("comp -> NEQ\n"); }
                   | LT { printf("comp -> LT\n"); }
                   | GT {printf("comp -> GT\n"); }
                   | LTE { printf("comp -> LTE\n"); }
                   | GTE { printf("comp -> GTE\n"); }
                   ;

expression:        mult_expr add_expr { printf("expression -> mult_expr add_expr\n");}
                   ;

add_expr:          ADD mult_expr add_expr { printf("add_expr -> ADD mul_expr expradd\n");}
                   | SUB mult_expr add_expr { printf(" add_expr -> SUB mult_expr add_expr\n"); }
                   | { printf("add_expr -> EMPTY\n");}
                   ;

mult_expr:         term multi_term { printf("mult_expr -> term multi_term\n"); }
                   ;

multi_term:        MULT term multi_term { printf("multi_term -> MULT term multi_term\n");}
                   | DIV term multi_term { printf("multi_term -> DIV term multi_term\n");}
                   | MOD term multi_term { printf("multi_term -> MOD term multi_term\n"); }
                   | { printf("multi_term -> EMPTY\n"); }
                   ;

term:              positive_term { printf("term -> positive_term\n");}
                   | SUB positive_term {printf("term -> SUB positive_term\n");}
                   | IDENTIFIER term_iden { printf("term -> IDENT term_iden/n");}
                   ;

positive_term:     var {printf("positive_term -> var\n"); }
                   | NUMBER { printf("positive_term -> NUMBER \n"); }
                   | L_PAREN expression R_PAREN { printf("positive_term -> L_PAREN expression R_PAREN\n");}
                   ;

term_iden:         L_PAREN term_ex R_PAREN { printf("term_iden -> L_PAREN term_ex R_PAREN\n"); }
                   | L_PAREN R_PAREN { printf("term_iden -> L_PAREN R_PAREN\n"); }
                   ;

term_ex:           expression { printf("term_ex -> expression\n"); }
                   | expression COMMA term_ex { printf("term_ex -> expression COMMA term_ex\n"); }
                   ;

var:               IDENTIFIER { printf("var -> IDENT %s \n", $1);}
                   | IDENTIFIER L_SQUARE_BRACKET expression R_SQUARE_BRACKET { printf("var -> IDENT %s L_SQUARE_BRACKET expression R_SQUARE_BRACKET\n"); }
                   ;

%%


int yyerror(const char* s)
{
     extern int currentLine;
     extern char* yytext;

     printf("Error %s at symbol \"%s\" on line %d\n", s, yytext, currentLine);
     exit(1);
} 
