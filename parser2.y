%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern int line_no;
void yyerror(const char *s);
struct node
{
	char name[100];
	struct node* sibling;
	struct node* child;
};
struct node* createnode(char *);
void printtree(struct node*, int);
%}

%union 
{
	struct node* root;
}
%token <root> NUM FLOAT CNAME DTYPE TABLE SELECT INSERT VALUES CREATE DROP DELETE UPDATE ENDQ FROM WHERE SET GROUP HAVING ORDER AGGRE AS DEFAULT PRIMKEY NOTNULL UNIQUE NOT
%token <root> EQUAL STRING ADD SUB MUL DIV ASC DESC LT GT LE GE EQ NE LIKE IN BETWEEN '(' ')' ',' AND OR

%type <root> start command command_list command_list1 create drop delete delete_where insert insert_values update update_where select select_where
%type <root> column_name column_name_as column_name_more expr expr1 values values1 identifier identifier1 columniter columniter1 id dtype constraints constraint condition cond1 cond2 cond3 term term1 term2

%left '(' ')'
%right NOT
%left MUL DIV
%left ADD SUB
%left LT LE
%left GT GE
%left EQ NE
%left AND
%left OR
%right EQUAL

%%
start:
	command_list 
	{
		$$=createnode("start");
		$$->child=$1;
		printtree($$,0);

	}
	;

command_list:
	command ENDQ command_list1	
	{
		$$=createnode("command_list");
		$2=createnode("ENDQ\n");
		$$->child=$1;
		$1->sibling=$2;
		$2->sibling=$3;
	}
	;

command_list1:
	command_list
	{
		$$=createnode("command_list1");
		$$->child=$1;
		
	}
	| {$$=createnode("");}
	;

command:
	create
	{
		$$=createnode("command");
		$$->child=$1;
		
	}
	| drop
	{
		$$=createnode("command");
		$$->child=$1;
		
	}
	| delete
	{
		$$=createnode("command");
		$$->child=$1;
		
	}
	| insert
	{
		$$=createnode("command");
		$$->child=$1;
		
	}
	| update
	{
		$$=createnode("command");
		$$->child=$1;
		
	}
	| select
	{
		$$=createnode("command");
		$$->child=$1;
		
	}
	| expr
	;

create:
	CREATE TABLE CNAME '(' identifier ')'
	{
		$$=createnode("create");
		$1=createnode("CREATE");
		$2=createnode("TABLE");
		$3=createnode("CNAME");
		$4=createnode("BOPEN");
		$6=createnode("BCLOSE");
		$$->child=$1;
		$1->sibling=$2;
		$2->sibling=$3;
		$3->sibling=$4;
		$4->sibling=$5;
		$5->sibling=$6;
	}
	;

drop:
	DROP TABLE CNAME
	{
		$$=createnode("drop");
		$1=createnode("DROP");
		$2=createnode("TABLE");
		$3=createnode("CNAME");
		$$->child=$1;
		$1->sibling=$2;
		$2->sibling=$3;
		
	}
	;

delete:
	DELETE FROM CNAME delete_where
	{
		$$=createnode("delete");
		$1=createnode("DELETE");
		$2=createnode("FROM");
		$3=createnode("CNAME");
		$$->child=$1;
		$1->sibling=$2;
		$2->sibling=$3;
		$3->sibling=$4;		
	}
	;

delete_where:
	WHERE condition
	{
		$$=createnode("delete_where");
		$1=createnode("WHERE");
		$$->child=$1;
		$1->sibling=$2;		
	}
	| {$$=createnode("");}
	;

insert:
	INSERT CNAME insert_values
	{
		$$=createnode("insert");
		$1=createnode("INSERT");
		$2=createnode("CNAME");
		$$->child=$1;
		$1->sibling=$2;
		$2->sibling=$3;		
	}
	;

insert_values:
	'('columniter')' VALUES'('values')'
	{
		$$=createnode("insert_values");
		$1=createnode("BOPEN");
		$3=createnode("BCLOSE");
		$4=createnode("VALUES");
		$5=createnode("BOPEN");
		$7=createnode("BCLOSE");
		$$->child=$1;
		$1->sibling=$2;
		$2->sibling=$3;
		$3->sibling=$4;
		$4->sibling=$5;
		$5->sibling=$6;
		$6->sibling=$7;		
	}
	| VALUES'('values')'
	{
		$$=createnode("create");
		$1=createnode("VALUES");
		$2=createnode("BOPEN");
		$4=createnode("BCLOSE");
		$$->child=$1;
		$1->sibling=$2;
		$2->sibling=$3;
		$3->sibling=$4;
		
	}
	;

update: 
	UPDATE CNAME SET expr update_where
	{
		$$=createnode("update");
		$1=createnode("CNAME");
		$2=createnode("SET");
		$$->child=$1;
		$1->sibling=$2;
		$2->sibling=$3;
		$3->sibling=$4;
		$4->sibling=$5;
		
	}
	;

