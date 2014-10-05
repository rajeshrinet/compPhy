#include <iostream>
#include <cmath>
#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include "../../../utils/mt19937ar.h"
#include "../../../utils/mt19937ar.c"
using namespace std;

/* This program generates random numbers using mersenne twister*/

main()
{
	int i, j;
	double x=0;
	
	init_genrand(time(NULL));
	for (j = 0; j<=32; j=j+1)
	{
		x=genrand_real2();
	    cout << x << endl;
    }
}


