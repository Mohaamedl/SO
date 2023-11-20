#include <stdlib.h>
#include <stdio.h>
#include <math.h>

int main(int argc, char *argv[]){
    if (argc==4){
        char operation;
        char * ptr;
        operation = *argv[2];
        
        double num1 = strtod(argv[1],&ptr) ;
        double num2 = strtod(argv[3],&ptr);  
        double result = 0;  
        
        
        switch (operation){
            case '+':
                result = num1 + num2;
                break;
            case '-':
                result = num1 - num2;
                break;
            case 'x':
                result = num1 * num2;
                break;
            case '/':
                result = num1 / num2;
                break;
            case 'p':
                result = pow(num1, num2);
                break;
            default:
                printf("Insira uma operação valida.\n");
                return EXIT_FAILURE;

        }
           


        printf("%.1f %s %.1f = %.1f\n",num1,argv[2],num2,result);
        return EXIT_SUCCESS;
    }
    else{
        printf("deu %d argumentos, e o permitido é 3.\n",argc-1);
        return EXIT_FAILURE;
    }


    
}