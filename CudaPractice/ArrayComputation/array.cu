
#include <stdlib.h>
#include <stdio.h>

extern int j = 0;

__global__ void kernel(int *array, int j){
  int index = blockIdx.x * blockDim.x + threadIdx.x;
  array[index] = j;
  j++;
}

int main(void){
  int elements = 256;
  int bytes = elements * sizeof(int);

  //points to cpu and gpu arrays
  int *gpu_array = 0;
  int *cpu_array = 0;

  //malloc cpu array
  cpu_array = (int *)malloc(bytes);

  //cudaMalloc gpu array
  cudaMalloc((void**) &gpu_array, bytes);

  int blockSize = 128;
  int gridSize = elements/ blockSize;

  kernel<<<gridSize, blockSize>>>(gpu_array, j);

  //copy to host
  cudaMemcpy(cpu_array, gpu_array, bytes, cudaMemcpyDeviceToHost);

  //print results
  for(int i = 0; i < elements; ++i){
    printf("%d ", cpu_array[i]);
  }
  printf("\n");
  //de_allocate memory
  free(cpu_array);
  cudaFree(gpu_array);

}

