/*
 * Deven Fafard
 * 862018328
 * Phase 1
 */

%{
   #include "y.tab.h"
   int currentLine = 1;
   int currentPosition = 1;
   
%}




NUMBER         [0-9]
ALPHA          [A-Z|a-z]
ALPHANUMERIC   [a-z|A-Z|0-9]
VALID          {ALPHANUMERIC}|_

%%

"function"     { currentPosition += yyleng; return FUNCTION;         } 
"beginparams"  { currentPosition += yyleng; return BEGIN_PARAMS;     }
"endparams"    { currentPosition += yyleng; return END_PARAMS;       }
"beginlocals"  { currentPosition += yyleng; return BEGIN_LOCALS;     }
"endlocals"    { currentPosition += yyleng; return END_LOCALS;       }
"beginbody"    { currentPosition += yyleng; return BEGIN_BODY;       }
"endbody"      { currentPosition += yyleng; return END_BODY;         }
"integer"      { currentPosition += yyleng; return INTEGER;          }
"array"        { currentPosition += yyleng; return ARRAY;            }
"of"           { currentPosition += yyleng; return OF;               }
"if"           { currentPosition += yyleng; return IF;               }
"then"         { currentPosition += yyleng; return THEN;             }
"endif"        { currentPosition += yyleng; return ENDIF;            }
"else"         { currentPosition += yyleng; return ELSE;             }
"while"        { currentPosition += yyleng; return WHILE;            }
"do"           { currentPosition += yyleng; return DO;               }
"beginloop"    { currentPosition += yyleng; return BEGINLOOP;        }
"endloop"      { currentPosition += yyleng; return ENDLOOP;          }
"continue"     { currentPosition += yyleng; return CONTINUE;         }
"read"         { currentPosition += yyleng; return READ;             }
"write"        { currentPosition += yyleng; return WRITE;            }
"and"          { currentPosition += yyleng; return AND;              }
"or"           { currentPosition += yyleng; return OR;               }
"not"          { currentPosition += yyleng; return NOT;              }
"true"         { currentPosition += yyleng; return TRUE;             }
"false"        { currentPosition += yyleng; return FALSE;            }
"return"       { currentPosition += yyleng; return RETURN;           }

"-"            { currentPosition += yyleng; return SUB;              }
"+"            { currentPosition += yyleng; return ADD;              }
"*"            { currentPosition += yyleng; return MULT;             }
"/"            { currentPosition += yyleng; return DIV;              }
"%"            { currentPosition += yyleng; return MOD;              }

"=="           { currentPosition += yyleng; return EQ;               }
"<>"           { currentPosition += yyleng; return NEQ;              }
"<"            { currentPosition += yyleng; return LT;               }
">"            { currentPosition += yyleng; return GT;               }
"<="           { currentPosition += yyleng; return LTE;              }
">="           { currentPosition += yyleng; return GTE;              }

";"            { currentPosition += yyleng; return SEMICOLON;        }
":"            { currentPosition += yyleng; return COLON;            }
","            { currentPosition += yyleng; return COMMA;            }
"("            { currentPosition += yyleng; return L_PAREN;          }
")"            { currentPosition += yyleng; return R_PAREN;          }
"["            { currentPosition += yyleng; return L_SQUARE_BRACKET; }
"]"            { currentPosition += yyleng; return R_SQUARE_BRACKET; }
":="           { currentPosition += yyleng; return ASSIGN;           }

{NUMBER}+                  { currentPosition += yyleng; return NUMBER; }
{ALPHA}(_*{ALPHANUMERIC}*) { printf("IDENTIFIER %s\n", yytext); currentPosition += yyleng; }

"##".*           { /*ignore spaces*/ currentPosition = 1; currentLine++; }
"\n"             { currentLine++; currentPosition = 1; return END; }
[ \t]+           { currentPosition += yyleng; }

\_({VALID}*)         { printf("Error at line %u, column %u: Identifier \" %s \" must begin with a letter", currentLine, currentPosition, yytext); exit(0); }
{NUMBER}+({VALID}*)  { printf("Error at line %u, column %u: Identifier \" %s \" must begin with a letter", currentLine, currentPosition, yytext); exit(0); }
{VALID}*_           { printf("Error at line %u, column %u: Identifier \" %s \" cannot end with an underscore", currentLine, currentPosition, yytext); exit(0); }
.                   { printf("Error at line %u, column %u: unrecognized symbol \" %s \" \n", currentLine, currentPosition, yytext); exit(0); }

%%


