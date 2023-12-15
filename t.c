#include <stdio.h>



int main( ){
    int o = 3;
    int *pO = &o;
    int **pOO = &pO;
    printf("batata = %d     address to batata: %p \n  address to address to batata: %p\n",o,pO,pOO);
    return 0;
}