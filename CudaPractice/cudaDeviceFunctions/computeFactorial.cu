// we use the __device__ prefix to mark funcitons as callable from threads running // on the device memory

// device function (using __device__ ) are called from the __global__ functions
/*
__device__ float device_fucntion(float x){
  return x + 5;
}
*/
//__device__ funcitons can call other device functions but not them selves

//OK
/*
__device__ float device_function_two(float y){
  return device_function(y)/ 2;
}
*/

//NOT  (currently not supported in CUDA)
/*
__device__ float device_function_two(float z){
  return z * device_fucntion_two(z-1);
}
*/

#include <stdio.h>
#include <stdlib.h>

__device__ int get_thread_index(void){
  return blockIdx.x * blockDim.x + threadIdx.x;
}
__device__ int get_fixedValue(void){
  return 10;
}
__global__ void gpuone(int *a){
  int index = get_thread_index();
  a[index] = get_fixedValue();
}
__global__ void gputwo(int *b){
  int index = get_fixedValue();
  b[index] = get_thread_index();
}
void printArray(int* host, int elements){
  printf("GPU array: \n");
  for(int i = 0; i < elements; i++){
    printf("%d ", host[i]);
  }
  printf("\n\n");
}

int main(void){
  int elements = 256;
  int bytes = elements * sizeof(int);

  int *host = 0, *device = 0;

  host = (int*) malloc(bytes);
  cudaMalloc((void**)&device, bytes);

  int blockSize = 128;
  int gridSize = elements / blockSize;

  gpuone<<<gridSize, blockSize>>>(device);
  cudaMemcpy(host, device, bytes, cudaMemcpyDeviceToHost);

  printArray(host, elements);

  gputwo<<<gridSize, blockSize>>>(device);
  cudaMemcpy(host, device, bytes, cudaMemcpyDeviceToHost);

  printArray(host, elements);

  free(host);
  cudaFree(device);
  return 0;

}


