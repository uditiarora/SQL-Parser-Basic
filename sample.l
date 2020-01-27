%{
int chars = 0;
int words = 0;
int lines = 0;
%}

%%

[a-zA-Z]+  { words++; chars += strlen(yytext); }
\n         { chars++; lines++; }
.          { chars++; }

%%

main(int argc, char **argv)
{
 FILE *myfile = fopen("sample.txt", "r");

  if (!myfile) {
	printf("failed");
    return -1;
  }

  yyin = myfile;
  yylex();
  printf("%8d%8d%8d\n", lines, words, chars);
}
