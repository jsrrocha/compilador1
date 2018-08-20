// Jéssica S.R.Rocha e Matheus Pereira

%{
//declaração de variaveis e includes

#include "tokens.h"


%}


//regras:

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
"while"{ 
	return KW_WHILE;
}
"for" {
	return KW_FOR;
}
"read"{
	return KW_READ;
}
"return" {
	return KW_RETURN;
}
"print" { 	
	return KW_PRINT;
}



[0-9]+ {
	return LIT_INTEGER;
}

[a-zA-Z_][0-9a-zA-Z_]* { 
	return TK_IDENTIFIER;
}




%%

//código
