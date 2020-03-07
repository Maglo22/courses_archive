#include <iostream>

#define N 4096
#define TPB 512 // Threads per Block

__global__ void add(int* a, int* b, int *c, int max){
  int index = threadIdx.x + blockIdx.x * blockDim.x;
  int id = index;
  while(id < max){
    c[id] = a[id] + b[id];
    id = id + blockDim.x * gridDim.x;
  }
}

// Fills a matrix with 1s
void fill_mat(int* mat){
  int i, j;
  for(i = 0; i < N; i++){
    for(j = 0; j < N; j++){
      mat[i * N + j] = 1;
    }
  }
}

// Prints matrix
void print_mat(int* mat){
  int i, j;
  for(i = 0; i < N; i++){
    for(j = 0; j < N; j++){
      printf("%i\t", mat[i * N + j]);
    }
    printf("\n");
  }
  printf("\n");
}

int main(){
  int *mat_1, *mat_2, *res; // CPU variables
  int *d_mat_1, *d_mat_2, *d_res; // GPU variables

  mat_1 = (int*) malloc(sizeof(int) * N * N); // Matrix 1
  mat_2 = (int*) malloc(sizeof(int) * N * N); // Matrix 2
  res = (int*) malloc(sizeof(int) * N * N); // Result Matrix

  // Allocate memory on GPU for each matrix
  cudaMalloc((void**)&d_mat_1, sizeof(int) * N * N);
  cudaMalloc((void**)&d_mat_2, sizeof(int) * N * N);
  cudaMalloc((void**)&d_res, sizeof(int) * N * N);

  // Fill matrices
  fill_mat(mat_1);
  fill_mat(mat_2);

  // Copy CPU variables to GPU
  cudaMemcpy(d_mat_1, mat_1, N * N * sizeof(int), cudaMemcpyHostToDevice);
  cudaMemcpy(d_mat_2, mat_2, N * N * sizeof(int), cudaMemcpyHostToDevice);

  // Call function in GPU
  add<<< (N * N / TPB), TPB>>>(d_mat_1, d_mat_2, d_res, (N * N));

  // Copy result matrix from GPU to CPU
  cudaMemcpy(res, d_res, N * N * sizeof(int), cudaMemcpyDeviceToHost);

  //print_mat(res);
  printf("Done.\n");

  // Free CPU memory
  free(mat_1);
  free(mat_2);
  free(res);

  // Free GPU memory
  cudaFree(d_mat_1);
  cudaFree(d_mat_2);
  cudaFree(d_res);

  return 0;
}
