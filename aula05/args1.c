#include <stdio.h>
#include <stdlib.h>

int main( int argc, char *argv[] )
{
    if (argc==3){
    char *s;
    char *r;
    
    int i;
     
    printf("args adress:%p \n ",(void*)&argv);
    printf("ddd: %s \n", argv[2]);
    for(i = 0 ; i < argc ; i++)
    {
        printf("Argumento numero: %02d: \"%s\"\n", i, argv[i]);
       
    }
    
    printf("%d \n",(int) (strtod( argv[1],&s) + strtod(argv[2],&r)));

    return EXIT_SUCCESS;
    }
    else {
        printf("deste %02d argumentos e devias dar so 2\n", argc-1); 
    return EXIT_FAILURE;
    }
}
