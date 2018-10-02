

#define TEXT_MAX_LENGTH 256
#define HASH_SIZE 997


typedef struct NODE
{
    char *key;
    int type;
    char stringValue[TEXT_MAX_LENGTH];
    long int intValue;
    double doubleValue;
    char charValue;
    struct NODE *next;

} HASH_NODE;

HASH_NODE *Table[HASH_SIZE];

void hashInit(void);
int hashAddress(char *key);
HASH_NODE* hashInsert(int type,char *key);
HASH_NODE* hashFind(char *key);
void hashPrint(void);


