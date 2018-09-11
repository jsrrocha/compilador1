
%{

#include "hash.h"
#include "y.tab.h"

extern int yylineno;
int running = 1;

extern int getLineNumber(void);

%}


%x COMMENT

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
"or" { 
	return OPERATOR_OR;
}
"and" { 
	return OPERATOR_AND;
}
"not" { 
	return OPERATOR_NOT;
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


[0-9]+ {
	yylval.symbol = hashInsert(LIT_INTEGER,yytext);
	return LIT_INTEGER;
}

[0-9]+\.[0-9]+ {
	yylval.symbol = hashInsert(LIT_FLOAT,yytext);
	return LIT_FLOAT;
}

[ace-or-zA-Z_0-9][a-zA-Z_0-9]* { 
        yylval.symbol = hashInsert(TK_IDENTIFIER,yytext);
	return TK_IDENTIFIER;
}


\'.\' {
	yylval.symbol = hashInsert(LIT_CHAR,yytext);
	return LIT_CHAR;
}

\"([^"]|\\\"|\\n)*\" {
	yylval.symbol = hashInsert(LIT_STRING,yytext);
	return LIT_STRING;
}


[-,;:dbqp{}+*\/<>=!&$#] { 
 	return yytext[0];
}

"\r\n" {
	yylineno++;
	
}

"//".* {}
"/*" { BEGIN(COMMENT); }
<COMMENT>"*/" { BEGIN(INITIAL); }
<COMMENT>"\n" { ++yylineno; }
<COMMENT>.

[ \t]+ ;
"/*"([^*]|\*+[^*/])*\*+"/" ;
\/\/.* ;	

. {
	return TOKEN_ERROR;
}




%%

//Jéssica Salvador Rodrigues da Rocha e Matheus Pereira

//nao tenho certeza se a regra do yytext está correta  e ARRUMAR DO CHAR E STRING !

#include "main.c"

//código

void initMe() {
	//printf("init()\n");
	running = 1;
        hashInit();
}


int getLineNumber(void) {
        //printf("\nlinha %d",yylineno);
	return yylineno;
}

int isRunning(void) {
	return running;
}

int yywrap(void) {
	running = 0;
	return 1;
}

