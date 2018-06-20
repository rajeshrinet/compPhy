#include<stdio.h>
#include<math.h>
#include<stdlib.h>
#include "mt19937ar.h"
#define N 255

/* This program for Ising Model in 1D generates psuedo random numbers using mersenne twister */



main()
{
void take_input();

void mcmove( int []);
int total_energy( int []);
int total_mag( int []);
double absolute(double);

int spin[N];
int i, q, j, m, r;
int MCS = 10000;
double Tot_E[MCS], Tot_M[MCS],Tot_E1[MCS], Tot_M1[MCS];
double big_energy, x, y, E, M, big_mag;
	
	
	
x = y = 0;

for (r = 0; r< 10 ; r++){

	  	for (j = 0 ; j < N ; j++){
		if (genrand_real2() < (0.7+0.02*r)) spin[j] = -1;
		else spin[j] = -1;	
		}
		
		spin[N] = spin[0];
		
				
					big_energy = big_mag = 0;

  					for (i = 0 ; i < MCS ; i++){
  				
  					mcmove(spin);
  			
					M = total_mag(spin);
					E = total_energy(spin);
				
					big_mag = big_mag + M;
			
					big_energy = big_energy + E;
					
					Tot_M[i] = big_mag/(i+1);
       				Tot_E[i] = big_energy/(i+1);
					}	
	

					
					for (m=0; m<MCS; m++){	
					Tot_M1[m] = Tot_M1[m] + Tot_M[m];
					Tot_E1[m] = Tot_E1[m] + Tot_E[m];
					}
					


}
				for (q=0;q<MCS;q++){ printf("%d \t %e \t %e \n",q, absolute(Tot_M1[q])/(N*10),Tot_E1[q]/(N*10));}


}



// FUNCTIONS USED.




/* 1. psuedo random number*/


void take_input()
{
	long seedval;
	seedval = time(NULL);
	init_genrand(seedval);
}


/* 2. Initialize the spin on the Lattice with periodic boundary conditions */







/* 3. Monte Carlo Moves employing the Metropolis Algorithm */


	void mcmove( int spin[]){
	int i, ipick;
  	double Ef, E0;
  	
  		for (i = 0 ; i < N ; i++){
  		
		ipick =  N * genrand_real2() ;	  
     	E0 = total_energy(spin);
   	    spin[ipick] = -spin[ipick];	
   	    Ef = total_energy(spin);
			  
			if (Ef<E0) spin[ipick] = spin[ipick];
			else spin[ipick] = -spin[ipick];
  
  		}
	}
	
	
	



/* 4. Total Energy */


int total_energy( int spin[])
{
	int i;
	double sum=0;
	       	for (i = 0; i<N; i++) sum = sum - spin[i]*spin[(i+1)%N];
	       	return(sum);
}




/*5. Total Magnetisation */


int total_mag( int spin[] )
{
	int i;
	double mag= 0;
        for (i = 0 ; i < N; i++) mag = mag + spin[i];
        return(mag);
}


double absolute(double number)
{
    if (number < 0)
        return -number;
    else
        return number;
}



