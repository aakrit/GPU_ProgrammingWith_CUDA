/*
 __global__ functions, or kernels, are like the main function from C. They are the first point of entry into a program which is executed by the GPU device. __global__ functions are qualified with the special CUDA keyword, __global__, which is prepended to their function signature.
 */

#include <stdio.h>
#include "util/cuPrintf.cu"

__global__ void gpu_greeting(void)
{
  cuPrintf("Hello, i'm your GPU talking\n");
}

int main(void){
  //run on CPU
  printf("Hi, this is your CPU computing\n");

  //initialize cuPrintf
  cudaPrintfInit();

  //launch kernel with single thread to greet from device
  gpu_greeting<<<3,3>>>(); //9 threads = 3 blocks with 3 threads eachs

  //display device greetings
  cudaPrintfDisplay();

  //clean up after cuPrintf
  cudaPrintfEnd();

  return 0;
}
