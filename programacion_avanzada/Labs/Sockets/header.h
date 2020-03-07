#ifndef HEADER_H
#define HEADER_H

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <fcntl.h>
#include <sys/wait.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <pthread.h>

#define EMPEZAR     0
#define TERMINAR    1
#define TURNOA      2
#define TURNOB      3
#define FALLO       -1
#define PEGO        4

#define DEFAULT_PORT    9999
#define DEFAULT_IP      "127.0.0.1"

#endif
