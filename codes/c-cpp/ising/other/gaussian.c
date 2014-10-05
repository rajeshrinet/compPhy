#include<stdio.h>
#include<math.h>
#include<stdlib.h>
#include "mt19937ar.h"

/* This program generates random numbers using mersenne twister*/

main()
{
	void take_input();
	int i;
	double x1,x2,z1,ran=0;
	
	take_input();
	for (i = 0; i <= 10000; i = i + 1)
	{

		x1 = genrand_real2();
		x2 = genrand_real2();
		ran = sqrt(-2*log(x1))*cos((2*3.14*x2));
		printf("%e\n",ran);
		
	}
}

void take_input()
{
	long seedval;

	seedval = time(0);
	init_genrand(seedval);
}

