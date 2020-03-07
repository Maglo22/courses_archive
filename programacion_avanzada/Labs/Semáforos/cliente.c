#include "header.h"

int main(int argc, char* argv[]){
	int periodo, semid, sillas;
	key_t key;
	unsigned short final_values[6];

	if(argc != 2){
		fprintf(stderr, "Forma de uso: %s [periodo_de_regreso]\n", argv[0]);
		return -1;
	}

	if((periodo = atoi(argv[1])) <= 0){
		fprintf(stderr, "El periodo de regreso debe ser un número entero positivo.\n");
		return -1;
	}

	if((key = ftok("/dev/null", 123)) == (key_t) -1){
		fprintf(stderr, "Error al generar la llave.\n");
		return -1;
	}

	if((semid = semget(key, 6, 0666)) < 0){
		fprintf(stderr, "Error al generar la semilla.\n");
		return -1;
	}

	while(1){
		printf("Nuevo cliente.\n");
		mutex_wait(key, MUTEX);

		sillas = semctl(semid, SILLAS, GETVAL);

		if(sillas == 0){
			printf("No hay sillas disponibles");
			mutex_signal(key, MUTEX);
			printf("Cliente se retira.\n");
			return 0;
		}
		
		sem_wait(semid, SILLAS, 1);

		mutex_signal(key, MUTEX);

		printf("Cliente se sienta en silla.\n");
		sem_signal(semid, CLIENTE, 1);

		sem_wait(semid, BARBERO, 1);

		printf("Cortando el cabello...\n");
		sleep(2);

		sem_signal(semid, C_LISTO, 1);

		sem_wait(semid, B_LISTO, 1);
		printf("Corte terminado.\n");

		mutex_wait(key, MUTEX);
		sem_signal(semid, SILLAS, 1);
		mutex_signal(key, MUTEX);
		
		printf("Regresando en %i días.\n", periodo);
		sleep(periodo);
	}
	
	return 0;
}
