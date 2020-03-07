#include "header.h"


//gcc servidor.c -o servidor -lpthread -lm


//-- Listar Directorios --//
void info(char* directory, char* name, int nsfd){
	char filename[NAME_MAX + 1];
	struct stat ss;

	sprintf(filename, "%s/%s", directory, name);
	if(lstat(filename, &ss) == -1){
		fprintf(stderr, "Error de ejecución (lstat)\n");
		exit(-1);
	}
	if((ss.st_mode & S_IFMT) == S_IFREG){
	    write(nsfd, &filename, sizeof(filename));
		//printf("%s\n", filename);
	}
}

void list(char *directory, int nsfd){
	DIR *dir;
	struct dirent *dir_entry;
	struct stat ss;
	char filename[NAME_MAX + 1], direc[NAME_MAX + 1];
	int respuesta;

	if((dir = opendir(directory)) == NULL){
	    respuesta = DIRECTORIONOEN;
	    write(nsfd, &respuesta, sizeof(respuesta));
		fprintf(stderr, "No such file or directory\n");
		exit(-1);
	}
	
	//printf("%s:\n", directory);
	sprintf(direc, "%s", directory);
	write(nsfd, &direc, sizeof(direc));
	while((dir_entry = readdir(dir)) != NULL){
		if(strcmp(dir_entry->d_name, ".") == 0 ||
			strcmp(dir_entry->d_name, "..")  == 0) {
			continue;
		}
		info(directory, dir_entry->d_name, nsfd);
	}
	//printf("\n");
	rewinddir(dir);
	while((dir_entry = readdir(dir)) != NULL){
		if (strcmp(dir_entry->d_name, ".") == 0 ||
			strcmp(dir_entry->d_name, "..")  == 0) {
			continue;
		}
		sprintf(filename, "%s/%s", directory, dir_entry->d_name);
		stat(filename, &ss);
		if(S_ISDIR(ss.st_mode)){
			list(filename, nsfd);
		}
	}
	
	closedir(dir);
}
//---------------------------------------------------------------//


void* serves_client(void *param){
    int respuesta;
    int nsfd = *((int*) param);
    char *resp;
    char *dir;
    char dir_name[NAME_MAX + 1], ruta[NAME_MAX + 1];
    char comando[5];
    
    srand(getpid());
    printf("PID = %d\n", getpid());
    
    respuesta = BIENVENIDA;
    write(nsfd, &respuesta, sizeof(respuesta));
    
    do{
        read(nsfd, &comando, sizeof(comando));
        
        if((strncmp(comando, "get", 3)) == 0){
            read(nsfd, &ruta, sizeof(ruta));
            printf("%s\n", ruta);
            
            respuesta = ENVIANDOAR;
            //send(int nsfd,const void *msg,int len,int flags);
        } else if((strncmp(comando, "list", 4)) == 0){
            /*
            resp = "init";
            write(nsfd, &resp, sizeof(resp));
            
            strcpy(dir_name, ".");
	        dir = dir_name;
        	list(dir, nsfd);
        	
        	resp = "exit";
        	write(nsfd, &resp, sizeof(resp));
        	*/
            respuesta = ENVIANDODIR;
            
        } else if((strncmp(comando, "bye", 3)) == 0){
            respuesta = SALIR;
            printf("Cliente %d desconectandose.\n", getpid());
        }
        write(nsfd, &respuesta, sizeof(respuesta));
        printf("Enviando código de respuesta: %i.\n", respuesta);
    }while(respuesta != SALIR);
    
    close(nsfd);
}


void servidor(char* ip, int puerto){
    int sfd, nsfd;
    pthread_t thread_id;
    struct sockaddr_in server_info, client_info;
    
    //-- Log --//
    FILE *flogs;
    char logs[NAME_MAX + 1] = "log/logs.log";
    flogs = fopen(logs, "w");
    char *mensaje_log;
    //char ipCliente[INET_ADDRSTRLEN];
    
    if(flogs == NULL){
		fprintf(stderr, "Error al abrir archivo logs %s \n", logs);	
		exit(-1);
	}
	//--------//
    
    if((sfd = socket(AF_INET, SOCK_STREAM, 0)) < 0){
        fprintf(stderr, "Error al tratar de crear el punto de comunicación del socket.\n");
        exit(-1);
    }
    
    server_info.sin_family = AF_INET;
    server_info.sin_addr.s_addr = inet_addr(ip);
    server_info.sin_port = htons(puerto);
    
    if(bind(sfd, (struct sockaddr *) &server_info, sizeof(server_info)) < 0){
        fprintf(stderr, "Error al tratar de enlazar el nombre al socket.\n");
        exit(-1);
    }
    
    printf("Servidor iniciado.\n\n");
    printf("Esperando cliente...\n");
    
    listen(sfd, 1);
    while(1){
        int len = sizeof(client_info);
        
        if((nsfd = accept(sfd, (struct sockaddr *) &client_info, &len)) < 0){
            fprintf(stderr, "Error al tratar de aceptar la conexión de un cliente.\n");
            exit(-1);
        }
        
        printf("Cliente conectado\n");
        
        pthread_create(&thread_id, NULL, serves_client, ((void *) &nsfd));
        //inet_ntop( AF_INET, &ipAddr, ipCliente, INET_ADDRSTRLEN );
        //sprintf(mensaje_log, "Cliente conectado desde: %lu", client_info.sin_addr.s_addr);
        mensaje_log = "Cliente conectado.";
        fprintf(flogs, "Cliente conectado.\n");
    }
    
    fclose(flogs);
}


int main(int argc, char* argv[]){
    char ip[15];
    int puerto;
    
    strcpy(ip, DEFAULT_IP);
    puerto = DEFAULT_PORT;
    
    if (argc == 3) {
		if (strcmp(argv[1], "-d") == 0) {
			strcpy(ip, argv[2]);
		} else if (strcmp(argv[1], "-p") == 0) {
			puerto = atoi(argv[2]);
			if (puerto < 5000) {
        		printf("%s: El número de puerto debe ser mayor a 5000.\n", argv[0]);
        		return -1;
        	}
		} else {
			printf("Forma de uso: %s [-d ip] [-p puerto]\n", argv[0]);
			return -1;
		}
	} else if (argc == 5) {
		if (strcmp(argv[1], "-d") == 0) {
			strcpy(ip, argv[2]);
			if (strcmp(argv[3], "-p") == 0) {
				puerto = atoi(argv[4]);
				if (puerto < 5000) {
            		printf("%s: El número de puerto debe ser mayor a 5000.\n", argv[0]);
            		return -1;
            	}		
			} else {
				printf("Forma de uso: %s [-d ip] [-p puerto]\n", argv[0]);
				return -1;
			}			
		} else if (strcmp(argv[1], "-p") == 0) {
			puerto = atoi(argv[2]);
			if (puerto < 5000) {
        		printf("%s: El número de puerto debe ser mayor a 5000.\n", argv[0]);
        		return -1;
        	}		
			if (strcmp(argv[3], "-d") == 0) {
				strcpy(ip, argv[4]);
			} else {
				printf("Forma de uso: %s [-d ip] [-p puerto]\n", argv[0]);
				return -1;
			}
		} else {
			printf("Forma de uso: %s [-d ip] [-p puerto]\n", argv[0]);
			return -1;
		}
	} else if (argc != 1) {
		printf("Forma de uso: %s [-d ip] [-p puerto]\n", argv[0]);
		return -1;
	}
    
    servidor(ip, puerto);
    
    return 0;
}