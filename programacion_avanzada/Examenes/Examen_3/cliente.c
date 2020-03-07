#include "header.h"

int main(int argc, char* argv[]) {
    int sfd, conjuntos, media = 0, suma, i, n, m, temp = 0, n_conjunto = 0;
	int port;
	float s;
	struct sockaddr_in server_info;
	
	if (argc != 3) {
	    printf("Forma de uso: %s [ip] [puerto]\n", argv[0]);
	    return -1;
	}
	
	port = atoi(argv[2]);
	if (port < 5000) {
		printf("%s: El puerto debe ser un número mayor a 5000.\n", argv[0]);
		return -1;
	}
	
	if ( (sfd = socket(AF_INET, SOCK_STREAM, 0)) < 0 ) {
		perror(argv[0]);
		return -1;
	}
	
	server_info.sin_family = AF_INET;
	server_info.sin_addr.s_addr = inet_addr(argv[1]);
	server_info.sin_port = htons(port);
	if ( connect(sfd, (struct sockaddr *) &server_info, sizeof(server_info)) < 0 ) {
		perror(argv[0]);
		return -1;
	}
	
	read(sfd, &n, sizeof(n));
    printf("Conexión establecida, esperando %d conjuntos.\n", n);
    conjuntos = n;
    
    while(conjuntos > 0){
        n_conjunto++;
        printf("Recibiendo valores de conjunto %d.\n", n_conjunto);
        read(sfd, &m, sizeof(m));
        
        for(i = 0; i < m; i++){
            read(sfd, &temp, sizeof(temp));
             media += temp;
	    }
	    media = media/m;
	    
	    for(i = 0; i < m; i++){
            read(sfd, &temp, sizeof(temp));
	        suma += (temp - media)^2;
	    }
	    
	    s = suma/n;
	    
	    printf("Enviando resultados...\n");
	    write(sfd, &s, sizeof(s));
	    conjuntos--;
    }
	
	printf("Terminando conexión.\n");
	close(sfd);
	return 0;
}