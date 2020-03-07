#include <stdio.h>
#include <stdlib.h>
#include <dirent.h>
#include <string.h>
#include <limits.h>
#include <sys/stat.h>

#define SIZE 1000

int maximo = 0, minimo = 0;

int max(int a, int b) {
	return ((a > b)? a : b );
}

int min(int a, int b) {
	return ((a < b)? a : b );
}

void findMaxMin(int values[SIZE]){
	int i, ma = 0, mi = 0;
	for(i = 1; i < SIZE; i++){
		ma = max(ma, values[i]);
		mi = min(mi, values[i]); 
	}
	maximo = max(maximo, ma);
	minimo = min(minimo, mi);
}


void write_values(char* filenameIn, char* filenameOut){
	FILE *fileIn, *fileOut;
	int i = 0, size, time, intersect;
	float num, normalized;

	fileIn = fopen(filenameIn, "r");
	fileOut = fopen(filenameOut, "w");
	if(fileIn == NULL){
		fprintf(stderr, "Error al abrir el archivo %s \n", filenameIn);	
		exit(-1);
	}
	if(fileOut == NULL){
		fprintf(stderr, "Error al crear el archivo %s \n", filenameOut);	
		exit(-1);
	}
	

	while(fscanf(fileIn, "%i,%i", &time, &intersect) != EOF){
		size = intersect * intersect;
		if(i >= size){
			fprintf(fileOut, "\n");
			i = 0;
		}
		if(i == 0){
			fprintf(fileOut, "%i,%i", time, intersect);
		}
		fscanf(fileIn, ",%f", &num);
		normalized = (num - minimo)/(maximo - minimo);
		fprintf(fileOut, ",%f", normalized);
		i++;
	}
	fclose(fileIn);
	fclose(fileOut);
}

void read_values(char* filename){
	FILE *file;
	int values[SIZE];
	int time, intersect, size;
	float num;
	
	file = fopen(filename, "r");
	if(file == NULL){
		fprintf(stderr, "No se puede abrir el archivo %s \n", filename);	
		exit(-1);
	}

	memset(values, 0, SIZE * sizeof(int));

	while(fscanf(file, "%i,%i", &time, &intersect) != EOF){
		size = intersect * intersect;
		fscanf(file, ",%f", &num);
		values[((int)num)]++;
	}
	findMaxMin(values);
	fclose(file);
}

void info(char* directoryIn, char* directoryOut, char* name){
	char filename[NAME_MAX + 1], filenameOut[NAME_MAX + 1];
	struct stat ss;

	sprintf(filename, "%s/%s", directoryIn, name);
	sprintf(filenameOut, "%s/%s", directoryOut, name);
	if(lstat(filename, &ss) == -1){
		fprintf(stderr, "Error de ejecución (lstat)\n");
		exit(-1);
	}
	if((ss.st_mode & S_IFMT) == S_IFREG){
		read_values(filename);
		write_values(filename, filenameOut);
	}
}


void openDirectory(char *directoryIn, char *directoryOut){
	DIR *dirIn, *dirOut;
	struct dirent *dir_entry;	

	if((dirIn = opendir(directoryIn)) == NULL){
		fprintf(stderr, "El directorio de entradas %s no existe\n", directoryIn);
		exit(-1);
	}
	if((dirOut = opendir(directoryOut)) == NULL){
		fprintf(stderr, "El directorio de salidas %s no existe\n", directoryOut);
		exit(-1);
	}

	while ((dir_entry = readdir(dirIn)) != NULL) {
		if (strcmp(dir_entry->d_name, ".") == 0 ||
			strcmp(dir_entry->d_name, "..")  == 0) {
			continue;
		}
		info(directoryIn, directoryOut, dir_entry->d_name);
	}
	closedir(dirIn);
	closedir(dirOut);
}

int main(int argc, char* argv[]){
	char *directoryIn, *directoryOut;
	if(argc != 3){
		fprintf(stderr, "Forma de uso: %s [directorio inputs] [directorio outputs]\n", argv[0]);
		return -1;
	}
	directoryIn = argv[1];
	directoryOut = argv[2];
	openDirectory(directoryIn, directoryOut);
	return 0;
}
