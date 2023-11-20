#include <stdlib.h>
#include <stdio.h>
#include <string.h>
int main(int argc, char *argv[]){
    char str[10000];
    int i;
    for (i = 1; i<argc;i++){
        if (i != 1){
            strcat(str," ");
        }
        strcat(str,argv[i]);
    }
    printf("Final string: %s\n",str);
    return EXIT_SUCCESS;
}