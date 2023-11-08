#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
/* SUGESTÂO: utilize as páginas do manual para conhecer mais sobre as funções usadas: rge gre ger ger ger ger ge gtgfdg ergfd erdfger dfgerdfgdfgerg ferd gerdg rdfg verdfgevrdfg vfh etfdg erdg erfgerfgde rgfdergerg erg er ger g erg
 man fopen
 man fgets
*/

#define LINEMAXSIZE 2 /* or other suitable maximum line size */


int main(int argc, char *argv[])
{
    FILE *fp = NULL;
    char line [LINEMAXSIZE]; 

    /* Validate number of arguments */
    if( argc < 2 )
    {
        printf("USAGE: %s fileName\n", argv[0]);
        return EXIT_FAILURE;
    }
    
    /* Open the file provided as argument */
    
    int i;
    int count = 1;
    
    for (i=1; i<argc ; i++ )
    {   
        errno = 0;
        
        fp = fopen(argv[i], "r");
        if( fp == NULL )
        {
            perror ("Error opening file!");
            return EXIT_FAILURE;
        }

        /* Read all the lines of the file */
        int complete = 1;
        while( fgets(line, sizeof(line), fp) != NULL )
        {   if (complete){
            printf("%d-> ",count);

            }
            printf("%s",line); 

            if ( strstr(line,"\n\0") == NULL ){
                complete  = 0;
            }
            else{
                complete = 1;
                count++;
            }
            
            /* not needed to add '\n' to printf because fgets will read the '\n' that ends each line in the file */
        }

        fclose(fp);

        
    }
    return EXIT_SUCCESS;
    
}
