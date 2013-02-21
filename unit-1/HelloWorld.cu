/* 
 * Program to square elements of an array by spinning up seperate threads, each of which 
 * individually calculate the square of an element.
 *
 * .cu extension =>> CUDA extension of a normal C program.
 * 'nvcc' compiler is used to compile this program.
*/

#include<stdio.h>

__global__ void square(float *d_out,float *d_in) {

   	   int idx=threadIdx.x;
	   float f=d_in[idx]; /* the d_ of d_in is a convention of prefixing d_ for any device(GPU) 
                               * variable.
			       */
	   d_out[idx]=f*f;

} //Kernel routine ends

int main(int argc,char **argv) {
    	     
           const int ARRAY_SIZE=64;
	   const int ARRAY_BYTES=ARRAY_SIZE*sizeof(float);

	   //Generate the input array on the "Host"(i.e the CPU)    
	   float h_in[ARRAY_SIZE]; /* the h_ of h_in is a convention of prefixing h_ for any host                                         * variable.
	   	 		    */	   
           for(int i=0;i<ARRAY_SIZE;i++) {
	     h_in[i]=float(i); //Typecast the value i into a float.
	   }

	   float h_out[ARRAY_SIZE];
	   
	   //Declare GPU pointers.
	   float *d_in;
	   float *d_out;
	   
	   //Allocate GPU memory.
	   cudaMalloc((void **)&d_in,ARRAY_BYTES); /* cudaMalloc is similar to regular malloc, but
	                                            * it allocates memory on the GPU.
						    */
	   cudaMalloc((void **)&d_out,ARRAY_BYTES);
	   
	   //Transfer array to GPU.
	   cudaMemcpy(d_in,h_in,ARRAY_BYTES,cudaMemcpyHostToDevice); /* Memory transfer 
	   							      * direction: CPU -> GPU
								      */

           //launch kernel.
	   square<<<1,ARRAY_SIZE>>>(d_out,d_int); /* <<< >>> is the CUDA launch operator.
	   
	   //Copy results back to CPU. Transer direction: GPU -> CPU
	   cudaMemcpy(h_out,d_out,ARRAY_BYTES,cudaMemcpuDeviceToHost);

	   //print resulting array
	   for(int i=0;i<ARRAY_SIZE;i++) {
	     printf("%f",h_out[i]);
	     printf(((i%4)!=3)?"\t":"\n");
	   }

	   //Free GPU memory allocation.
	   cudaFree(d_in); cudaFree(d_out);	   
	   return 0;
