
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "hash.h"
#include "y.tab.h"



//Jéssica Salvador Rodrigues da Rocha e Matheus Pereira

void hashInit(){
    int i;
    for(i=0;i<HASH_SIZE;i++){
        Table[i]=0;
    }
}

int hashAddress(char *key){
    int i;
    int address = 1;
    for(i= 0;i<strlen(key);i++){
        address = (address*key[i]) %HASH_SIZE + 1;

    }
    return address -1;
}

HASH_NODE* hashInsert(int type,char *key){

    HASH_NODE *newnode;
    int address;
    address = hashAddress(key);

    if (newnode = hashFind(key)){
        return newnode;
    }
    newnode = (HASH_NODE*) calloc(1,sizeof(HASH_NODE));
    newnode->type =type;
    newnode->key = calloc(strlen(key) + 1,sizeof(char));
    strcpy(newnode->key,key);
    newnode->next = Table[address];
    Table[address] = newnode;
    
    char *ptr;
    switch(type) {
		case LIT_INTEGER:
			newnode->intValue = strtol(key,&ptr,10);
			break;
		case LIT_FLOAT:
			newnode->doubleValue = strtod(key,&ptr);
			break;
		case LIT_CHAR:
			newnode->charValue = key[1];
			break;
		case LIT_STRING:
			snprintf(newnode->stringValue, TEXT_MAX_LENGTH, "%s", key);
			break;
		case TK_IDENTIFIER:
			snprintf(newnode->stringValue, TEXT_MAX_LENGTH, "%s", key);
			break;
	}

    return newnode;
}


HASH_NODE* hashFind(char *key){
    int address;
    address = hashAddress(key);
    HASH_NODE *newnode;

    for (newnode = Table[address]; newnode; newnode = newnode->next) {
        if (!strcmp(key, newnode->key))
            return newnode;
    }

    return 0;
}


void hashPrint(void){
    HASH_NODE *node;
    int i;
    for(i=0;i<HASH_SIZE;i++){
        for(node=Table[i]; node; node = node->next){
            fprintf(stderr,"table[%d] has %s with type %d\n",i,node->key,node->type);
        }
    }
}





