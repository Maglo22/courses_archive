#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/types.h>
#include <unistd.h>

#define SIZE 128

int main(int argc, char* argv[]){
	int i, n, fd_og, fd_fin, bytes, tam, dif;
	char buffer[SIZE];
	char *temp;

	if(argc != 4){
		fprintf(stderr, "Forma de uso: %s numero origen destino.\n", argv[0]);
		return -1;
	}

	n = atoi(argv[1]);

	if(n < 0 || n > SIZE){
		fprintf(stderr, "Error: el primer parámetro debe ser un num entero positivo [0-127].\n");
		return -1;
	}
	if((fd_og = open(argv[2], O_RDWR)) < 0 ) {
		fprintf(stderr, "Error: el archivo %s no existe.\n", argv[2]);
		return -1;
	}
	if((fd_fin = open(argv[3], O_WRONLY | O_TRUNC | O_CREAT, 0666)) < 0){
		fprintf(stderr, "Error al crear el archivo %s.\n", argv[3]);
		return -1;
	}

	dif = SIZE - n;

	while((bytes = read(fd_og, &buffer, SIZE * sizeof(char))) != 0 ) {
		tam = SIZE;	
		if(bytes < SIZE){
			tam = bytes;
		}
		temp = (char*) malloc(tam * sizeof(char));
		for(i = 0; i < tam; i++){
			temp[(i+dif)%tam] = buffer[i];
		}
		write(fd_fin, temp, bytes);
	}
	
	free(temp);
	close(fd_og);
	close(fd_fin);

	return 0;
}
