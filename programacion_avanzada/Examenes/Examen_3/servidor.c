#include "header.h"
#include <string.h>
#include <time.h>

void serves_client(int nsfd, int n, int m) {
	int i, num, conjuntos, n_conjunto = 0;
	float resultados;
	
	conjuntos = n;
	
	srand(getpid());
	
	write(nsfd, &n, sizeof(n));
	
	while(conjuntos > 0){
	    n_conjunto++;
	    write(nsfd, &m, sizeof(m));
        printf("Enviando conjunto %i.\n", n_conjunto);
        
        for(i = 0; i < m; i++){
            num = (rand() % 100) + 1;
            write(nsfd, &num, sizeof(num));
        }
        
        for(i = 0; i < m; i++){
            num = (rand() % 100) + 1;
            write(nsfd, &num, sizeof(num));
        }
        
        printf("Recibiendo información.\n");
        read(nsfd, &resultados, sizeof(resultados));
        
        printf("Resultado: %f", resultados);

	    conjuntos--;
	}
	close(nsfd);
}

void server(char* ip, int port, int n, int m, char* program) {
	int sfd, nsfd, pid;
	struct sockaddr_in server_info, client_info;
	
	printf("Arrancando servidor...\n");

	if ( (sfd = socket(AF_INET, SOCK_STREAM, 0)) < 0 ) {
		perror(program);
		exit(-1);
	}
	
	server_info.sin_family = AF_INET;
	server_info.sin_addr.s_addr = inet_addr(ip);
	server_info.sin_port = htons(port);
	if ( bind(sfd, (struct sockaddr *) &server_info, sizeof(server_info)) < 0 ) {
		perror(program);
		exit(-1);
	}
	
	listen(sfd, 1);
	
	printf("Esperando conexión...\n");
	
	while (1) {
		int len = sizeof(client_info);
		if ( (nsfd = accept(sfd, (struct sockaddr *) &client_info, &len)) < 0 ) {
			perror(program);
			exit(-1);
		}
		
		printf("Conexión aceptada.\n");
		
		if ( (pid = fork()) < 0 ) {
			perror(program);
		} else if (pid == 0) {
			close(sfd);
			serves_client(nsfd, n, m);
			exit(0);
		} else {
			close(nsfd);
		}
	}
}

int main(int argc, char* argv[]) {
	char ip[15];	
	int port, n, m;
	
	if (argc != 5) {
	    fprintf(stderr, "Fomra de uso: %s [ip] [puerto] [N] [M].\n", argv[0]);
	    return -1;
	}
	
	n = atoi(argv[3]);
	if (n < 0) {
		printf("%s: N debe ser un número entero positivo.\n", argv[0]);
		return -1;
	}
	m = atoi(argv[4]);
	if (m < 0) {
		printf("%s: M debe ser un número entero positivo.\n", argv[0]);
		return -1;
	}
	
	strcpy(ip, argv[1]);
	strcpy(port, argv[1]);
	
	server(ip, port, n, m, argv[0]);
	
	return 0;
}