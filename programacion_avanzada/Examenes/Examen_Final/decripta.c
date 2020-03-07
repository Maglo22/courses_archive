#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/types.h>
#include <unistd.h>

// gcc decripta.c -o decripta

int main(int argc, char* argv[]){
	int i, fd_og, fd_fin, bytes;
	unsigned char buffer;
	unsigned char temp = 0;

	if(argc != 3){
		fprintf(stderr, "Forma de uso: %s origen destino.\n", argv[0]);
		return -1;
	}

	if((fd_og = open(argv[1], O_RDWR)) < 0 ) {
		fprintf(stderr, "Error: el archivo %s no existe.\n", argv[1]);
		return -1;
	}
	if((fd_fin = open(argv[2], O_WRONLY | O_TRUNC | O_CREAT, 0666)) < 0){
		fprintf(stderr, "Error al crear el archivo %s.\n", argv[2]);
		return -1;
	}

    printf("\nDescifrando...\n");
	while((bytes = read(fd_og, &buffer, sizeof(unsigned char))) != 0 ) {
	    
	    for(i = 0; i < bytes; i++){
			temp = buffer;
			temp = (temp << 4) | (temp >> 4);
		}
		
		write(fd_fin, &temp, bytes);
	}
	printf("\nTerminado.\n");
	
	close(fd_og);
	close(fd_fin);

	return 0;
}