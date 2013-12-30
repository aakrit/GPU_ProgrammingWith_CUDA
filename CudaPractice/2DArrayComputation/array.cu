#include <stdio.h>
#include <stdlib.h>

__global__ void kernel(int *array){

  int index_x = blockIdx.x * blockDim.x + threadIdx.x;
  int index_y = blockIdx.y * blockDim.y + threadIdx.y;

  //mapping 2D indcies to a 1D index in device memeory
  int grid_width = gridDim.x * blockDim.x;
  int index = index_y * grid_width + index_x;

  //map the two 2D black indices to a single linear, 1D block
  int result = blockIdx.y * gridDim.x + blockIdx.x;

  //write out the result
  array[index] = result;
}

int main(void){

  int num_elements_x = 16;
  int num_elements_y = 16;

  int num_bytes = num_elements_x * num_elements_y * sizeof(int);
  int *gpu_array = 0;
  int *cpu_array = 0;

  //allocate memeory for cpu and gpu
  cpu_array = (int*)malloc(num_bytes);
  cudaMalloc((void**)&gpu_array, num_bytes);

  //create 2D 4x4 thread blocks
  dim3 block_size;
  block_size.x = 4;
  block_size.y = 4;

  //configure a 2D grid as well
  dim3 grid_size;
  grid_size.x = num_elements_x / block_size.x;
  grid_size.y = num_elements_y / block_size.y;

  //pass the grids to the kernel and have the gpu execute
  kernel<<<grid_size, block_size>>>(gpu_array);

  //copy results and inspect on the cpu
  cudaMemcpy(cpu_array, gpu_array, num_bytes, cudaMemcpyDeviceToHost);
  for(int row = 0; row < num_elements_y; ++row){
    for(int col = 0; col < num_elements_x; ++col){
      printf("%2d ", cpu_array[row * num_elements_x + col]);
    }
    printf("\n");
  }
  printf("\n");
  //free memeory
  free(cpu_array);
  cudaFree(gpu_array);
}




