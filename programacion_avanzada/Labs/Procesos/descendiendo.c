#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

int i, pid;

void arbol(int currentlevel, int level){
	for(i = 0; i < currentlevel; i++){
		printf("  ");
	}
	printf("PPID = %i PID = %i NIVEL = %i\n", getppid(), getpid(), currentlevel);
	if(currentlevel < level){
		for(i = 0; i <= currentlevel; i++){
			if((pid = fork()) < 0){
				fprintf(stderr, "Error al crear proceso con fork.");
				exit(-1);
			}
			else if(pid == 0){
				arbol(++currentlevel, level);
			}
			else{
				wait(NULL);
			}
		}
	}
}

int main(int argc, char* argv[]){
	int level;

	if(argc != 2){
		fprintf(stderr, "Forma de uso: %s num.\n", argv[0]);
		return -1;
	}
	if((level = atoi(argv[1])) < 0){
		fprintf(stderr, "El programa recibe un número entero (num >= 0).\n");
		return -1;
	}
	arbol(0, level);
	return 0;
}
