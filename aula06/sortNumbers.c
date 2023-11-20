#include <stdio.h>
#include <stdlib.h>

/* SUGESTÂO: utilize as páginas do manual para conhecer mais sobre as funções usadas:
 man qsort
*/
#define LINEMAXSIZE 2
int compareInts(const void *px1, const void *px2)
{
    int x1 = *((int *)px1);
    int x2 = *((int *)px2);
    return(x1 < x2 ? -1 : x1 == x2 ? 0 : 1);
}

int main(int argc, char *argv[])
{
    int i;
    
    FILE *pf = NULL;
    int numbers[100];
    char line [LINEMAXSIZE];
    

    /* Memory allocation for all the numbers in the arguments */
    //numbers = (int *) malloc(sizeof(int) * numSize);

    /* Storing the arguments in the "array" numbers */
    // ler os numero no ficheiro
    for(i = 1 ; i < argc ; i++)
    {
        pf = fopen(argv[i],"r");
        if (pf == NULL){
            printf("error while opening file!");
            return EXIT_FAILURE;
        }
        // reading all the lines in the file
        int j=0;
        while (j<100 && fgets(line, sizeof(line),pf) != NULL){
            numbers[j] = atoi(line);
            j++;

        }

       
    }

    /* void qsort(void *base, size_t nmemb, size_t size, int (*compar)(const void *, const void *)); 
         The qsort() function sorts an array with nmemb elements of size size.*/
    qsort(numbers, 100, sizeof(int), compareInts);

    /* Printing the sorted numbers */
    printf("Sorted numbers: \n");
    for(i = 0 ; i < 100 ; i++)
    {
        printf("%d\n", numbers[i]);
    }

    return EXIT_SUCCESS;
}
