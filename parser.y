%{

#include <stdio.h>
#include <stdlib.h>
#include "hash.h"

int yylex();
int yyerror(char *text);

%}

%union { HASH_NODE *symbol; }

%token KW_CHAR
%token KW_INT
%token KW_FLOAT
%token KW_IF
%token KW_THEN
%token KW_ELSE
%token KW_WHILE
%token KW_READ
%token KW_RETURN
%token KW_PRINT
%token OPERATOR_LE
%token OPERATOR_GE
%token OPERATOR_EQ
%token OPERATOR_OR
%token OPERATOR_AND
%token OPERATOR_NOT

%token<symbol> TK_IDENTIFIER
%token<symbol> LIT_INTEGER
%token<symbol> LIT_FLOAT
%token<symbol> LIT_CHAR
%token<symbol> LIT_STRING

%token TOKEN_ERROR


%start program

%left '<' '>'
%left '+' '-'
%left '*' '/'

%%

program: definitions
	;

definitions: def definitions
	|
	;

def: func_def
	| var_def
	;

func_def: header block
	;

header: type TK_IDENTIFIER 'd' param_list 'b'
	;

param_list: type TK_IDENTIFIER param
	|
	;

param: ',' type TK_IDENTIFIER param
	|
	;

block: '{' cmd_list '}'
	;

cmd_list: cmd ';' cmd_list
	| cmd
	;

cmd: TK_IDENTIFIER '=' expr
	| TK_IDENTIFIER 'q' expr 'p' '=' expr
	| KW_READ TK_IDENTIFIER
	| KW_PRINT expr_list
	| KW_RETURN expr
	| KW_IF expr KW_THEN cmd
	| KW_IF expr KW_THEN cmd KW_ELSE cmd
	| KW_WHILE expr cmd
	| block
	|
	;

expr:   LIT_INTEGER { fprintf(stderr,"achei int" ); } 
	| LIT_FLOAT
        | LIT_CHAR

	| TK_IDENTIFIER
        | TK_IDENTIFIER 'q' expr 'p'
	| TK_IDENTIFIER 'd' args 'b'
	| 'd' expr 'b'
	
	| expr '+' expr
	| expr '-' expr
	| expr '*' expr
	| expr '/' expr
	| expr '<' expr
	| expr '>' expr
	| expr OPERATOR_AND expr
	| expr OPERATOR_LE expr
	| expr OPERATOR_GE expr
	| expr OPERATOR_EQ expr
	| expr OPERATOR_OR expr
	| expr OPERATOR_NOT expr
     	;

args: args_list
    |
    ;

args_list: expr ',' args_list
    | expr
    ;

expr_list: string_expr ',' expr_list
	| string_expr
	;

string_expr: LIT_STRING
	| expr
	;

var_def: type TK_IDENTIFIER '=' literal ';'
	| type TK_IDENTIFIER 'q' LIT_INTEGER 'p' ':' literal_list ';'
	| type TK_IDENTIFIER 'q' LIT_INTEGER 'p' ';'
	;

type: KW_CHAR
	| KW_INT
	| KW_FLOAT
	;

literal_list: literal literal_list
	|
	;

literal: LIT_INTEGER
	| LIT_FLOAT
	| LIT_CHAR
	;

%%

int yyerror(char *text) 
{
    printf("Erro na linha: %d\n", getLineNumber());
    exit(3);
}
