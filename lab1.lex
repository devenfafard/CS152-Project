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

main()
{
     printf("***Running Task 1*** \n\n");
     printf("Please enter an expression:\n");
     yylex();
}
