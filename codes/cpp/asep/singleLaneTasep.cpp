// Implementation of totally asymmetric exclusion process( TASEP) in 1-dimension.
//
//
//
// Rajesh Singh
// 
//

#include <iostream>
#include <fstream>
#include <cmath>
#include <stdio.h>
#include <stdlib.h>
#include "mt19937ar.h"
#include "mt19937ar.c"
using namespace std;


int main()
{
    int ld = 100, iter=1e7;       // lattice and iterations to be done on them.
    int i, j, ii, rn;
    int intrvl = 100;             // interval after how many iterations at which observation is made.
    double rn1;                   
    double lbc=0.9, rbc=0.9;      // boundary conditions (BCs) on the left and right boundaries.
    int A[ld];                    // occupancy of the site on the lattice
    double d[ld];                  
	init_genrand(time(NULL));     // seed the random number generator with the NULL of the time!

    
    // initialise the lattice randomly and zero the density to start with.
    for (i = 0; i < ld; i++){
        rn1 = genrand_real2();
        if ( rn1  <= 0.5) A[i] = 1;
        else A[i] = 0;     

        d[i]  = 0;          //initialise the density to be zero on the site.
        }

    
    // Movement of particles on the lattice depending on the BCs.
    for (j=1; j<iter; j++){                  
        rn = genrand_real2()*(ld + 1);        // NOTE that we have generated N+1 RNs for N sized lattice.    

        //case corresponding to the injection
        if (rn == ld){                        
            if (A[0]==0){
                rn1 = genrand_real2();
                if (rn1 <=lbc) A[0]=1;
            }         
        }

        //case corresponding to the withdrawal
        else if (rn == (ld-1)){              
            if (A[ld-1]==1){
                rn1 = genrand_real2();
                if (rn1 <=rbc) A[ld-1]=0;
                }
        }              

        //the shifting of particles on the lattice if the chosen site is not on the boundaries.
        else {                                          
           rn1 = A[rn]; 
           A[rn] = A[rn]*A[rn+1];
           A[rn+1] = A[rn+1] + (1- A[rn+1])*rn1;
        }              

    if (j%intrvl==0){  // take the observation with this interval!
        for (ii=0; ii<ld; ii++) {d[ii] +=A[ii];}
        } 
    }


//simulation completed! Now plot, save, etc. with the data.       
        ofstream myfile;
        myfile.open ("testData.txt");
        for (i=0; i<ld; i++){
             cout <<i<<"  "<<intrvl*d[i]/iter<<endl;
             myfile <<i<<"  "<<intrvl*d[i]/iter<<endl;
        }
        myfile.close();

// that is all!
return 0;
}


