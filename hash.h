

#define TEXT_MAX_LENGTH 256
#define HASH_SIZE 1024 * 1024


typedef struct NODE
{
    char *text;
    int type;
    struct NODE *next;

} HASH_NODE;


int Table[HASH_SIZE];


void hashInit();
int hashAddress(char *text);
HASH_NODE* hashInsert(int type,char *text);
HASH_NODE* hashFind(char *text);
void hashPrint(void);
