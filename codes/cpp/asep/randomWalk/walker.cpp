#include <iostream>
#include <cmath>
#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include "/home/rsingh/software/utils/mt19937ar.h"
#include "/home/rsingh/software/utils/mt19937ar.c"
using namespace std;
/* This program generates random numbers using mersenne twister*/

main()
{
	init_genrand(time(NULL));
	int i, j;
	double x=0, ran=0;
	
	for (j = 0; j<=300002; j=j+1)
	{
		int ii =genrand_real2()*256;
		//x=genrand_real2();
//		if (x<0.5) ran = ran+1;
//		else ran=ran-1; 
//		printf("%d %e \n",j,ran);//(1-2*x);
    if (ii == 0) x = x+1;
}
    cout << 300002/x;
}


