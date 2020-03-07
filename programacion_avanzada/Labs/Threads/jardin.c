#include <sys/time.h>
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <errno.h>
#include <math.h>
#include <time.h>

// gcc jardin.c -o jardin -lpthread -lm

int i = 0;
int visitantes = 0;
pthread_mutex_t mut = PTHREAD_MUTEX_INITIALIZER;

void * visitantesJardin(void * param) {
    int entrada = (rand() % 3);
        sleep(1);
        if(entrada == 0){
            printf("--> Visitante %i entra por la puerta Este.\n", ++i);
            pthread_mutex_lock(&mut);
            visitantes++;
            printf("[Hay %d persona(s) en el parque]\n", visitantes);
            pthread_mutex_unlock(&mut);
        } else if(entrada == 1){
            printf("--> Visitante %i entra por la puerta Oeste.\n", ++i);
            pthread_mutex_lock(&mut);
            visitantes++;
            printf("[Hay %d persona(s) en el parque]\n", visitantes);
            pthread_mutex_unlock(&mut);
        } else{
            if(visitantes >= 1){
                pthread_mutex_lock(&mut);
                printf("Visitante abandona el parque. -->\n");
                visitantes--;
                printf("[Hay %d persona(s) en el parque]\n", visitantes);
                pthread_mutex_unlock(&mut);
            }
        }
    pthread_exit(NULL);
}

int main(int argc, char * argv[]) {
    pthread_t entrada_1;
    pthread_t entrada_2;
    int i;
    void * return_value;
    srand(getpid());
    for (i = 0; i < 1000; i++) {
        pthread_create(&entrada_1, NULL, visitantesJardin, NULL);
        pthread_create(&entrada_2, NULL, visitantesJardin, NULL);
        pthread_join(entrada_1, &return_value);
        pthread_join(entrada_2, &return_value);
    }
        
    return 0;
}
