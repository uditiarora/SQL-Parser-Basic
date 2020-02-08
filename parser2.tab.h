/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_PARSER2_TAB_H_INCLUDED
# define YY_YY_PARSER2_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    NUM = 258,
    FLOAT = 259,
    CNAME = 260,
    DTYPE = 261,
    TABLE = 262,
    SELECT = 263,
    INSERT = 264,
    VALUES = 265,
    CREATE = 266,
    DROP = 267,
    DELETE = 268,
    UPDATE = 269,
    ENDQ = 270,
    FROM = 271,
    WHERE = 272,
    SET = 273,
    GROUP = 274,
    HAVING = 275,
    ORDER = 276,
    AGGRE = 277,
    AS = 278,
    DEFAULT = 279,
    PRIMKEY = 280,
    NOTNULL = 281,
    UNIQUE = 282,
    NOT = 283,
    EQUAL = 284,
    STRING = 285,
    ADD = 286,
    SUB = 287,
    MUL = 288,
    DIV = 289,
    ASC = 290,
    DESC = 291,
    LT = 292,
    GT = 293,
    LE = 294,
    GE = 295,
    EQ = 296,
    NE = 297,
    LIKE = 298,
    IN = 299,
    BETWEEN = 300,
    AND = 301,
    OR = 302
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 21 "parser2.y" /* yacc.c:1909  */

	struct node* root;

#line 106 "parser2.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_PARSER2_TAB_H_INCLUDED  */
