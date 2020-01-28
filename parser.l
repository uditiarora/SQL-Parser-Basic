%option noyywrap
%{
#include<stdio.h>
#define YY_DECL int yylex()
#include "parser.tab.h"
%}

%%

[\t] ;
[0-9]+\.[0-9]+ 	{yylval.fval = atof(yytext); return T_FLOAT;}
[0-9]+		{yylval.ival = atoi(yytext); return T_INT;}
\n		{return T_NEWLINE;}
(S|s)(E|e)(L|l)(E|e)(C|c)(T|t) {return T_SELECT;}
(C|c)(R|r)(E|e)(A|a)(T|t)(E|e) {return T_CREATE;}
(T|t)(A|a)(B|b)(L|l)(E|e) {return T_TABLE;}
(I|i)(N|n)(T|t)(O|o) {return T_INTO;}
(U|u)(P|p)(D|d)(A|a)(T|t)(E|e) {return T_UPDATE;}
(D|d)(E|e)(L|l)(E|e)(T|t)(E|e) {return T_DELETE;}
(D|d)(R|r)(O|o)(P|p) {return T_DROP;}
(F|f)(R|r)(O|o)(M|m) {return T_FROM;}
(W|w)(H|h)(E|e)(R|r)(E|e) {return T_WHERE;}
(A|a)(N|n)(D|d) {return T_AND;}
(O|o)(R|r) {return T_OR;}
(I|i)(N|n) {return T_IN;}
(L|l)(I|i)(K|k)(E|e) {return T_LIKE;}
"=" {return T_EQUAL;}
(V|v)(A|a)(L|l)(U|u)(E|e)(S|s) {return T_VALUES;}
(S|s)(E|e)(T|t) {return T_SET;}
"exit"		{return T_QUIT;}
"quit"		{return T_QUIT;}