update_where: 
	WHERE condition
	{
		$$=createnode("update_where");
		$1=createnode("WHERE");
		$$->child=$1;
		$1->sibling=$2;
		
	}
	| {$$=createnode("");}
	;

select:
	SELECT column_name FROM CNAME select_where
	{
		$$=createnode("select");
		$1=createnode("SELECT");
		$3=createnode("FROM");
		$4=createnode("CNAME");
		$$->child=$1;
		$1->sibling=$2;
		$2->sibling=$3;
		$3->sibling=$4;
		$4->sibling=$5;
		
	}
	| SELECT MUL FROM CNAME select_where
	{
		$$=createnode("select");
		$1=createnode("SELECT");
		$2=createnode("MUL");
		$3=createnode("FROM");
		$4=createnode("CNAME");
		$$->child=$1;
		$1->sibling=$2;
		$2->sibling=$3;
		$3->sibling=$4;
		$4->sibling=$5;
		
	}
	;

select_where:
	WHERE condition
	{
		$$=createnode("select_where");
		$1=createnode("WHERE");
		$$->child=$1;
		$1->sibling=$2;
		
	}
	| {$$=createnode("");}
	;


column_name:
	CNAME column_name_as
	{
		$$=createnode("column_name");
		$1=createnode("CNAME");
		$$->child=$1;
		$1->sibling=$2;
		
	}
	;

column_name_as:
	AS CNAME column_name_more
	{
		$$=createnode("column_name_as");
		$1=createnode("AS");
		$2=createnode("CNAME");
		$$->child=$1;
		$1->sibling=$2;
		$2->sibling=$3;
		
	}
	| column_name_more
	{
		$$=createnode("column_name_as");
		$$->child=$1;
		
	}
	;

column_name_more:
	','column_name
	{
		$$=createnode("column_name_more");
		$1=createnode("COMMA");
		$$->child=$1;
		$1->sibling=$2;
		
	}
	| {$$=createnode("");}
	;


expr:
	CNAME EQUAL term1 expr1
	{
		$$=createnode("expr");
		$1=createnode("EQUAL");
		$$->child=$1;
		$1->sibling=$2;
		$2->sibling=$3;
		$3->sibling=$4;		
	}
	;

expr1:
	',' expr
	{
		$$=createnode("expr1");
		$1=createnode("COMMA");
		$$->child=$1;
		$1->sibling=$2;
		
	}
	| {$$=createnode("");}
	;

values:
	term1 values1
	{
		$$=createnode("values");
		$$->child=$1;
		$1->sibling=$2;
		
	}
	;

values1:
	',' values
	{
		$$=createnode("values1");
		$1=createnode("COMMA");
		$$->child=$1;
		$1->sibling=$2;
		
	}
	| {$$=createnode("");}
	;

identifier:
	id identifier1
	{
		$$=createnode("identifier");
		$$->child=$1;
		$1->sibling=$2;
		
	}
	;

identifier1:
	','identifier
	{
		$$=createnode("identifier1");
		$1=createnode("COMMA");
		$$->child=$1;
		$1->sibling=$2;
		
	}
	| {$$=createnode("");}
	;

columniter:
	CNAME columniter1
	{
		$$=createnode("columniter");
		$1=createnode("CNAME");
		$$->child=$1;
		$1->sibling=$2;
		
	}
	;

columniter1:
	','columniter
	{
		$$=createnode("columniter1");
		$1=createnode("COMMA");
		$$->child=$1;
		$1->sibling=$2;
		
	}
	| {$$=createnode("");}
	;

id:
	CNAME dtype
	{
		$$=createnode("id");
		$1=createnode("CNAME");
		$$->child=$1;
		$1->sibling=$2;		
	}
	;

dtype:
	DTYPE '('NUM')' constraints
	{
		$$=createnode("dtype");
		$1=createnode("DTYPE");
		$2=createnode("BOPEN");
		$3=createnode("NUM");
		$4=createnode("BCLOSE");
		$$->child=$1;
		$1->sibling=$2;
		$2->sibling=$3;
		$3->sibling=$4;
		$4->sibling=$5;
		
	}
	| DTYPE constraints
	{
		$$=createnode("dtype");
		$1=createnode("DTYPE");
		$$->child=$1;
		$1->sibling=$2;
		
	}
	;

constraints:
	constraint constraints
	{
		$$=createnode("constraints");
		$$->child=$1;
		$1->sibling=$2;
		
	}
	| {$$=createnode("");}
	;

constraint:
	NOTNULL
	{
		$$=createnode("constraint");
		$1=createnode("NOTNULL");
		$$->child=$1;
		
	}
	| PRIMKEY
	{
		$$=createnode("constraint");
		$1=createnode("PRIMKEY");
		$$->child=$1;
		
	}
	| UNIQUE
	{
		$$=createnode("constraint");
		$1=createnode("UNIQUE");
		$$->child=$1;
		
	}
	| DEFAULT term1
	{
		$$=createnode("constraint");
		$1=createnode("DEFAULT");
		$$->child=$1;
		$1->sibling=$2;
		
	}
	;

