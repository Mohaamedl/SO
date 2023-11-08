#include <stdio.h>
#include <stdlib.h>

int main( int argc, char *argv[] )
{
    if (argc==3){
    char s[30];
    argv[2] = "dsd";
    int i;
    
    printf("args adress:%p \n ",(void*)&argv);
    printf("ddd: %s \n", argv[2]);
    for(i = 0 ; i < argc ; i++)
    {
        printf("Argumento numero: %02d: \"%s\"\n", i, argv[i]);
       
    }
    print(strtod( argv[1]) + strtod(argv[0]));

    return EXIT_SUCCESS;
    }
    else {
        printf("deste %02d argumentos e devias dar so 2\n", argc-1); 
    return EXIT_FAILURE;
    }
}
