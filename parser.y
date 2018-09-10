%{

#include <stdio.h>
#include <stdlib.h>
#include "hash.h"

%}

%union { 
	HASH_NODE *symbol;
}

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

%%

program: definitions
	;

definitions: dec definitions
	|
	;

def: func_def
	| var_def
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

%%

int yyerror(char *text) 
{
    printf("Erro na linha: %d\n", getLineNumber());
    exit(3);
}
