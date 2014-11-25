#include "cudaUtil.h"
#include <cuda.h>

/* Function: AllocateDevice 
 *--------------------------
 * Allocate memory on device 
 * 
 * size_t size: size of memory to allocate 
 *
 * returns a void * pointer to allocated memory on device
 */
void* AllocateDevice(size_t size)
{
  void* ret;
  cudaMalloc(&ret, size);
  return ret;
}

/* Function: CudaMemCpyToSymbol 
 *------------------------------
 * Copy memory into device cache 
 * 
 * void *D_device: pointer to allocated location in device memory
 * void *D_host: pointer to allocated memory in host to copy data from
 *
 * returns nothing
 */
void CudaMemCpyToSymbol(void *D_device, void *D_host, size_t size)
{
  cudaMemcpyToSymbol(D_device, D_host, size);
}

/* Function: CopyToDevice 
 *------------------------
 * Copy memory from host to device
 *
 * void *D_device: pointer to allocated location in device memory to copy data into
 * void *D_host: pointer to allocated memory in host to copy data from
 * size_t size: size of memory to copy over 
 * 
 * returns nothing
 */
void CopyToDevice(void* D_device, void* D_host, size_t size)
{
  cudaMemcpy(D_device, D_host, size, cudaMemcpyHostToDevice);
}

/* Function: CopyFromDevice
 *--------------------------
 * Copy memory from device to host 
 *
 * void *D_host: pointer to allocated location in host memory to copy data into
 * void *D_device: pointer to allocated memory in device to copy data from
 * size_t size: size of memory to copy over
 *
 * returns nothing
 */
void CopyFromDevice(void* D_host, void* D_device, size_t size)
{
  cudaMemcpy(D_host, D_device, size, cudaMemcpyDeviceToHost);
}

/* Function: FreeDevice 
 *---------------------- 
 * Free allocated memory on device 
 * 
 * void *D_device: pointer to allocated memory in device to free
 *
 * returns nothing
 */
void FreeDevice(void* D_device)
{
  cudaFree(D_device);
}
