#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>
#include <sys/wait.h>

char *process[3];

void sigterm_handler(int sig){
	fprintf(stdout, "Terminación del proceso.\n");
	exit(-1);
}

void handler(int signal){
	int pid;
	switch(signal){
		case 1: printf("PID = %i, señal = 1, proceso = %s\n", getpid(), process[1]); break;
		case 2: printf("PID = %i, señal = 2, proceso = %s\n", getpid(), process[2]); break;
		case 3: printf("PID = %i, señal = 3, proceso = %s\n", getpid(), process[3]); break;
	}
	if((pid = fork()) < 0){
		fprintf(stderr, "Error al crear proceso hijo.\n");
		exit(-1);
	}
	else if(pid == 0){
		execlp(process[signal],process[signal],(char*)0);
	}
	else{
		wait(NULL);
	}
}

int main(int argc, char* argv[]){
	signal(SIGTERM, sigterm_handler);
	signal(1, handler);
	signal(2, handler);
	signal(3, handler);

	if(argc != 4){
		if(argc != 1){
			fprintf(stderr, "Forma de uso: %s orden1 orden2 orden3, o sin parámetros.\n", argv[0]);
			return -1;
		}
		process[1] = "ls";
		process[2] = "ps";
		process[3] = "pwd";
	}
	else{
		process[1] = argv[1];
		process[2] = argv[2];
		process[3] = argv[3];
	}
	
	while(1){
		//Procesos deben ser ejecutados por procesos hijos.
		printf("PID %i esperando señal\n", getpid());
		pause();
	}
	
	exit(0);
}
