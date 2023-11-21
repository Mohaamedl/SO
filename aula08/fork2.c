#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
    int ret;

    printf("Antes do fork: PID = %d, PPID = %d\n", getpid(), getppid());
    if ((ret = fork()) < 0) { 
        perror("erro na duplicação do processo");
        return EXIT_FAILURE;
    }
    
    if (ret > 0) sleep(1);
    printf("Quem sou eu?\nApós o fork: PID = %d, PPID = %d, retorno do fork = %d\n",
           getpid(), getppid(), ret);
    if (ret==0){// we are in the child process
        printf("CHILD --->  PID:%d   PPID:%d\n",getpid(),getppid());
    }
    else{
        printf("Main --->  PID:%d\n",getpid());
    }
    return EXIT_SUCCESS;
}
