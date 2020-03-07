// compile -> nvcc lab_2.cu -o lab_2
// execute -> lab_2.exe | lab_2.out

// Bruno Maglioni A01700879

#include <iostream>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#define N 4
#define ThreadsPerBlock N * N
#define NumBlocks  ceil((ThreadsPerBlock + (N * N)) / ThreadsPerBlock)


__global__ void multi(double *a, double *b, double *c, int n){
  int row = threadIdx.y + blockIdx.y * blockDim.y;
  int col = threadIdx.x + blockIdx.x * blockDim.x;

  double sum = 0.0;

  if(row < n && col < n){
    for(int i = 0; i < n; i++){
      sum += a[row * n + i] * b[i * n + col];
    }
  }
  c[row * n + col] = sum;
}

// matrix multiplication using CPU
// a = M x N, b = P x Q
// m = rows of first matrix, p = rows of second matrix, q = columns of second matrix
void mat_multi(double *a, double *b, double *c, int m, int p, int q){
  int i, j, k;
  double sum = 0.0;

  for (i = 0; i < m; i++) {
    for (j = 0; j < q; j++) {
      for (k = 0; k < p; k++) {
        sum += a[i * m + k] * b[k * m + j];
      }

      c[i * m + j] = sum;
      sum = 0.0;
    }
  }
}


// Fills matrix
void fill_mat(double* mat){
  for(int i = 0; i < N; i++){
    for(int j = 0; j < N; j++){
      mat[i * N + j] = rand() % 50;
    }
  }
}


// Prints matrix
void print_mat(double* mat){
  int i, j;
  for(i = 0; i < N; i++){
    for(j = 0; j < N; j++){
      printf("%f\t", mat[i * N + j]);
    }
    printf("\n");
  }
  printf("\n");
}


int main(){
  double *mat_1, *mat_2, *res; // CPU variables
  double *d_mat_1, *d_mat_2, *d_res; // GPU variables

  // for random number generation
  time_t t;
  srand((unsigned) time(&t));

  // Allocate memory on CPU
  mat_1 = (double*) malloc(sizeof(double) * N * N); // Matrix 1
  mat_2 = (double*) malloc(sizeof(double) * N * N); // Matrix 2
  res = (double*) malloc(sizeof(double) * N * N); // Result Matrix

  // Allocate memory on GPU
  cudaMalloc((void**)&d_mat_1, sizeof(double) * N * N);
  cudaMalloc((void**)&d_mat_2, sizeof(double) * N * N);
  cudaMalloc((void**)&d_res, sizeof(double) * N * N);

  fill_mat(mat_1);
  fill_mat(mat_2);

  printf("Matrix 1:\n");
  print_mat(mat_1);

  printf("\nMatrix 2:\n");
  print_mat(mat_2);

  // Copy CPU variables to GPU
  cudaMemcpy(d_mat_1, mat_1, sizeof(double) * N * N, cudaMemcpyHostToDevice);
  cudaMemcpy(d_mat_2, mat_2, sizeof(double) * N * N, cudaMemcpyHostToDevice);

  // create 2D grid
  dim3 blocks(NumBlocks, NumBlocks); // dimensions of resulting matrix
  dim3 threads(ThreadsPerBlock, ThreadsPerBlock);

  // Call function in GPU
  multi<<<blocks, threads>>>(d_mat_1, d_mat_2, d_res, N);

  // Copy result matrix from GPU to CPU
  cudaMemcpy(res, d_res, sizeof(double) * N * N, cudaMemcpyDeviceToHost);

  printf("\nResult matrix:\n");
  print_mat(res);

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
