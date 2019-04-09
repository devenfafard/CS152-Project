/*
 *  Deven Fafard
 *  862018328
 *  Lab 1
 */

NUMBER     [0-9]

%%

"+"        { printf("PLUS\n");     }
"-"        { printf("SUB\n");      }
"*"        { printf("MULT\n");     }
"/"        { printf("DIV\n");      }
"("        { printf("L_PAREN\n");  }
")"        { printf("R_PAREN\n");  }
"="        { printf("EQUALS\n");   }

{NUMBER}+  { printf("NUMBER(%s)\n", yytext); }
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
     printf("***Running Task 1*** \n\n");
     printf("Please enter an expression:\n");
     yylex();
}
