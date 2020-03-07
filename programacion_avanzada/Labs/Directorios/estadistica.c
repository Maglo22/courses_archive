#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <string.h>
#include <dirent.h>
#include <sys/stat.h>
#include <unistd.h>

int reg = 0, d = 0, l = 0, fifo = 0;

void restart(){
	reg = 0;
	d = 0;
	l = 0;
	fifo = 0;
}

void printestats(){
	int total = reg+d+l+fifo;
	printf("Tipo\tPorcentaje\n");
	if(reg>0){
		printf("REG:\t %d%% \n", (reg*100/total));
	}
	if(d>0){
		printf("DIR:\t %d%% \n", (d*100/total));
	}
	if(fifo>0){
		printf("FIFO:\t %d%% \n", (fifo*100/total));
	}
	if(l>0){
		printf("LINK:\t %d%% \n", (l*100/total));
	}
	restart();
}

void estats(char* directory, char* name){
	char filename[NAME_MAX + 1];
	struct stat ss;

	sprintf(filename, "%s/%s", directory, name);
	if(lstat(filename, &ss) == -1){
		fprintf(stderr, "Error de ejecución (lstat).\n");
		exit(-1);
	}
	if((ss.st_mode & S_IFMT) == S_IFDIR){
		d++;
	}
	else if(S_ISLNK(ss.st_mode)){
		l++;
	}
	else if(S_ISFIFO(ss.st_mode)){
		fifo++;
	}
	else{
		reg++;	
	}
	
}

void list(char *directory){
	char filename[NAME_MAX + 1];
	//char path[1024];
	DIR *dir;
	struct dirent *dir_entry;
	struct stat ss;
	
	if ((dir = opendir(directory)) == NULL ) {
		fprintf(stderr, "El directorio no existe.\n");
		exit(-1);
	}
	
	//getcwd(path, sizeof(path));
	printf("Directorio: %s\n", directory);
	while((dir_entry = readdir(dir)) != NULL){
		if (strcmp(dir_entry->d_name, ".") == 0 ||
			strcmp(dir_entry->d_name, "..")  == 0) {
			continue;
		}
		estats(directory, dir_entry->d_name);
	}
	printestats();
	printf("\n");
	rewinddir(dir);
	while((dir_entry = readdir(dir)) != NULL){
		if (strcmp(dir_entry->d_name, ".") == 0 ||
			strcmp(dir_entry->d_name, "..")  == 0) {
			continue;
		}
		sprintf(filename, "%s/%s", directory, dir_entry->d_name);
		stat(filename, &ss);
		if(S_ISDIR(ss.st_mode)){
			list(filename);
		}
	}
	closedir(dir);
}

int main(int argc, char* argv[]){
	char *dir;
	char dir_name[NAME_MAX + 1];

	if(argc > 2){
		fprintf(stderr, "Forma de uso: %s [directorio].\n", argv[0]);
		return -1;
	}

	strcpy(dir_name, ".");
	dir = dir_name;

	if(argc == 2){
		dir = argv[1];
	}
	list(dir);
	return 0;
}
