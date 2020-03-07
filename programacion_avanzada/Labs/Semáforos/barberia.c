#include "header.h"

/*
	
	gcc -o barberia barberia.c header.h
	gcc -o barbero barbero.c header.h
	gcc -o cliente cliente.c header.h

	./barberia [sillas]
	./barbero
	./cliente [num]

*/

int main(int argc, char* argv[]){
	int semid, sillas;
	key_t key;
	unsigned short final_values[6];

	if(argc != 2){
		fprintf(stderr, "Forma de uso: %s [cantidad_sillas]\n", argv[0]);
		return -1;
	}

	if((sillas = atoi(argv[1])) <= 0){
		fprintf(stderr, "La cantidad de sillas debe ser un número entero positivo.\n");
		return -1;
	}

	if((key = ftok("/dev/null", 123)) == (key_t) -1){
		fprintf(stderr, "Error al generar la llave.\n");
		return -1;
	}

	if((semid = semget(key, 6, 0666 | IPC_CREAT)) < 0){
		fprintf(stderr, "Error al generar la semilla.\n");
		return -1;
	}

	semctl(semid, MUTEX, SETVAL, 1);
	semctl(semid, CLIENTE, SETVAL, 0);
	semctl(semid, BARBERO, SETVAL, 0);
	semctl(semid, C_LISTO, SETVAL, 0);
	semctl(semid, B_LISTO, SETVAL, 0);
	semctl(semid, SILLAS, SETVAL, sillas);

	semctl(semid, 0, GETALL, final_values);

	return 0;
}
