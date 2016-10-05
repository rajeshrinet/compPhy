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
	for (j = 0; j<=32; j=j+1)
	{

		x=genrand_real2();
		if (x<0.5) ran = ran+1;
		else ran=ran-1; 
		printf("%d %e \n",j,ran);//(1-2*x);
		
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

