#include <sys/time.h>
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>
#include <errno.h>
#include <math.h>
int i;

//gcc raices.c -o raices -lpthread -lm

void * calcularRaices(void * param) {
    double raiz[100];

    raiz[i] = sqrt((double)i);
    printf("[%i] = %lf\n", i, raiz[i]);
    pthread_exit(raiz);
}

int main(int argc, char * argv[]) {
    pthread_t raices_t;
    void * returnValue;

    printf("PID = %i\n", getpid());
    printf("Creando threads...\n");
    printf("Calculando Raices...\n");
    
    for (i = 0; i < 100; i++) {
        pthread_create(&raices_t, NULL, calcularRaices, (void *) 0);
        pthread_join(raices_t, &returnValue);
    }
    
    printf("Calculos terminados.\n");
    return 0;
}

