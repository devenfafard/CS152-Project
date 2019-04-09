/*
 *  Deven Fafard
 *  862018328
 *  Lab 1
 */

%{
  int intCount   = 0;
  int opCount    = 0;
  int parenCount = 0;
  int eqCount    = 0;
%}

NUMBER     [0-9]

%%

"+"        { printf("PLUS\n"); opCount++;        }
"-"        { printf("SUB\n");  opCount++;        }
"*"        { printf("MULT\n"); opCount++;        }
"/"        { printf("DIV\n");  opCount++;        }
"("        { printf("L_PAREN\n"); parenCount++;  }
")"        { printf("R_PAREN\n"); parenCount++;  }
"="        { printf("EQUALS\n");  eqCount++;     }

{NUMBER}+  { printf("NUMBER(%s)\n", yytext); intCount++; }
.          { printf("ERROR: Unidentified character encountered! Exiting...\n\n");
             exit(0); }

%%

int main(int argc, char ** argv)
{
     if(argc >= 2)
     {
          //Open the file readonly
          yyin = fopen(argv[1], "r");
          if(yyin == NULL)
          {
               yyin = stdin;
          }
          else //No file specified
          {
               yyin = stdin;
          }

     }

     printf("Please enter an expression:\n");

     yylex();

     printf("# of integers encountered: %d\n", intCount);
     printf("# of operators encountered: %d\n", opCount);
     printf("# of parenthesis encountered: %d\n", parenCount);
     printf("# of equal signs encountered: %d\n", eqCount);
}
