#include <stdio.h>
#include <stdlib.h>
#include "decompiler.h"
#include <string.h>


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
	

	if (argc < 3) {
    		printf("call: ./etapa3 input.txt output.txt \n");
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

        FILE *output;
	output = fopen(argv[2],"w");
	if (output == NULL) {
		printf("Could not open output file: %s\n",argv[2]);
		exit(2);
	}
	setOutputFile(output);

    	yyin = input;
        int parseError=0;
	if( isRunning() ) {
		parseError=yyparse();

		if(parseError==1)
			exit(3);
		else if(parseError==0)
			exit(0);
	}
	//hashPrint();
	return 0;
	
}


