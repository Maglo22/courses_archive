#include "header.h"

int main(int argc, char* argv[]){
	int semid;
	key_t key;
	unsigned short final_values[6];

	if((key = ftok("/dev/null", 123)) == (key_t) -1){
		fprintf(stderr, "Error al generar la llave.\n");
		return -1;
	}

	if((semid = semget(key, 6, 0666)) < 0){
		fprintf(stderr, "Error al generar la semilla.\n");
		perror(argv[0]);
		return -1;
	}

	semctl(semid, 0, GETALL, final_values);

	while(1){
		printf("Barbero durmiendo...\n");
		
		sem_wait(semid, CLIENTE, 1);
		printf("Cliente despierta al barbero.\n");

		sem_signal(semid, BARBERO, 1);
		printf("Barbero cortando el cabello.\n");

		sem_wait(semid, C_LISTO, 1);

		sem_signal(semid, B_LISTO, 1);
		printf("Barbero ha terminado de cortar el cabello.\n");

		sleep(2);
	}
	return 0;
}
