%{
#include "parser2.tab.h"
#include<stdio.h>
#define YY_DECL extern int yylex()
int line_no = 1;
%}

%%
[ \t\n]

\".*\"									{return STRING;}

~.*

(" ")(T|t)(A|a)(B|b)(L|l)(E|e)						{return TABLE;}
(S|s)(E|e)(L|l)(E|e)(C|c)(T|t)						{return SELECT;}
(C|c)(R|r)(E|e)(A|a)(T|t)(E|e)						{return CREATE;}
(D|d)(R|r)(O|o)(P|p)							{return DROP;}
(I|i)(N|n)(S|s)(E|e)(R|r)(T|t)(" ")(I|i)(N|n)(T|t)(O|o)			{return INSERT;}
"UPDATE"|"update"							{return UPDATE;}
(D|d)(E|e)(L|l)(E|e)(T|t)(E|e)						{return DELETE;}
(" ")(F|f)(R|r)(O|o)(M|m)						{return FROM;}
" SET "|" set "						{return SET;}
(" ")(W|w)(H|h)(E|e)(R|r)(E|e) 						{return WHERE;}
(" ")(P|p)(R|r)(I|i)(M|m)(A|a)(R|r)(Y|y)(" ")(K|k)(E|e)(Y|y)		{return PRIMKEY;}
(" ")(U|u)(N|n)(I|i)(Q|q)(U|u)(E|e)					{return UNIQUE;}
(" ")(D|d)(E|e)(F|f)(A|a)(U|u)(L|l)(T|t)				{return DEFAULT;}
(" ")(B|b)(E|e)(T|t)(W|w)(E|e)(E|e)(N|n)(" ")				{return BETWEEN;}
(" ")(I|i)(N|n)(" ")							{return IN;}
(" ")(N|n)(O|o)(T|t)(" ")(N|n)(U|u)(L|l)(L|l)				{return NOTNULL;}
(" ")(L|l)(I|i)(K|k)(E|e)(" ")						{return LIKE;}
(" ")(V|v)(A|a)(L|l)(U|u)(E|e)(S|s)					{return VALUES;}
(" ")(G|g)(R|r)(O|o)(U|u)(P|p)(" ")(B|b)(Y|y)(" ")			{return GROUP;}
(" ")(H|h)(A|a)(V|v)(I|i)(N|n)(G|g)(" ")					{return HAVING;}
(" ")(O|o)(R|r)(D|D)(E|e)(R|r)(" ")(B|b)(Y|y)(" ")			{return ORDER;}
" count"|" avg"|" max"|" min"|" sum"					{return AGGRE;}
(" ")(A|a)(S|s)(" ")							{return AS;}
(" ")(A|a)(S|s)(C|c)							{return ASC;}
(" ")(D|d)(E|e)(S|s)(C|c)						{return DESC;}
"!="									{return NE;}
"=="									{return EQ;}
"<="									{return LE;}
">="									{return GE;}
"<"									{return LT;}
">"									{return GT;}
(" not "|"!")								{return NOT;}
(" ")(A|a)(N|n)(D|d)							{return AND;}
(" ")(O|o)(R|r)(" ")							{return OR;}
"="									{return EQUAL;} 
"+"									{return ADD;}
"-"									{return SUB;}
"*"									{return MUL;}
"/"									{return DIV;}
"("									{return yytext[0];}
")"									{return yytext[0];}
","									{return yytext[0];}
[0-9]+\.[0-9]+ 								{return FLOAT;}
[0-9][0-9]*								{return NUM;}
[a-zA-Z0-9][a-z_A-Z0-9]*	  					{return CNAME;}
" float"|" int"|" char"|" varchar"					{return DTYPE;}
;									{++line_no; return ENDQ;}
.									{return yytext[0];}
%%

int yywrap()
{
	return 1;
}

