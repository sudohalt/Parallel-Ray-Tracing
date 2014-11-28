/* Parallel code to calculate ray trace trajectory */
#include <cuda.h>
#include "cudaUtil.h"
#include "getRayTrajectory_kernel.h"

int main(int argc, char *argv[])
{
	/* Declare doubles */
	double x_min = 0.0;
	double x_max = 0.0;
	double y_min = 0.0;
	double y_max - 0.0;
	double delta = 0.0;
	double dt = 0.0;
	double y0 = 0.0; 
	double theta0 = 0.0; 

	/* Allocate space for host arrays */
	double** n_profile = malloc(sizeof(double) * /* Some size */);
	double** Dx = malloc(sizeof(double) * /* Some size */);
	double** Dy = malloc(sizeof(double) * /* Some size */);
	double** Dxx = malloc(sizeof(double) * /* Some size */);
	double** Dxy = malloc(sizeof(double) * /* Some size */);
	double** Dyx = malloc(sizeof(double) * /* Some size */);
	double** Dyy = malloc(sizeof(double) * /* Some size */);
	
	/* Fill host arrays with necessary data */

	/* Allocate space for device arrays */	
	double** n_profileDevice = AllocateDevice(/* Some size */);
	double** DxDevice = AllocateDevice(/* Some size */);
	double** DyDevice = AllocateDevice(/* Some size */);
	double** DxxDevice = AllocateDevice(/* Some size */);
	double** DxyDevice = AllocateDevice(/* Some size */);
	double** DyxDevice = AllocateDevice(/* Some size */);
	double** DyyDevice = AllocateDevice(/* Some size */);

	/* Copy host array contents to device array */	
	CopyToDevice(n_profileDevice, n_profile, /* Some size */); 
	CopyToDevice(DxDevice, Dx, /* Some size */);
	CopyToDevice(DyDevice, Dy, /* Some size */);
	CopyToDevice(DxxDevice, Dxx, /* Some size */);
	CopyToDevice(DxyDevice, Dxy, /* Some size */);
	CopyToDevice(DyxDevice, Dyx, /* Some size */);
	CopyToDevice(DyyDevice, Dyy, /* Some size */);

	/* Set up dimensions and threads */
	dim3 gridDimensions;
	gridDimensions.x = 0;
	gridDimensions.y = 0;
	gridDimensions.z = 0;
	dim3 blockDimensions;
	blockDimensions.x = 0;
	blockDimensions.y = 0;
	blockDimensions.z = 0;

	/* Call kernel function */
	getRayTrajectory_kernel<<gridDimensions, blockDimensions>>(n_profileDevice, DxDevice, 
			DyDevice, DxxDevice, DxyDevice, DyxDevice, DyyDevice, x_min, x_max, 
			y_min, y_max, delta, dt, y0, theta0);
	
	/* Copy contents from device arrays to host arrays */

	/* Free devcice memory */
	FreeDevice(n_profileDevice);
	FreeDevice(DxDevice);
	FreeDevice(DyDevice);
	FreeDevice(DxxDevice);
	FreeDevice(DxyDevice);
	FreeDevice(DyxDevice);
	FreeDevice(DyyDevice);

	/* Free host memory */
	free(n_profile);
	free(Dx);
	free(Dy);
	free(Dxx);
	free(Dxy);
	free(Dyx);
	free(Dyy);

	return 0;
}
