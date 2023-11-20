#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h> // using isapha from here
int main(int argc, char *argv[]){
    char str[1000];
    int i;
    
    for (i = 1; i<argc;i++){
        if ((isalpha(argv[i][0])!=0) == 1){
             if (i != 1){
                strcat(str," ");
            }
            strcat(str,argv[i]);
        }
       
        
        
    }
    printf("Final string: %s\n",str);
    
    return EXIT_SUCCESS;
}