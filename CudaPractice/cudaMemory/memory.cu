#include <stdlib.h>
#include <stdio.h>

int main(void){

  int elements = 16;
  int bytes = elements * sizeof(int);

  int *device = 0;
  int *host = 0;

  host = (int*)malloc(bytes);

  cudaMalloc((void**)&device, bytes);
  cudaMemset(device, 0, bytes);
  cudaMemcpy(host, device, bytes, cudaMemcpyDeviceToHost);
  printf("\n");
  for(int i = 0; i < elements; ++i){
    printf("%d", host[i]);
  }
  /* can't access device without using host to copy into 1st
  printf("\n");
  for(int j = 0; j < elements; ++j){
    printf("%d", device[i]);
  }
  */
  free(host);

  cudaFree(device);

  return 0;

}
