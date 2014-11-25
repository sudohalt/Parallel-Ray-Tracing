#include "getRayTrajectory.h"
#include <stdio.h>      
#include <math.h>  
#include <stdlib.h>

rayData getRayTrajectory(double** n_profile, double** Dx,double** Dy, double** Dxx, double** Dxy, double* Dyx, double* Dyy, double x_min, double x_max, double y_min, double y_max, double delta, double dt, double y0, double theta0)
{
	rayData ray;
	double n, rayX, rayY, Tx, Ty, rayXbef, rayXaft, rayYaft, rayYbef, ratio; 
	ray.rayXvector = (double*)malloc(sizeof(double) * 4501); 
	ray.rayYvector = (double*)malloc(sizeof(double) * 4501); 
	ray.OPL = 0;

	rayX = x_min;
	rayY = y0;
	
	int i = ceil( ( rayY - y_min ) / delta );  
	ratio = ( ( rayY - y_min ) - ( i - 1 ) * delta ) / delta;
	
	if( rayY == y_min) {
    		n = n_profile[1, 1];
	}
	else {
    		n = n_profile[i, 1] + ratio * ( n_profile[i + 1] - n_profile[i - 1] );
	}

	Tx = cos(theta0) / n;
	Ty = sin(theta0) / n;
	
	int b;
	ray.rayXvector[0] = rayX;
	ray.rayYvector[0] = rayY;	
	for(b = 1; rayX < x_max; b++) {
	
		rayXbef = rayX;
		rayYbef = rayY;
		
		rayX = rayX + dt * Tx;
		rayY = rayY + dt * Ty;
		
		rayXaft = rayX;
		rayYaft = rayY;
		
		if(rayX == x_max) {	
		    ray.rayYfinal = rayY;
		    ray.OPL += dt;
		}		
		else if(rayX > x_max) {
		    ratio = (x_max - rayXbef) / (rayXaft - rayXbef);
		    rayY = rayYbef + ratio * (rayYaft - rayYbef);
		    rayX = x_max;
		    ray.rayYfinal = rayY;
		    ray.OPL = ray.OPL + ratio * dt;
		}
		else {
		    ray.OPL += dt;
		}
		
		ray.rayXvector[b] = rayX;
		ray.rayYvector[b] = rayY;
		
		if(rayX < x_max && rayX > x_min && rayY < y_max && rayY > y_min) {
		    int j = ceil( ( rayX - x_min ) / delta );
		    int k = ceil( ( rayY - y_min ) / delta );
		    
		    double dx = ( rayY - y_min ) - ( j - 1 ) * delta;
		    double dy = ( rayY - y_min ) - ( k - 1 ) * delta;
		    
		    double w = n_profile[k, j] + Dx[k, j] * dx + Dy[k, j] * dy;
		    double D_X = Dx[k, j] + Dxx[k, j] * dx + Dxy[k, j] * dy;
		    double D_Y = Dy[k, j] + Dyx[k, j] * dx + Dyy[k, j] * dy;
		    
		    Tx = Tx + dt * ( D_X / pow(w, 3.0) - 2/w * ( Tx * D_X + Ty * D_Y ) * Tx );
		    Ty = Ty + dt * ( D_Y / pow(w, 3.0) - 2/w * ( Tx * D_X + Ty * D_Y ) * Ty );
		}
		else {
		    break;
		}
	}
	
	/* NEED TO CHECK RETURN TYPES! */
	if(ray.rayXvector[b] < x_max) {	
		ray.OPL = 0;
		ray.rayYfinal = 0;
	}
	return ray; 
}
