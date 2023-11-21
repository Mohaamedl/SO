#include <stdlib.h>
#include <stdio.h>
int main(int argc, int *argv[]){
    int* n;
    int s = 324;
    n = &s;
    printf("%d",*n);
    //printf("%p    %p",n,&s);
}