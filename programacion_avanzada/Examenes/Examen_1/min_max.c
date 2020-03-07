#include <stdio.h>
#include <stdlib.h>
#include <dirent.h>
#include <limits.h>
#include <sys/stat.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>

void minMax(char* filename){
	int fd, bytes, buffer, min = 0, max = 0, temp;
	if((fd = open(filename, O_RDONLY)) < 0){
		fprintf(stderr, "Error al abir el archivo %s\n", filename);
	}
	while((bytes = read(fd, &buffer, sizeof(int))) != 0){
		temp = buffer;
		if(temp < min){
			min = temp;
		}
		else if(temp > max){
			max = temp;
		}	
	}
	printf("filename = %s - min = %i - max = %i\n", filename, min, max);
	close(fd);
}


void info(char* directory, char* name){
	char filename[NAME_MAX + 1];
	struct stat ss;

	sprintf(filename, "%s/%s", directory, name);
	if(lstat(filename, &ss) == -1){
		fprintf(stderr, "Error de ejecución (lstat)\n");
		exit(-1);
	}
	if((ss.st_mode & S_IFMT) == S_IFREG){
		minMax(filename);
	}
}


void list(char *directory){
	DIR *dir;
	struct dirent *dir_entry;
	struct stat ss;
	char filename[NAME_MAX + 1];

	if((dir = opendir(directory)) == NULL){
		fprintf(stderr, "No such file or directory\n");
		exit(-1);
	}
	
	printf("%s:\n", directory);
	while((dir_entry = readdir(dir)) != NULL){
		if(strcmp(dir_entry->d_name, ".") == 0 ||
			strcmp(dir_entry->d_name, "..")  == 0) {
			continue;
		}
		info(directory, dir_entry->d_name);
	}
	printf("\n");
	rewinddir(dir);
	while((dir_entry = readdir(dir)) != NULL ) {
		if (strcmp(dir_entry->d_name, ".") == 0 ||
			strcmp(dir_entry->d_name, "..")  == 0) {
			continue;
		}
		sprintf(filename, "%s/%s", directory, dir_entry->d_name);	
		stat(filename, &ss);
		if (S_ISDIR(ss.st_mode)) {
			list(filename);
		}
	}
	closedir(dir);
}

int main(int argc, char* argv[]){
	char dir_name[NAME_MAX + 1];
	char *directory;
	
	if(argc != 2){
		fprintf(stderr, "Usage: %s [directory]\n", argv[0]);
		return -1;
	}
	directory = argv[1];
	list(directory);
	return 0;
}
