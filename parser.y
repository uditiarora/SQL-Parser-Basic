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
	char sval[256];
}

%token<ival> T_INT
%token<fval> T_FLOAT
%token<sval> T_STRING
%token T_SELECT T_CREATE T_TABLE T_INSERT T_INTO T_UPDATE T_DELETE T_DROP T_FROM T_WHERE T_SET T_VALUES T_DATATYPE
%token T_AND T_OR T_EQUAL T_LIKE T_STAR T_COMMA T_CONSTANT T_PATTERN T_GREATER T_SMALLER T_GREATER_EQUAL T_SMALLER_EQUAL

%start query

%%

query: 
	| select 
	| create 
	| insert
	| update
	| delete
	| drop
;

select: T_SELECT a
;

a: sel_list T_FROM T_STRING 
	| sel_list T_FROM T_STRING T_WHERE condition
;

sel_list: T_STAR
	| T_STRING
	| T_STRING T_COMMA sel_list
;

condition: condition T_AND condition
	| condition T_OR condition
	| T_STRING T_EQUAL T_STRING
	| T_STRING T_EQUAL T_CONSTANT
	| T_STRING T_EQUAL T_PATTERN
	| T_STRING T_LIKE T_PATTERN
	| T_STRING T_GREATER T_STRING
	| T_STRING T_SMALLER T_STRING
	| T_STRING T_GREATER_EQUAL T_STRING
	| T_STRING T_SMALLER_EQUAL T_STRING
	| T_STRING T_GREATER T_CONSTANT
	| T_STRING T_SMALLER T_CONSTANT
	| T_STRING T_GREATER_EQUAL T_CONSTANT
	| T_STRING T_SMALLER_EQUAL T_CONSTANT
	| T_STRING T_GREATER T_PATTERN
	| T_STRING T_SMALLER T_PATTERN
	| T_STRING T_GREATER_EQUAL T_PATTERN
	| T_STRING T_SMALLER_EQUAL T_PATTERN
;

create: T_CREATE T_TABLE T_STRING create_att
;

create_att: T_STRING T_DATATYPE
	| T_STRING T_DATATYPE T_COMMA create_att
;

insert: T_INSERT T_INTO T_STRING insert_att
;

insert_att: insert_list T_VALUES constants_list
;

insert_list: T_STRING
	| T_STRING T_COMMA insert_list
;

constants_list: T_CONSTANT
	| T_CONSTANT T_COMMA constants_list
;

update: T_UPDATE  T_STRING T_SET update_list
;

update_list: T_STRING T_EQUAL T_CONSTANT
	| T_STRING T_EQUAL T_CONSTANT T_COMMA update_list
;

delete: T_DELETE T_STRING
;

drop: T_DROP T_TABLE T_STRING
;

%%

int main() {
	yyin = stdin;

	do {
		yyparse();
	} while(!feof(yyin));

	return 0;
}

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}













