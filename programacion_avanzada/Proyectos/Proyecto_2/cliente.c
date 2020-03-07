#include "header.h"


//gcc cliente.c -o cliente -lpthread -lm


int main(int argc, char* argv[]){
    int sfd, puerto, respuesta = 0;
    struct sockaddr_in server_info;
    char r[NAME_MAX + 4], ruta[NAME_MAX + 1], resp[NAME_MAX + 1];
    char *res;
    char comando[5];
    
    if(argc != 3){
        fprintf(stderr, "Forma de uso: %s [ip] [puerto]\n", argv[0]);
        printf("(ip y puerto por defecto: 127.0.0.1, 9999).\n");
        return -1;
    }
    
    if((puerto = atoi(argv[2])) < 5000){
        fprintf(stderr, "El puerto debe ser un número mayor a 5000.\n");
        return -1;
    }
    
    if((sfd = socket(AF_INET, SOCK_STREAM, 0)) < 0){
        fprintf(stderr, "Error al tratar de crear el punto de comunicación del socket.\n");
        exit(-1);
    }
    
    server_info.sin_family = AF_INET;
    server_info.sin_addr.s_addr = inet_addr(argv[1]);
    server_info.sin_port = htons(puerto);
    
    if(connect(sfd, (struct sockaddr *) &server_info, sizeof(server_info)) < 0){
        fprintf(stderr, "Error al tratar de conectarse al servidor.\n");
        return -1;
    }
    
    read(sfd, &respuesta, sizeof(respuesta));
    if(respuesta == BIENVENIDA){
        printf("Conexión al servidor establecida.\n");
    }
    
    do{
        printf("\nComandos:\nget [ruta completa de archivo]\nlist\nbye\n");
        printf("Esperando comando...\n");
        printf("\n$ ");
        
        res = fgets(r, (NAME_MAX + 4), stdin);
        strncpy(comando, res, 4);
        comando[4] = '\0';
        
        if((strncmp(comando, "get", 3)) == 0){
            memcpy(ruta, res + 4, sizeof ruta);
            if(ruta[0] != '/'){
                printf("La ruta debe comenzar con '/'\n");
            }
            else{
                printf("%s\n", ruta);
            
                write(sfd, &comando, sizeof(comando));
                
                write(sfd, &ruta, sizeof(ruta));
                
                read(sfd, &respuesta, sizeof(respuesta));
                printf("Código de mensaje recibido: %i\n", respuesta);
            }
        }
        else if((strncmp(comando, "list", 4)) == 0){
            write(sfd, &comando, sizeof(comando));
            /*
            read(sfd, &resp, sizeof(resp));
            if((strncmp(resp, "init", 4)) == 0){
                read(sfd, &resp, sizeof(resp));
                printf("%s:\n", resp);
                
                while((strncmp(resp, "exit", 4)) == 0){
                    read(sfd, &resp, sizeof(resp));
                    printf("%s\n", resp);
                }
            }
            */
            read(sfd, &respuesta, sizeof(respuesta));
            printf("Código de mensaje recibido: %i\n", respuesta);
        }
        else if((strncmp(comando, "bye", 3)) == 0){
            write(sfd, &comando, sizeof(comando));
            read(sfd, &respuesta, sizeof(respuesta));
        }
        else{
            printf("Comando no reconocido.\n");
        }
    }while(respuesta != SALIR);
    
    printf("\nCerrando conexión con el servidor.\n");
    close(sfd);
    
    return 0;
}