#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>    // time()


void cIsing(double* Energy, double* Magnetization, double* SpecificHeat, double* Beta, int Npoints, int Nsites) {
srand(time(NULL));
void initialize( int [],         int );
void mcmove(     int [], double, int );
int total_energy(int [],         int );
int total_mag( int [],           int );

int spin[Nsites];
int i, j, m, r, EQM, MCS;
double Tot_E, big_energy, Tot_E2, big_energy2, E, Cavg;
double Tot_M, big_mag, Tot_M2, big_mag2, Mag, beta;

for (m = 0; m < Npoints; m++){
    beta = Beta[m];
    Cavg = 0;    
    // initialize the SYSTEM
    initialize(spin, Nsites);		

    // equilibrating the SYSTEM 
    EQM = 10000; 
    for (i = 0 ; i < EQM ; i++){
        mcmove(spin, beta, Nsites);
        }
    
    // measurements
    big_energy = big_mag = big_energy2 = big_mag2 = 0;
    MCS = 10000;
    for (i = 0 ; i < MCS ; i++){
        
        mcmove(spin,beta, Nsites);
        
        Mag = total_mag(spin, Nsites);
        E   = total_energy(spin, Nsites);
        
        big_mag     = big_mag     + Mag;
        big_mag2    =  big_mag2   + Mag*Mag ;
        big_energy  = big_energy  + E;
        big_energy2 = big_energy2 + E*E ;
        }
            
    Tot_M = big_mag/MCS;
    Tot_E = big_energy/MCS;
    Tot_M2 = big_mag2/MCS; 
    Tot_E2 = big_energy2/MCS;			

    Cavg =( Tot_E2 - (Tot_E * Tot_E) ) * beta * beta;

    Energy[m]        = Tot_E/Nsites;
    Magnetization[m] = Tot_M/Nsites;
    SpecificHeat[m]  = Cavg;
	}
}


// FUNCTIONS USED.


/* 1. Initialize the spin on the Lattice with periodic boundary conditions */
void initialize( int spin[], int Nsites ){
    int i;
	for (i = 0 ; i < Nsites ; i++){
	    if ((rand()%1000000)/1000000.0 < 0.5) spin[i] = 1;
	    else spin[i] = -1;	
	    }
	spin[Nsites-1] = spin[0];
}


/* 2. Monte Carlo Moves employing the Metropolis Algorithm */
	void mcmove( int spin[], double beta, int Nsites ){
	int i, ipick;
  	double Ef,E0;
  		for (i = 0 ; i < Nsites ; i++){
		ipick =  Nsites * (rand()%1000000)/1000000.0 ;	  
     	E0 = total_energy(spin, Nsites);
   	    spin[ipick] = -spin[ipick];	
   	    Ef = total_energy(spin, Nsites);
			  
			if (Ef<E0) spin[ipick] = spin[ipick];
			else{
			  	 if ((rand()%1000000)/1000000.0<= exp(-beta*(Ef-E0))) spin[ipick]=spin[ipick];
  				 else spin[ipick]=-spin[ipick];
  
  			}
	    }
	}


/* 3. Total Energy */
int total_energy( int spin[], int Nsites ){
	int i;
	double sum=0;
	       	for (i = 0; i<Nsites; i++) sum = sum - spin[i]*spin[(i+1)%Nsites];
	       	return(sum);
}


/* 4. Total Magnetization */
int total_mag( int spin[], int Nsites ){
	int i;
	double mag= 0;
        for (i = 0 ; i < Nsites; i++) mag = mag + spin[i];
        return(mag);
}
