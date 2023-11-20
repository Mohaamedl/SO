#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
int main(int argc, char *argv[]){
    char *sortOrder ;
    sortOrder = getenv("SORTORDER");
    sortOrder = "desc"; // testing

    int i;

    if (sortOrder==NULL){
        for (i = 1; i<argc; i++){
        if (isalpha(argv[i][0])!=0){
            printf("%s",argv[i]);

        }
        printf("\n");
    }


    }
    else if (strcmp(sortOrder,"asc")==0){
        for (i = 1; i<argc; i++){
            if (isalpha(argv[i][0])!=0){
                for ( int i=1;i<argc;i++){
                    for (int j = i+1;j<argc;j++){
                        if(strcasecmp(argv[i],argv[j])>0){
                            sortOrder = argv[j];
                            argv[j] = argv[i];
                            argv[i] = sortOrder;
                        }
                    }
                }

            }
        }
        for (i = 0; i<argc; i++){
        if (isalpha(argv[i][0])!=0){
            printf("%s ",argv[i]);

        }
        }
        printf("\n");
        EXIT_SUCCESS;

    }
    else if(strcmp(sortOrder, "desc") == 0){
        for(i = argc - 1; i > 0; i--){
            if(isalpha(argv[i][0])){
               for (int i = 1; i<argc; i++){
                    for (int j = i + 1; j<argc; j++){
                        if (strcasecmp(argv[i], argv[j]) < 0){
                            sortOrder = argv[j];
                            argv[j] = argv[i];
                            argv[i] = sortOrder;
                        }
                    }       
                }    
            } 
        }     
        for (int i = 0; i < argc; i++){
            if(isalpha(argv[i][0])){
             printf("%s ", argv[i]);
            }
        }
    printf ("\n");
    EXIT_SUCCESS;
    }
    else{
        printf("Invalid sort order!\n");
        return EXIT_FAILURE;
    }
    return 0;
}