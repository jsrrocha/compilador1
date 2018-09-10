
#include "hash.h"

//Jéssica Salvador Rodrigues da Rocha e Matheus Pereira

void hashInit(){
    int i;
    for(i=0;i<HASH_SIZE;i++){
        Table[i]=0;
    }
}

int hashAddress(char *text){
    int i;
    int address = 1;
    for(i= 0;i<strlen(text);i++){
        address = (address*text[i]) %HASH_SIZE + 1;

    }
    return address -1;
}

HASH_NODE* hashInsert(int type,char *text){

    HASH_NODE *newnode;
    int address;
    address = hashAddress(text);

    newnode = (HASH_NODE*) calloc(1,sizeof(HASH_NODE));
    newnode->type =type;
    newnode->text = calloc(strlen(text) + 1,sizeof(char));
    strcpy(newnode->text,text);
    newnode->next = Table[address];
    Table[address] = newnode;

    return newnode;
}



HASH_NODE* hashFind(char *text){
    int address;
    address = hashAddress(text);
    HASH_NODE *newnode;

    for (newnode = Table[address]; newnode; newnode = newnode->next) {
        if (!strcmp(text, newnode->text))
            return newnode;
    }

    return 0;
}



void hashPrint(void){
    HASH_NODE *node;
    int i;
    for(i=0;i<HASH_SIZE;i++){
        for(node=Table[i]; node; node = node->next){
            fprintf(stderr,"table[%d] has %s with type %d\n",i,node->text,node->type);
        }
    }
}



