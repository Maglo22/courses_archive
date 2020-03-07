// compile -> nvcc quiz3.cu -o quiz3
// execute -> quiz3.exe | quiz3.out

// Bruno Maglioni A01700879

#include <stdio.h>
#define N 9		//size of original matrix
#define K N/3		//size of compressed matrrix
#define ThreadsPerBlock N/K
#define NumBlocks N/K

__global__ void compress(float *mat, int n, float *comp, int k){
  int x = threadIdx.x + blockIdx.x * blockDim.x; // columns
  int y = threadIdx.y + blockIdx.y * blockDim.y; // rows
  int offset = x + y * blockDim.x * gridDim.x; // where the thread is on the grid

  if(x < K && y < K){
    for(int i = 0; i < y; i++){
      for(int j = 0; j < x; j++){
        comp[j + (i * k)] += mat[offset + (j + (i * n))]/n;
      }
    }
    offset += blockDim.x * gridDim.x;
  }
}

void print_mat(float *mat, int n){
	for (int i = 0; i < n; i++){
		for (int j = 0; j < n; j++){
			printf("%.1f\t", mat[i*n+j]);
		}
		printf("\n");
	}
	printf("\n");
}


void fill_mat(float *mat, int n){
	int c = 0;
	for (int i = 0; i < n; i++){
		for (int j = 0; j < n; j++){
			mat[i*n+j] = c++;
		}
	}
}

int main(){
	float *h_compress, *h_matrix; // CPU variables
	float *d_compress, *d_matrix; // GPU variables

  // Allocate memory on CPU
	h_compress = (float *)malloc(sizeof(float) * K * K);
	h_matrix = (float *)malloc(sizeof(float) * N * N);

  // Allocate memory on GPU
  cudaMalloc((void**)&d_compress, sizeof(float) * K * K);
  cudaMalloc((void**)&d_matrix, sizeof(float) * N * N);

  // Fill matrix
  fill_mat(h_matrix, N);

	printf("\n input mat \n");
	print_mat(h_matrix, N);

  // Copy CPU variables to GPU
  cudaMemcpy(d_compress, h_compress, sizeof(float)* K * K, cudaMemcpyHostToDevice);
  cudaMemcpy(d_matrix, h_matrix, sizeof(float)* N * N, cudaMemcpyHostToDevice);

  // Create grids
  dim3 blocks(NumBlocks, NumBlocks);
  dim3 threads(ThreadsPerBlock, ThreadsPerBlock);

  // Call function in GPU
  compress<<<blocks, threads>>>(d_matrix, N, d_compress, K);

  // Copy result matrix from GPU to CPU
  cudaMemcpy(h_compress, d_compress, sizeof(float) * K * K, cudaMemcpyDeviceToHost);

  // Print compressed matrix
  printf("\n compress mat \n");
	print_mat(h_compress, N);

  // Free CPU memory
  free(h_compress);
  free(h_matrix);

  // Free GPU memory
  cudaFree(d_compress);
  cudaFree(d_matrix);

  return 0;
}
