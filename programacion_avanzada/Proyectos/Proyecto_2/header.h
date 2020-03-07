#ifndef HEADER_H
#define HEADER_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <dirent.h>
#include <limits.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/wait.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <pthread.h>

//Bienvenida
#define BIENVENIDA 1

//Cliente
#define ARCHIVO 101
#define DIRECTORIO 102
#define SALIR 103

//Errores
#define DENEGADO 201
#define NOENCONTRADO 202
#define ERROR 203
#define NOCONOCIDO 204
#define ESDIRECTORIO 205
#define DIRECTORIONOEN  206
#define NOESDIRECTORIO 207
//Enviar
#define ENVIANDOAR  301
#define ENVIANDODIR 302

#define DEFAULT_PORT    9999
#define DEFAULT_IP      "127.0.0.1"

#endif