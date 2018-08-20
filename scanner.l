
%{


#include "tokens.h"

int lineNumber = 1;
int running = 1;


%}


%%

"char" {
	return KW_CHAR;
}
"int" {
	return KW_INT;
}
"float" { 
	return KW_FLOAT;
}
"if" {
	return KW_IF; 
}
"then" {
	return KW_THEN;
}
"else" {
	return KW_ELSE;
}
"while" { 
	return KW_WHILE;
}
"read" {
	return KW_READ;
}
"return" {
	return KW_RETURN;
}
"print" { 	
	return KW_PRINT;
}



"<=" {
 	return OPERATOR_LE;
}

">=" {
 	return OPERATOR_GE;
}
"==" {
 	return OPERATOR_EQ;
}

"&&" {
 	return OPERATOR_AND;
}

"||" {
 	return OPERATOR_OR;
}
"!=" {
 	return OPERATOR_NOT;
}


[a-zA-Z_][a-zA-Z_0-9]* { 
	return TK_IDENTIFIER;
}

[0-9]+ {
	return LIT_INTEGER;
}

[0-9]+\.[0-9]+ {
	return LIT_FLOAT;
}

'.' {
	return LIT_CHAR;
}

\"([^"]|\\\"|\\n)*\" {
	return LIT_STRING;
}


[-,;:dbqp{}+*/<>=!&$#] { 
 	return yytext[0];
}

"\n" {
	lineNumber =  lineNumber + 1;
}

. {
	return TOKEN_ERROR;
}




%%

//Jéssica Salvador Rodrigues da Rocha e Matheus Pereira

//nao tenho certeza se a regra do yytext está correta  e ARRUMAR DO CHAR E STRING !

#include "main.c"

//código

void initMe() {
	printf("init()\n");
	running = 1;
}


int getLineNumber(void) {
	return lineNumber;
}

int isRunning(void) {
	return running;
}

int yywrap(void) {
	running = 0;
	return 1;
}