condition:
	term cond1
	{
		$$=createnode("condition");
		$$->child=$1;
		$1->sibling=$2;
		
	}
	| NOT '('condition')'
	{
		$$=createnode("condition");
		$1=createnode("NOT");
		$2=createnode("BOPEN");
		$4=createnode("BCLOSE");
		$$->child=$1;
		$1->sibling=$2;
		$2->sibling=$3;
		$3->sibling=$4;
		
	}
	;
	
cond1:
	EQUAL cond2
	{
		$$=createnode("cond1");
		$1=createnode("EQUAL");
		$$->child=$1;
		$1->sibling=$2;
		
	}
	| NE cond2
	{
		$$=createnode("cond1");
		$1=createnode("NE");
		$$->child=$1;
		$1->sibling=$2;
		
	}
	| LE cond2
	{
		$$=createnode("cond1");
		$1=createnode("LE");
		$$->child=$1;
		$1->sibling=$2;
		
	}
	| GE cond2
	{
		$$=createnode("cond1");
		$1=createnode("GE");
		$$->child=$1;
		$1->sibling=$2;
		
	}
	| LT cond2
	{
		$$=createnode("cond1");
		$1=createnode("LT");
		$$->child=$1;
		$1->sibling=$2;
		
	}
	| GT cond2
	{
		$$=createnode("cond1");
		$1=createnode("GT");
		$$->child=$1;
		$1->sibling=$2;
		
	}
	| LIKE STRING cond3
	{
		$$=createnode("cond1");
		$1=createnode("LIKE");
		$2=createnode("STRING");
		$$->child=$1;
		$1->sibling=$2;
		$2->sibling=$3;
		
	}
	| BETWEEN term2 AND term2 cond3
	{
		$$=createnode("cond1");
		$1=createnode("BETWEEN");
		$3=createnode("AND");
		$$->child=$1;
		$1->sibling=$2;
		$2->sibling=$3;
		$3->sibling=$4;
		$4->sibling=$5;
		
	}
	;

cond2:
	term cond3
	{
		$$=createnode("cond2");
		$$->child=$1;
		$1->sibling=$2;		
	}
	;

cond3:
	AND condition
	{
		$$=createnode("cond3");
		$1=createnode("AND");
		$$->child=$1;
		$1->sibling=$2;
		
	}
	| OR condition
	{
		$$=createnode("cond3");
		$1=createnode("OR");
		$$->child=$1;
		$1->sibling=$2;
		
	}
	| {$$=createnode("");}
	;

term:
	NUM
	{
		$$=createnode("term");
		$1=createnode("NUM");
		$$->child=$1;		
	}
	| FLOAT
	{
		$$=createnode("term");
		$1=createnode("FLOAT");
		$$->child=$1;
		
	}
	| CNAME
	{
		$$=createnode("term");
		$1=createnode("CNAME");
		$$->child=$1;
		
	}
	| STRING
	{
		$$=createnode("term");
		$1=createnode("STRING");
		$$->child=$1;
		
	}
	;

term1:
	NUM
	{
		$$=createnode("term1");
		$1=createnode("NUM");
		$$->child=$1;
		
	}
	| FLOAT
	{
		$$=createnode("term1");
		$1=createnode("FLOAT");
		$$->child=$1;
		
	}
	| STRING
	{
		$$=createnode("term1");
		$1=createnode("STRING");
		$$->child=$1;
		
	}
	;

term2:
	NUM
	{
		$$=createnode("term2");
		$1=createnode("NUM");
		$$->child=$1;
		
	}
	| FLOAT
	{
		$$=createnode("term2");
		$1=createnode("FLOAT");
		$$->child=$1;
		
	}
	;

%%
int main() 
{
	yyin=fopen("sample.sql","r");
	do
	{
		yyparse();
	}while (!feof(yyin));
	printf("\n\nQuery parsed\n");
}

void yyerror(const char *s) 
{
	printf("ERROR.\nLine : %d\n", line_no);
	exit(-1);
}

struct node* createnode(char name[50])
{
	struct node* temp=(struct node *) malloc (sizeof(struct node));
	strcpy(temp->name,name);
	temp->sibling=NULL;
	temp->child=NULL;
	return temp;
}

void printtree(struct node* root,int h)
{
	for(int i=0;i<h;i++)
	{
		printf("->  ");
	}
	printf("%s\n",root->name);
	
	if(root->child!=NULL)
	{
		printtree(root->child,h+1);
	}
	while(root->sibling!=NULL)
	{
		root=root->sibling;
		for(int i=0;i<h;i++)
		{
			printf("->  ");
		}
		printf("%s\n",root->name);
		if(root->child!=NULL)
		{
			printtree(root->child,h+1);
		}
	}	
}
