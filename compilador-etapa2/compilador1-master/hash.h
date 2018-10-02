

#define TEXT_MAX_LENGTH 256
#define HASH_SIZE 997


typedef struct NODE
{
    char *text;
    int type;
    struct NODE *next;

} HASH_NODE;

HASH_NODE *Table[HASH_SIZE];

void hashInit(void);
int hashAddress(char *text);
HASH_NODE* hashInsert(int type,char *text);
HASH_NODE* hashFind(char *text);
void hashPrint(void);


