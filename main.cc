#include "heading.h"

int yyparse();

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

     yyparse();

     return 0;
}