#include <env.h>
#include <stdio.h>
#include <stdlib.h>

void get_credential(Credential *cred) {
    cred->username = getenv("JLU_USERNAME");
    if (cred->username == NULL) {
        fputs("environment not set: JLU_USERNAME\n", stderr);
        exit(EXIT_FAILURE);
    }
    cred->passwd = getenv("JLU_PASSWD");
    if (cred->passwd == NULL) {
        fputs("environment not set: JLU_PASSWD\n", stderr);
        exit(EXIT_FAILURE);
    }
    cred->ip_addr = getenv("JLU_IPADDR");
    if (cred->ip_addr == NULL) {
        fputs("environment not set: JLU_IPADDR\n", stderr);
        exit(EXIT_FAILURE);
    }
    const char *hw_addr = getenv("JLU_HWADDR");
    if (hw_addr == NULL) {
        fputs("environment not set: JLU_HWADDR\n", stderr);
        exit(EXIT_FAILURE);
    }
    if (sscanf(hw_addr, "%hhx:%hhx:%hhx:%hhx:%hhx:%hhx", &cred->hw_addr[0], &cred->hw_addr[1], &cred->hw_addr[2], &cred->hw_addr[3], &cred->hw_addr[4], &cred->hw_addr[5]) != 6) {
        fputs("error parsing hardware address\n", stderr);
        exit(EXIT_FAILURE);
    }
    cred->hw_addr[6] = '\0';
}
