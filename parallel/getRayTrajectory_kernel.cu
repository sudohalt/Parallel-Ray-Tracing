/* Parallel code to calculate ray trace trajectory */
#include <cuda.h>
#include "getRayTrajectory_kernel.h"

int getRayTrajectory(double** n_profile, double** Dx,double** Dy, double** Dxx, double** Dxy, 
		     double* Dyx, double* Dyy, double x_min, double x_max, double y_min, 
		     double y_max, double delta, double dt, double y0, double theta0)
{
	/* Do parallel stuff */
}
