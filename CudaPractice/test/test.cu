#include <stdio.h>

__global__ void foo(){

}

int main(){
	foo<<<1,1>>>();
	printf("CUDA error testing: %s\n", cudaGetErrorString(cudaGetLastError()));
	return 0;
}
