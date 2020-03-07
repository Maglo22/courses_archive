#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/types.h>
#include <limits.h>

void rotacion(char *oldname, char *name, int copias, int tiempo){
	//Renombrar archivos anteriores
	//Crear nuevo .log
	int fd, ren, i = 1, j, k, aux;
	char newname[NAME_MAX + 1], temp[NAME_MAX + 1], auxname[NAME_MAX + 1], oldauxname[NAME_MAX + 1];
	sprintf(temp, "%s", oldname);
	while(1){
		sleep(tiempo);			
		sprintf(newname, "%s.%d", name, i);
		if((ren = rename(temp, newname)) < 0){
			fprintf(stderr, "Error al renombrar el archivo %s\n", temp);
			exit(-1);
		}
		printf("Archivo %s renombrado a: %s\n", temp, newname);
		sprintf(temp, "%s", newname);
		k = i - 1;
		if(k != 0){
			for(j = k; j > 0; j--){
				aux = j-1;
				sprintf(temp, "%s", oldname);
				if(aux == 0){
					sprintf(auxname, "%s.%d", name, j);
					if((ren = rename(temp, auxname)) < 0){
						fprintf(stderr, "Error al renombrar el archivo %s\n", temp);
						exit(-1);
					}
					printf("Archivo %s renombrado a: %s\n", temp, auxname);
					sprintf(temp, "%s", newname);
				}
				else{
					sprintf(auxname, "%s.%d", name, j);
					sprintf(oldauxname, "%s.%d", name, aux);
					if((ren = rename(oldauxname, auxname)) < 0){
						fprintf(stderr, "Error al renombrar el archivo %s\n", oldauxname);
						exit(-1);
					}
					printf("Archivo %s renombrado a: %s\n", oldauxname, auxname);
					sprintf(temp, "%s", newname);
				}
			}
		}
		if((fd = open(oldname, O_WRONLY | O_CREAT | O_TRUNC, 0666)) < 0){
			fprintf(stderr, "Error al crear el archivo %s\n", oldname);
			exit(-1);
		}
		printf("Archivo %s creado\n", oldname);
		if(i < copias){
			i++;
		}
		else{
			remove(newname);
			printf("Archivo %s borrado\n", newname);
			i--;
			sprintf(temp, "%s.%d", name, i);
		}
	}
}

int main(int argc, char* argv[]){
	int fd_log, nc, t;
	char filename[NAME_MAX + 1], filenamelog[NAME_MAX + 1];
	char *old, *name;
	DIR *dir;

	if(argc != 5){
		fprintf(stderr, "Forma de uso: %s ruta_directorio archivo_log numero_copias tiempo\n", argv[0]);
		return -1;
	}
	if((dir = opendir(argv[1])) == NULL){
		fprintf(stderr, "El directorio %s no existe\n", argv[1]);
		return -1;
	}

	sprintf(filename, "%s/%s", argv[1], argv[2]);
	sprintf(filenamelog, "%s/%s.log", argv[1], argv[2]);


	if((fd_log = open(filenamelog, O_RDWR)) < 0){
		fprintf(stderr, "Error al abrir el archivo %s\n", argv[2]);
		return -1;
	}

	old = filenamelog;
	name = filename;	
	
	if((nc = atoi(argv[3])) <= 0){
		fprintf(stderr, "Ingresar un valor válido para el número de copias (Número positivo)\n");
		return -1;
	}
	if((t = atoi(argv[4])) <= 0){
		fprintf(stderr, "Ingresar un valor válido para el lapso de tiempo (Número positivo)\n");
		return -1;
	}

	rotacion(old, name, nc, t);
	
	close(fd_log);
	
	return 0;
}
