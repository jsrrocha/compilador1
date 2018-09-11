#include <stdio.h>
#include <stdlib.h>
#include "hash.h"
#include "y.tab.h"

extern void initMe();
extern int getLineNumber();
extern int isRunning();

extern void hashPrint();
extern char *yytext;
extern FILE *yyin;

extern int yylex();
extern int yyparse();


int main(int argc, char** argv) {
	fprintf(stderr,"Rodando main do prof. \n");
	initMe();
	

	if (argc < 2) {
    		printf("call: ./etapa1 input.txt \n");
    		exit(1);
    	}
 
	FILE *input; 

        if (0==(input = fopen(argv[1],"r"))){
    		printf("Não foi possivel abrir o arquivo:  %s... \n",argv[1]);
    		exit(1);
    	}
    
	if (input == NULL) {
       	 	fprintf(stderr, "Erro na abertura do arquivo de entrada\n");
        	exit(1);
        }

    	yyin = input;
	yyparse();
	
	hashPrint();
	return 0;
}


