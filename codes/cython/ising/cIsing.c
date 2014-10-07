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
    int i, m, eqSteps, mcSteps;
    double Mag, Ene, E1, E2, M1, M2, beta;
    
    for (m = 0; m < Npoints; m++){
        beta = Beta[m];
        // initialize the SYSTEM
        initialize(spin, Nsites);		
    
        // equilibrating the SYSTEM 
        eqSteps = 10000; 
        for (i = 0 ; i < eqSteps ; i++){
            mcmove(spin, beta, Nsites);
            }
        
        // measurements
        E1 = E2 = M1 = M2 = 0;
        mcSteps = 10000;
        for (i = 0 ; i < mcSteps ; i++){
            
            mcmove(spin,beta, Nsites);
            
            Mag  = total_mag(spin, Nsites);
            Ene  = total_energy(spin, Nsites);
            
            M1 = M1   + Mag;
            E1 = E1   + Ene;
            M2 = M2   + Mag*Mag ;
            E2 = E2   + Ene*Ene;
            }
    
        Energy[m]        = E1/(Nsites*mcSteps);
        Magnetization[m] = M1/(Nsites*mcSteps);
        SpecificHeat[m]  = ( E2/mcSteps - E1*E1/(mcSteps*mcSteps) )*beta*beta/(Nsites);
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
