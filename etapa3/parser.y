%{

//Jéssica Salvador Rodrigues da Rocha e Matheus Pereira

#include <stdio.h>
#include <stdlib.h>
#include "ast.h"
#include "decompiler.h"

int yylex();
int yyerror(char *text);

extern int getLineNumber();

%}

%union {
	HASH_NODE *symbol;
	char *charValue;
	struct AST_s *node;
	int token;
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

%token<symbol> LIT_INTEGER
%token<symbol> LIT_FLOAT
%token<symbol> LIT_CHAR
%token<symbol> LIT_STRING
%token<symbol> TK_IDENTIFIER

%token TOKEN_ERROR

%type <node> program
%type <node> definitions

%type <node> param_list
%type <node> param

%type <node> cmd_block
%type <node> cmd_list
%type <node> cmd

%type <node> expr
%type <node> args
%type <node> expr_list

%type <node> string_expr
%type <node> def

%type <node> lit_list
%type <node> lit

%type <token> type

%start program


%left OPERATOR_OR
%left OPERATOR_AND
%left '!' OPERATOR_EQ 
%left '>' OPERATOR_GE
%left '<' OPERATOR_LE
%left '+' '-'
%left '*' '/'
%right 'q''p'
%right 'd''b'

%%

program: definitions{ 
		$$ = astCreate(AST_PROGRAM,0,$1,0,0,0);
		astPrint(astSetRoot($$),0);
		decompile($$);
	}
	;

definitions: def definitions { 
		if($1 != 0) {
			$$ = astCreate(AST_DEC_LIST,0,$1,$2,0,0);
			} else {
				$$ = $2;
			}
	}
	| {$$ = 0;}
	;

def:
	type TK_IDENTIFIER '=' lit ';' {
		$$ = astCreate(AST_DEC_VALUE,$2,$4,0,0,0);
		$$->dataType = $1;
	}
	|
	type TK_IDENTIFIER 'q' LIT_INTEGER 'p' ';' {
		AST *size = astCreate(AST_SYMBOL,$4,0,0,0,0);
		$$ = astCreate(AST_DEC_VECTOR,$2,size,0,0,0);
		$$->dataType = $1;
	}
        |
        type TK_IDENTIFIER 'q' LIT_INTEGER 'p' ':' lit_list ';' {
		AST *size = astCreate(AST_SYMBOL,$4,0,0,0,0);
		$$ = astCreate(AST_DEC_VECTOR_INIT,$2, size,$7,0,0);
		$$->dataType = $1;
	}
	|
        type '#' TK_IDENTIFIER '=' lit ';' {
		$$ = astCreate(AST_DEC_POINTER,$3, $5,0,0,0);
		$$->dataType = $1;
	}
        |
        type TK_IDENTIFIER 'd' param_list 'b' cmd_block {
		$$ = astCreate(AST_DEC_FUNC,$2,$4,$6,0,0);
		$$->dataType = $1;
	}
	;
	

param_list: 
	param ',' param_list { 
		if($3 != 0) {
			$$ = astCreate(AST_PARAM_LIST,0, $1,$3,0,0);
		} else {
			$$ = $1;
		}
	}
	|
	param {
		$$ = astCreate(AST_PARAM_LIST, 0, $1,0,0,0);
	}
	| { $$ = 0; }
	;

param: type TK_IDENTIFIER {
		$$ = astCreate(AST_PARAM,$2 ,0,0,0,0);
		$$->dataType = $1;
	}
	;

cmd_block: '{' cmd_list '}' {$$ = astCreate(AST_BLOCK,0,$2,0,0,0);}
	;

cmd_list: 
        cmd ';' cmd_list {
		if($1 != 0) {
			$$ = astCreate(AST_CMD_LIST,0,$1,$3,0,0);
		} else {
			$$ = $3;
		}
	}
	|
	cmd {
		if($1 != 0) {
			$$ = astCreate(AST_CMD_LIST,0,$1,0,0,0);
		}
	}
	;

cmd: 
        cmd_block {$$ = $1;}
	|
	TK_IDENTIFIER '=' expr {$$ = astCreate(AST_VALUE_ASS,$1,$3,0,0,0);}
	|
	TK_IDENTIFIER 'q' expr 'p' '=' expr {$$ = astCreate(AST_VECTOR_ASS,$1, $3,$6,0,0);}
	|
	KW_READ TK_IDENTIFIER {$$ = astCreate(AST_READ,$2,0,0,0,0);}
	|
	KW_PRINT expr_list {$$ = astCreate(AST_PRINT,0,$2,0,0,0);}
	|
	KW_RETURN expr {$$ = astCreate(AST_RETURN,0,$2,0,0,0);}
	|
	KW_IF expr KW_THEN cmd {$$ = astCreate(AST_IF_THEN,0,$2,$4,0,0);}
	|
	KW_IF expr KW_THEN cmd KW_ELSE cmd {$$ = astCreate(AST_IF_THEN_ELSE,0,$2,$4,$6,0);}
	|
	KW_WHILE expr cmd {$$ = astCreate(AST_WHILE,0,$2,$3,0,0);}
	| {$$ = 0;}
	;


expr:
        '!' expr {$$ = astCreate(AST_NOT,0,$2,0,0,0);}
	|
	'd' expr 'b' {$$ = $2;}
	|
	TK_IDENTIFIER {$$ = astCreate(AST_SYMBOL,$1,0,0,0,0);}
	|
	TK_IDENTIFIER 'q' expr 'p' {$$ = astCreate(AST_VECTOR_ACCESS,$1,$3,0,0,0);}
	|
	'&' TK_IDENTIFIER {$$ = astCreate(AST_SYMBOL_ADDRESS,$2,0,0,0,0);}
	|
	'#' TK_IDENTIFIER {$$ = astCreate(AST_SYMBOL_POINTER,$2,0,0,0,0);}
	|
	lit {$$ = $1;}
	|
	TK_IDENTIFIER 'd' args 'b' {$$ = astCreate(AST_INVOKE_FUNC,$1,$3,0,0,0);}
	|
	TK_IDENTIFIER 'd' 'b' {$$ = astCreate(AST_INVOKE_FUNC,$1,0,0,0,0);}
        |
        expr '+' expr {$$ = astCreate(AST_ADD,0,$1,$3,0,0);}
	|
	expr '-' expr {$$ = astCreate(AST_SUB,0,$1,$3,0,0);}
	|
	expr '*' expr {$$ = astCreate(AST_MULT,0,$1,$3,0,0);}
	|
	expr '/' expr {$$ = astCreate(AST_DIV,0,$1,$3,0,0);}
	|
	expr '<' expr {$$ = astCreate(AST_LESS,0,$1,$3,0,0);}
	|
	expr '>' expr {$$ = astCreate(AST_GREATER,0,$1,$3,0,0);}
	|
        expr OPERATOR_LE expr {$$ = astCreate(AST_LESS_EQ,0,$1,$3,0,0);}
	|
	expr OPERATOR_GE expr {$$ = astCreate(AST_GREATER_EQ,0,$1,$3,0,0);}
	|
	expr OPERATOR_EQ expr {$$ = astCreate(AST_EQ,0,$1,$3,0,0);}
	|
	expr OPERATOR_NOT expr {$$ = astCreate(AST_NOT,0,$1,$3,0,0);}
	|
	expr OPERATOR_AND expr {$$ = astCreate(AST_AND,0,$1,$3,0,0);}
	|
	expr OPERATOR_OR expr {$$ = astCreate(AST_OR,0,$1,$3,0,0);}
	;

args: 
    expr ',' args {$$ = astCreate(AST_ARG_LIST,0,$1,$3,0,0);}
    | 
    expr {$$ = $1;}
    ; 

expr_list: 
        string_expr ',' expr_list {
		if($3 != 0) {
			$$ = astCreate(AST_ELEM_LIST,0,$1,$3,0,0);
		} else {
			$$ = astCreate(AST_ELEM_LIST,0,$1,0,0,0);
		}
	}
	| string_expr
	| {$$ = 0;}
	;

string_expr: LIT_STRING {$$ = astCreate(AST_SYMBOL, $1, 0,0,0,0);}
	| expr {$$ = $1;}
	;

type:
        KW_CHAR {$$ = KW_CHAR;}
	|
	KW_INT {$$ = KW_INT;}
	|
	KW_FLOAT {$$ = KW_FLOAT;}
	;

lit_list: lit lit_list { $$ = astCreate(AST_VALUE_LIST,0,$1,$2,0,0); }
	| {$$ = 0;}
	;

lit: 
	LIT_INTEGER {
		$$ = astCreate(AST_SYMBOL,$1,0,0,0,0);
	}
	|
	LIT_FLOAT {
		$$ = astCreate(AST_SYMBOL,$1,0,0,0,0);
	}
	|
	LIT_CHAR {
		$$ = astCreate(AST_SYMBOL,$1,0,0,0,0);
	}
	;

%%

int yyerror(char *text) 
{
    printf("Erro na linha: %d\n", getLineNumber());
    exit(3);
}
