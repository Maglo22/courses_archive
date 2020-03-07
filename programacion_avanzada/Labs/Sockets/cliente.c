#include "header.h"
int tablero[4][4]= { {0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0} };
int tiradas[4][4]= { {0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0} };
int barcos = 4;
int barcosFaltantes = 4;


void llenarTablero(){
    int i = 0;
    printf("Colocar Barcos...\n");
    int rletra;
    int rnumero;
    srand (time(NULL));
    while (i < 4){
        rletra = rand() % 4;
        rnumero = rand() % 4;
        if ( tablero[rnumero][rletra] == 0 ){
            tablero[rnumero][rletra] = 1;
            i++;
        }
    }
}

void imprimirTablero(int arr[4][4]){
    int i = 0;
    int j = 0;


    for (i = 0; i < 4; i++){
        for(j = 0; j < 4; j++){
            printf(" %d ", arr[i][j]);
        }
        printf("\n");
    }
}

int main( int argc, char* argv[]){
    int sfd, puerto, fila, col, estatus = 0, partida = 1, turno = 0;
    struct sockaddr_in dir_ser;

    int AceptarcoordenadaFila = 0;
    int AceptarcoordenadaCol = 0;

    if (argc != 3){
        printf("Forma de uso: %s [ip] [puerto]\n", argv[0]);
        return -1;

    }
    if ((puerto = atoi(argv[2])) < 5000){

        printf("%s: El puerto debe ser un número positivo mayor a 5000\n", argv[0]);
        return -1;
    }
    if ((sfd = socket(AF_INET,SOCK_STREAM,0)) < 0 ){
        perror(argv[0]);
        return -1;
    }

    dir_ser.sin_family = AF_INET;
    dir_ser.sin_addr.s_addr = inet_addr(argv[1]);
    
    dir_ser.sin_port=htons(puerto);

    if (connect(sfd,(struct sockaddr *) &dir_ser,sizeof(dir_ser)) < 0 ){
        perror(argv[0]);
        return -1;
    }

    llenarTablero();
    printf("Mi flota naval:\n");
    imprimirTablero(tablero);

    printf("Conectando...\n");
    read(sfd,&estatus,sizeof(estatus));
    printf("Jugador encontrado\n");

    if(estatus == EMPEZAR){
        partida=1;
    }

    while(partida == 1){

        read(sfd,&estatus,sizeof(estatus));

        if (estatus == TURNOA){

            printf("Turno de ataque.\n");

            while(AceptarcoordenadaFila == 0){
            printf("Ingresa la fila a atacar. Debe ser un numero desde 1 a 4.\n");
            scanf("%d",&fila);

                if (fila < 1 || fila > 4){
                    printf("Número de fila no válido\n");
                }
                else{
                    fila--;
                    AceptarcoordenadaFila = 1;
                }

            }
            while(AceptarcoordenadaCol == 0){
            printf("Ingresa la columna a atacar. Debe ser un numero desde 1 a 4.\n");
            scanf("%d",&col);

                if (col < 1 || col > 4){
                    printf("Número de columna no válido.\n");
                }
                else{
                    col--;
                    AceptarcoordenadaCol = 1;
                }

            }
            AceptarcoordenadaCol = 0;
            AceptarcoordenadaFila = 0;

            write(sfd, &fila, sizeof(fila));
            write(sfd, &col, sizeof(col));
            int aux = fila + 1;
            int aux2 = col + 1;

              printf("El disparo fue en %d:%d\n", aux, aux2);

             read(sfd,&estatus,sizeof(estatus));
             if (estatus == TERMINAR || estatus == PEGO  ){
                tiradas[fila][col] = 1;

                barcosFaltantes--;
                printf("¡Hundiste un barco!\nBarcos Faltantes: %d\n", barcosFaltantes);
             }

            if (estatus == FALLO){
                tiradas[fila][col] = -1;
                printf("Fallaste.\n");
            }

            printf("Mi flota naval:\n");
            imprimirTablero(tablero);
            printf("Mis disparos:\n");
            imprimirTablero(tiradas);


            if (estatus == TERMINAR ){
                printf("¡Ganaste!\n");
                partida = 0;
                break;
            }
        }

        if (estatus == TURNOB){
            printf("Turno del enemigo...\n");

                read(sfd, &fila, sizeof(fila));
                read(sfd, &col, sizeof(col));

                int aux = fila + 1;
                int aux2 = col + 1;

                printf("El disparo enemigo fue en %d:%d\n", aux, aux2);

             if (tablero[fila][col] == 1){
                tablero[fila][col] = 2;


                if (barcos > 0){
                estatus = PEGO;
                barcos--;
                printf("Mi flota naval:\n");
                imprimirTablero(tablero);
                printf("¡Nos han dado!\nBarcos faltantes:%d\n",barcos);
                }

                if (barcos == 0) {

                printf("Partida perdida.\n");
                estatus= TERMINAR;
                partida= 0;
                }
             }
             else {
                estatus = FALLO;
                printf("El enemigo ha fallado.\nBarcos faltantes:%d\n",barcos);
                printf("Mi flota naval:\n");
                imprimirTablero(tablero);
             }

            write(sfd,&estatus,sizeof(estatus));

        }
    }

    sleep(1);
    close(sfd);
    return 0;
}
