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



int main(int argc, char** argv){
  FILE *gold = 0;
  int token = 0;
  int answar = 0;
  int nota = 0;
  int i=1;
      fprintf(stderr,"Rodando main do prof. \n");

  if (argc < 3)
    {
    printf("call: ./etapa1 input.txt output.txt \n");
    exit(1);
    }
  if (0==(yyin = fopen(argv[1],"r")))
    {
    printf("Cannot open file %s... \n",argv[1]);
    exit(1);
    }
  if (0==(gold = fopen(argv[2],"r")))
    {
    printf("Cannot open file %s... \n",argv[2]);
    exit(1);
    }

  initMe();
  while (isRunning()){
    token = yylex();
    // getLineNumber(); 
    if (!isRunning())
      break;
    fscanf(gold,"%d",&answar);
    if (token == answar) {
      
      fprintf(stderr,"\n%d=ok(%s)  ",i,yytext  );
      ++nota;
    }else
      fprintf(stderr,"\n%d=ERROR(%s,%d,%d) ",i,yytext,token,answar );
   ++i;
  }

  printf("NOTA %d\n\n",nota);  
  fprintf(stderr,"NOTA %d\n\n",nota);  
  //hashPrint();

  //char *text = "teste";
  //HASH_NODE *node = hashFind(text);
  //if(node!=NULL){
  //printf("\nHash find: %s\n", node->text);
  //}else{
  //	printf("\nHash \"%s\" not find\n",text);
  //}

}

  
