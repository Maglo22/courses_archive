#include "header.h"
#include <string.h>

struct sockets{
    int socket1;
    int socket2;
};

void* client(void* param){
    
    int jugar = 1;
    int num,letra, status;
    int aux = 0;

    struct sockets socketfd;
    int sfd,sfd2;

    socketfd = *((struct sockets *)param);
    sfd = socketfd.socket1;
    sfd2 = socketfd.socket2;


    status = EMPEZAR;
    write(sfd,&status,sizeof(status));
    write(sfd2,&status,sizeof(status));
    printf("Jugadores listos.\nEmpieza la partida.\n");

    while(jugar == 1) {

        status = TURNOA;
        write(sfd,&status,sizeof(status));
        status = TURNOB;
        write(sfd2,&status,sizeof(status));

        read(sfd,&num,sizeof(num));
        read(sfd,&letra,sizeof(letra));

        write(sfd2,&num,sizeof(num));
        write(sfd2,&letra,sizeof(letra));

        read(sfd2,&status,sizeof(status));
        write(sfd,&status,sizeof(status));


        if (status == TERMINAR){
            printf("Partida terminada.\n¡Gracias por jugar!\n");
            jugar = 0;
            break;
        }

        aux = sfd;
        sfd = sfd2;
        sfd2 = aux;

    }
    close(sfd);
    close(sfd2);
}

void server(char* ip , int port , char* program ){
    int sfd, nsfd, nsfd2, pid;
    pthread_t thread_id;
    struct sockaddr_in server_info, client_info;
    
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

    listen(sfd,2);

    while (1){
        int len = sizeof(client_info);
        if ( (nsfd = accept(sfd, (struct sockaddr *) &client_info, &len)) < 0 ) {
            perror(program);
            exit(-1);
        }

        if ( (nsfd2 = accept(sfd, (struct sockaddr *) &client_info, &len)) < 0 ) {
            perror(program);
            exit(-1);
        }
        
         struct sockets socket1y2;
         socket1y2.socket1=nsfd;
         socket1y2.socket2=nsfd2;
   
        pthread_create(&thread_id, NULL, client, ((void *) &socket1y2));
        
    }
}

int main (int argc , char* argv[] ){
    char ip[15];
    int port;
    
    strcpy(ip, DEFAULT_IP);
    port = DEFAULT_PORT;
    if (argc == 3) {
        if (strcmp(argv[1], "-d") == 0) {
            strcpy(ip, argv[2]);
        } else if (strcmp(argv[1], "-p") == 0) {
            port = atoi(argv[2]);
            if (port < 5000) {
                printf("%s: El número de puerto debe ser positivo mayor a 5000.\n", argv[0]);
                return -1;
            }
        } else {
            printf("Forma de uso: %s [-d dir] [-p puerto]\n", argv[0]);
            return -1;
        }
    } else if (argc == 5) {
        if (strcmp(argv[1], "-d") == 0) {
            strcpy(ip, argv[2]);
            if (strcmp(argv[3], "-p") == 0) {
                port = atoi(argv[4]);
                if (port < 5000) {
                    printf("%s: El número de puerto debe ser un número positivo mayor a 5000.\n", argv[0]);
                    return -1;
                }
            } else {
                printf("usage: %s [-d dir] [-p port]\n", argv[0]);
                return -1;
            }
        } else if (strcmp(argv[1], "-p") == 0) {
            port = atoi(argv[2]);
            if (port < 5000) {
                printf("%s: El número de puerto debe ser positivo mayor a 5000.\n", argv[0]);
                return -1;
            }
            if (strcmp(argv[3], "-d") == 0) {
                strcpy(ip, argv[4]);
            } else {
                printf("Forma de uso: %s [-d dir] [-p puerto]\n", argv[0]);
                return -1;
            }
        } else {
            printf("Forma de uso: %s [-d dir] [-p puerto]\n", argv[0]);
            return -1;
        }
    } else if (argc != 1) {
        printf("Forma de uso: %s [-d dir] [-p puerto]\n", argv[0]);
        return -1;
    }
    
    server(ip,port,argv[0]);

return 0;
}

