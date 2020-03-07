// compile -> nvcc lab_1.cu -o lab_1
// execute -> lab_1.exe | lab_1.out

// Bruno Maglioni A01700879

#include <iostream>

#define N 100000 // Size of problem
#define TPB 512 // Threads per Block


// Calculates PI sequentially (Riemann Sum) using the CPU.
double cpuPI(long num_rects, double width){
  long i;
  double mid, height, area;
  double sum = 0.0;

  for (i = 0; i < num_rects; i++) {
    mid = (i + 0.5) * width;
    height = 4.0 / (1.0 + mid * mid);
    sum += height;
  }

  area = sum * width;

  return area;
}

// Adds values in array
double addArr(double *arr, double width){
  long i;
  double sum = 0.0;

  for (i = 0; i < N; i++) {
    sum += arr[i];
  }

  return sum;
}

// Calculates PI parallely (Riemann Sum) using the GPU.
__global__ void gpuPI(double *res, double width, long max){
  int index = threadIdx.x + blockIdx.x * blockDim.x;
  int id = index;
  double mid;

  while(id < max){
    mid = (id + 0.5) * width;
    res[id] = (4.0 / (1.0 + mid * mid)) * width;

    id = id + blockDim.x * gridDim.x;
  }
}

int main(){
  double *res; // CPU variables
  double *d_res; // GPU variables

  double piCPU, piGPU, width = 1.0 / N;

  // Allocate memory on CPU
  res = (double*) malloc(sizeof(double) * N); // Result Array

  // Allocate memory on GPU
  cudaMalloc((void**)&d_res, sizeof(double) * N);

  // Call function in GPU
  gpuPI<<< (N / TPB), TPB>>>(d_res, width, N);

  // Copy result array from GPU to CPU
  cudaMemcpy(res, d_res, N * sizeof(double), cudaMemcpyDeviceToHost);

  piCPU = cpuPI(N, width); // Calculate PI using the CPU
  piGPU = addArr(res, width); // Calculate PI by adding the array returned by GPU

  printf("Pi using CPU: %f\n", piCPU);
  printf("Pi using GPU: %f\n", piGPU);

  // Free CPU memory
  free(res);

  // Free GPU memory
  cudaFree(d_res);

  return 0;
}
