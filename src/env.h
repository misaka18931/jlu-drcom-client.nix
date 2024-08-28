typedef struct {
    char *username;
    char *passwd;
    char *ip_addr;
    char hw_addr[7];
} Credential;

void get_credential(Credential* cred);