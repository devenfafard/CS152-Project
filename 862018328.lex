/*
 * Deven Fafard
 * 862018328
 * Phase 1
 */

%{
   int currentLine = 1;
   int currentPosition = 1;
%}

NUMBER         [0-9]
IDENTIFIER     [A-Z]
COMMENT        [##(A-Z|0-9|.| )/t] 

%%

"function"     { printf("FUNCTION\n"); currentPosition += yyleng;        } 
"beginparams"  { printf("BEGIN_PARAMS\n"); currentPosition += yyleng;    }
"endparams"    { printf("END_PARAMS\n"); currentPosition += yyleng;      }
"beginlocals"  { printf("BEGIN_LOCALS\n"); currentPosition += yyleng;    }
"endlocals"    { printf("END_LOCALS\n"); currentPosition += yyleng;      }
"beginbody"    { printf("BEGIN_BODY\n"); currentPosition += yyleng;      }
"endbody"      { printf("END_BODY\n"); currentPosition += yyleng;        }
"integer"      { printf("INTEGER\n"); currentPosition += yyleng;         }
"array"        { printf("ARRAY\n"); currentPosition += yyleng;           }
"of"           { printf("OF\n"); currentPosition += yyleng;              }
"if"           { printf("IF\n"); currentPosition += yyleng;              }
"then"         { printf("THEN\n"); currentPosition += yyleng;            }
"endif"        { printf("ENDIF\n"); currentPosition += yyleng;           }
"else"         { printf("ELSE\n"); currentPosition += yyleng;            }
"while"        { printf("WHILE\n"); currentPosition += yyleng;           }
"do"           { printf("DO\n"); currentPosition += yyleng;              }
"beginloop"    { printf("BEGINLOOP\n"); currentPosition += yyleng;       }
"endloop"      { printf("ENDLOOP\n"); currentPosition += yyleng;         }
"continue"     { printf("CONTINUE\n"); currentPosition += yyleng;        }
"read"         { printf("READ\n"); currentPosition += yyleng;            }
"write"        { printf("WRITE\n"); currentPosition += yyleng;           }
"and"          { printf("AND\n"); currentPosition += yyleng;             }
"or"           { printf("OR\n"); currentPosition += yyleng;              }
"not"          { printf("NOT\n"); currentPosition += yyleng;             }
"true"         { printf("TRUE\n"); currentPosition += yyleng;            }
"false"        { printf("FALSE\n"); currentPosition += yyleng;           }
"return"       { printf("RETURN\n"); currentPosition += yyleng;          }

"-"            { printf("SUB\n"); currentPosition += yyleng;             }
"+"            { printf("ADD\n"); currentPosition += yyleng;             }
"*"            { printf("MULT\n"); currentPosition += yyleng;            }
"/"            { printf("DIV\n"); currentPosition += yyleng;             }
"%"            { printf("MOD\n");              }

"=="           { printf("EQ\n"); currentPosition += yyleng;              }
"<>"           { printf("NEQ\n"); currentPosition += yyleng;             }
"<"            { printf("LT\n"); currentPosition += yyleng;              }
">"            { printf("GT\n"); currentPosition += yyleng;              }
"<="           { printf("LTE\n"); currentPosition += yyleng;             }
">="           { printf("GTE\n"); currentPosition += yyleng;             }

";"            { printf("SEMICOLON\n"); currentPosition += yyleng;       }
":"            { printf("COLON\n"); currentPosition += yyleng;           }
","            { printf("COMMA\n"); currentPosition += yyleng;           }
"("            { printf("L_PAREN\n"); currentPosition += yyleng;         }
")"            { printf("R_PAREN\n"); currentPosition += yyleng;         }
"["            { printf("L_SQUARE_BRACKET\n"); currentPosition += yyleng; }
"]"            { printf("R_SQUARE_BRACKET\n"); currentPosition += yyleng; }
":="           { printf("ASSIGN\n"); currentPosition += yyleng;          }

{NUMBER}+      { printf("NUMBER %s\n", yytext); currentPosition += yyleng; }
{IDENTIFIER}+  { printf("IDENTIFIER %s\n", yytext); currentPosition += yyleng; }
"\n"           { currentLine++; currentPosition = 1; }
[ \t]+         { currentPosition += yyleng; }
.              { printf("Error at line %u, column %u: unrecognized symbol \" %s \" \n", 
                         currentLine, currentPosition, yytext); exit(0); }

%%

int main(int argc, char ** argv)
{
     //Give the option to specify file or stdin input
     if(argc >= 2)
     {
          //Open the file readonly
          yyin = fopen(argv[1], "r");
          
          //If yyin failed to open, revert to stdin
          if(yyin == NULL)
          {
               yyin = stdin;
          }
          else //Case where no file was specified to begin with
          {
               yyin = stdin;
          }
     }

     //Run the lexer
     yylex();
}
