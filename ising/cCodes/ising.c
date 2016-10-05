/* This program for Ising Model in 1D generates psuedo random numbers using mersenne twister */
//
//
//
// Rajesh Singh
// 
//


#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>    // time()
#include "../../misc/mt19937ar.h"
#include "../../misc/mt19937ar.c"

#define Ns 16

int main()
{
void take_input();
void initialize( int []);
void mcmove( int [],double);
int total_energy( int []);
int total_mag( int []);

int spin[Ns];
double Cv[10];
int i, j, m, r, EQM, MCS;
double Tot_E, big_energy, Tot_E2, big_energy2, E, Cavg;
double Tot_M, big_mag, Tot_M2, big_mag2, Mag, beta;
double be[]={0.25,0.50,0.75,1.0,2.0,4.0,8.0};	
	
	
	for (m = 0; m < 7; m++){
	beta = be[m];
	Cavg = 0;    
  	initialize(spin);		
		
		EQM = 100000;  // equilibrating the SYSTEM 
  		for (i = 0 ; i < EQM ; i++){
		mcmove(spin,beta);
		}
				for (r = 0; r <10 ; r++){
				big_energy = big_mag = big_energy2 = big_mag2 = 0;
					MCS = 10000;
  					for (i = 0 ; i < MCS ; i++){
  				
  					mcmove(spin,beta);
  			
					Mag = total_mag(spin);
					E = total_energy(spin);
				
					big_mag     = big_mag     + Mag;
					big_mag2    =  big_mag2   + Mag*Mag ;
					big_energy  = big_energy  + E;
					big_energy2 = big_energy2 + E*E ;
					}
					
       			Tot_M = big_mag/MCS;
       			Tot_E = big_energy/MCS;
				Tot_M2 = big_mag2/MCS; 
   				Tot_E2 = big_energy2/MCS;			
	
				Cv[r] =( Tot_E2 - (Tot_E * Tot_E) ) * beta * beta;
				Cavg = (Cavg + Cv[r]);
				}
			printf("%e \t %e \t %e \t %e \n",beta, Cavg/10, Cv[3]-(Cavg/10), Tot_E);	
	}
return 0;
}


// FUNCTIONS USED.
/* 1. psuedo random number*/
void take_input(){
	long seedval;
	seedval = time(0);
	init_genrand(seedval);
}


/* 2. Initialize the spin on the Lattice with periodic boundary conditions */
void initialize( int spin[]){
    int i;
	for (i = 0 ; i < Ns ; i++){
	    if (genrand_real2() < 0.5) spin[i] = 1;
	    else spin[i] = -1;	
	    }
	
	spin[Ns-1] = spin[0];
}


/* 3. Monte Carlo Moves employing the Metropolis Algorithm */
	void mcmove( int spin[], double beta){
	int i, ipick;
  	double Ef,E0;
  	
  		for (i = 0 ; i < Ns ; i++){
		ipick =  Ns * genrand_real2() ;	  
     	E0 = total_energy(spin);
   	    spin[ipick] = -spin[ipick];	
   	    Ef = total_energy(spin);
			  
			if (Ef<E0) spin[ipick] = spin[ipick];
			else{
			  	 if (genrand_real2() <= exp(-beta*(Ef-E0))) spin[ipick]=spin[ipick];
  				 else spin[ipick]=-spin[ipick];
  
  			}
	    }
	}


/* 4. Total Energy */
int total_energy( int spin[]){
	int i;
	double sum=0;
	       	for (i = 0; i<Ns; i++) sum = sum - spin[i]*spin[(i+1)%Ns];
	       	return(sum);
}


/*5. Total Magnetization */
int total_mag( int spin[] ){
	int i;
	double mag= 0;
        for (i = 0 ; i < Ns; i++) mag = mag + spin[i];
        return(mag);
}
