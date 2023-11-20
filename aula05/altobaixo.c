#include <stdlib.h>
#include <stdio.h>
#include <time.h>
 

int main(int argc, char *argv[]){
    time_t t;
    srand((unsigned) time(&t));
    int count = 0;
    if (argc==3){
        int min = atoi(argv[1]);
        int max = atoi(argv[2]);
        if (max>min){
            int guess;
            int value = min + rand() % (max-min);
            printf("value: %d\n",value); // for dev
            printf("Guess a number between %d and %d\n",min,max);
            scanf("%d",&guess);
            count++;
            while (guess!=value){
                if (guess>value){
                    printf("Much smaller, guess again\n");
                    scanf("%d",&guess);
                    count++;

                }
                else {
                    printf("Much bigger, guess again\n");
                    scanf("%d",&guess);
                    count++;
                }
            }
            printf("Good game, you win in %d guesses :)\n",count);



        }
        else{
            printf("Wrong interval");
            return EXIT_FAILURE;
        }



    }




    return EXIT_SUCCESS;
}