#include<stdio.h>
#include<math.h>
#include<stdlib.h>
#include "mt19937ar.h"

/* This program generates random numbers using mersenne twister*/

main()
{
	void take_input();
	int i,j;
	double x,ran=0;
	
	take_input();
	
	for (i=0; i<1000; i=i+1){
		for (j = 0; j<=1280000; j=j+1)
		{	
	
			x=genrand_real2();
			if (x<0.5) ran = ran+1;
			else ran=ran-1; 
					
		}

	printf("%e \n",ran/(sqrt(1280000)));//(1-2*x);
	}
}

void take_input()
{
	long seedval;

	//printf("\nEnter value of seed : ");
	//scanf("%ld",&seedval);
	seedval = time(0);
	init_genrand(seedval);
}

