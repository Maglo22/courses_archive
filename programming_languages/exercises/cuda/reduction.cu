#include <iostream>

const int N = 32 * 1024;
const int Threads_per_block = 256;
const int Blocks_per_grid = imin(32, (N + Threads_per_block - 1) / Threads_per_block); // sets to the smallest between 32 and the operation

__global__ void dot(float* a, float* b, float* c) {
  __shared__ float cache[Threads_per_block]; // cache shared per block (each block has one)

  int id = threadIdx.x + blockIdx.x * blockDim.x; // thread id, moves between blocks
  int cacheId = threadIdx.x; // cache id, represents one block of the grid
  float temp = 0;

  while(id < Blocks_per_grid) {
    temp += a[id] * b[id];
    id += blockDim.x * gridDim.x;
  }

  cache[cacheId] = temp; // set cache values
  __syncthreads(); // synchronize threads in the block

  int i = blockDim.x / 2; // half the block size

  while(i != 0) {
    // each thread adds two of the values in cache, and stores the result back to cache
    if(cacheId < i) {
      cache[cacheId] + = cache[cacheId + i];
    }
    __syncthreads();
    i /= 2;
  }

  if (cacheId == 0) { // the result of every sum of a block is in the first entry of the cache
    c[blockIdx.x] = cache[0];
  }
}

int main(void) {
  float *a, *b, *partial_c, c; // CPU variables
  float *d_a, *d_b, *d_c; // GPU variables

  // Allocate memory on CPU
  a = (float *) malloc(sizeof(float) * N);
  b = (float *) malloc(sizeof(float) * N);
  c = (float *) malloc(sizeof(float) * Blocks_per_grid);

  c = 0;

  // Allocate memory on GPU
  cudaMalloc((void**)&d_a, sizeof(float) * N);
  cudaMalloc((void**)&d_b, sizeof(float) * N);
  cudaMalloc((void**)&d_c, sizeof(float) * Blocks_per_grid);

  // Fill arrays
  for( int i = 0; i < N; i++){
    a[i] = 1;
    b[i] = i * 2;
  }

  // Copy CPU variables to GPU
  cudaMemcpy(d_a, a, sizeof(float) * N, cudaMemcpyHostToDevice);
  cudaMemcpy(d_b, b, sizeof(float) * N, cudaMemcpyHostToDevice);

  dot<<<Blocks_per_grid, Threads_per_block>>> (d_a, d_b, d_c);

  // Copy result matrix from GPU to CPU
  cudaMemcpy(partial_c, d_c, sizeof(float) * N, cudaMemcpyDeviceToHost);

  // Add sum values of all the blocks
  for(int i = 0; i < Blocks_per_grid; i++){
    c += partial_c[i];
  }

  printf("Value calculated: %.6g.\n", c);

  // free CPU memory
  free(a);
  free(b);
  free(partial_c);

  // free GPU memory
  cudaFree(d_a);
  cudaFree(d_b);
  cudaFree(d_c);

  return 0;

}
