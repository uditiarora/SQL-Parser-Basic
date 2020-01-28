%{
#include<stdio.h>
#include<stdlib.h>
extern int yylex();
extern int yyparse();
extern FILE* yyin
%}

%union{
	int ival;
	float fval;
	const char *sval;
}

%token<ival> T_INT
%token<fval> T_FLOAT
%token<sval> T_STRING

