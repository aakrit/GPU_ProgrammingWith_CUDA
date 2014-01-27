/*
 __global__ functions, or kernels, are like the main function from C. They are the first point of entry into a program which is executed by the GPU device. __global__ functions are qualified with the special CUDA keyword, __global__, which is prepended to their function signature.
 */

#include <stdio.h>
#include "util/cuPrintf.cu"

static int threads = 3;
static int blocks = 3;

__global__ void gpu_greeting(void)
{
  cuPrintf("Hello, i'm your GPU talking\n");
}

int main(int argc, char** argv){
  //run on CPU
  printf("Hi, this is your CPU computing\n");
  if(argc > 1){
	threads = (int) atoi(argv[1]);
  }
  if(argc > 2){
	blocks = (int) atoi(argv[2]);
  }
  //initialize cuPrintf
  cudaPrintfInit();

  //launch kernel with single thread to greet from device
  gpu_greeting<<<blocks,threads>>>(); //9 threads = 3 blocks with 3 threads eachs

  //display device greetings
  cudaPrintfDisplay();

  //clean up after cuPrintf
  cudaPrintfEnd();

  return 0;
}
