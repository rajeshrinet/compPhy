#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>    // time()


void cIsing(int* Spin, double* Energy, double* Magnetization, double* SpecificHeat, double* Susceptibility, double* Beta, int Npoints, int Nsites, int eqSteps, int mcSteps) {
    srand(time(NULL));
    void initialize( int [],         int );
    void mcmove(     int [], double, int );
    int total_energy(int [],         int );
    int total_mag( int [],           int );
    
    int i, m;
    double Mag, Ene, E1, E2, M1, M2, beta;
    
    for (m = 0; m < Npoints; m++){
        beta = Beta[m];
        // initialize the SYSTEM
        initialize(Spin, Nsites);		
    
        // equilibrating the SYSTEM 
        for (i = 0 ; i < eqSteps ; i++){
            mcmove(Spin, beta, Nsites);
            }
        
        // measurements
        E1 = E2 = M1 = M2 = 0;
        for (i = 0 ; i < mcSteps ; i++){
            mcmove(Spin, beta, Nsites);
              
            Mag  = total_mag(Spin, Nsites);
            Ene  = total_energy(Spin, Nsites);
            
            M1 = M1   + Mag;
            E1 = E1   + Ene;
            M2 = M2   + Mag*Mag ;
            E2 = E2   + Ene*Ene;
            }
    
        Energy[m]         = E1/(Nsites*mcSteps);
        Magnetization[m]  = M1/(Nsites*mcSteps);
        SpecificHeat[m]   = ( E2/mcSteps - E1*E1/(mcSteps*mcSteps) )*beta*beta/(Nsites);
        Susceptibility[m] = ( M2/mcSteps - M1*M1/(mcSteps*mcSteps) )*beta*beta/(Nsites);
    	}
    }


// FUNCTIONS USED.
/* 1. Initialize the spin on the Lattice with periodic boundary conditions */
void initialize( int Spin[], int Nsites ){
    int i;
	for (i = 0 ; i < Nsites ; i++){
	    if ((rand()%1000000)/1000000.0 < 0.5) Spin[i] = 1;
	    else Spin[i] = -1;	
	    }
	Spin[Nsites-1] = Spin[0];
}


/* 2. Monte Carlo Moves employing the Metropolis Algorithm */
	void mcmove( int Spin[], double beta, int Nsites ){
	int i, ipick;
  	double Ef,E0, cost=exp(-4*beta);
  		for (i = 0 ; i < Nsites ; i++){
		ipick =  Nsites * (rand()%1000000)/1000000.0 ;	  
     	E0 = total_energy(Spin, Nsites);
   	    Spin[ipick] = -Spin[ipick];	
   	    Ef = total_energy(Spin, Nsites);
			  
			if (Ef<=E0) Spin[ipick] = Spin[ipick];
			else{
			  	 if ((rand()%1000000)/1000000.0<= cost) Spin[ipick]=Spin[ipick];
  				 else Spin[ipick]=-Spin[ipick];
  
  			}
	    }
	}


/* 3. Total Energy */
int total_energy( int Spin[], int Nsites ){
	int i;
	double sum=0;
	       	for (i = 0; i<Nsites; i++) sum = sum - Spin[i]*Spin[(i+1)%Nsites];
	       	return(sum);
}


/* 4. Total Magnetization */
int total_mag( int Spin[], int Nsites ){
	int i;
	double mag= 0;
        for (i = 0 ; i < Nsites; i++) mag = mag + Spin[i];
        return(mag);
}
