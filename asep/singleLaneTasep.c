// Implementation of totally asymmetric exclusion process( TASEP) in 1-dimension.
//
//
//
// Rajesh Singh
// 
//


#include<stdio.h>
#include<math.h>
#include<stdlib.h>
#include "../misc/mt19937ar.h"
#include "../misc/mt19937ar.c"
#include <time.h>    // time()


#define Ns 100               // lattice size


int main(){
    //// Declarations
    //define functions for modularity
    void initialise(    int [], double []);
    void addParticle(   int [], double);
    void removeParticle(int [], double);
    void moveParticle(  int [], int   );
    
    int iter=1e8;                        // lattice and iterations to be done on them.
    int i, j, ii, rn;
    int intrvl = 100;                    // interval after how many iterations at which observation is made.
    double lbc=0.9, rbc=0.9;             // boundary conditions (BCs) on the left and right boundaries.
    int A[Ns];                           // occupancy of the site on the lattice
    double d[Ns];                  

    long seedval;
    seedval = time(0);
	init_genrand(seedval);

    initialise(A, d);                    // initialise the lattice randomly!  
    
    
    // now simulate
    for (j=1; j<iter; j++){                  
        rn = genrand_real2()*(Ns+1);     // NOTE that we have generated N+1 RNs for N sized lattice.    

        // case corresponding to the addition of particle
        if (( rn == Ns) && (A[0]==0) )           addParticle(A, lbc);      

        // case corresponding to the particle removal
        else if ( (rn == Ns-1) && (A[Ns-1]==1) ) removeParticle(A, rbc);    
                      
        // move the  particles on the lattice 
        else if ( (A[rn]==1) && (A[rn+1]==0) )   moveParticle(A, rn);       


    // take the observation with this interval!
    if (j>1e5 && j%intrvl==0){                                           
        for (ii=0; ii<Ns; ii++) {d[ii] +=A[ii];}
        } 
    }


    //simulation completed! Now plot, save, etc. with the data.       
    FILE *fp;
    fp = fopen("testData.txt", "w");
    for (i=0; i<Ns; i++){
        printf(     "%d \t %0.4f\t \n", i, intrvl*d[i]/iter);
        fprintf(fp, "%d \t %0.4f\t \n", i, intrvl*d[i]/iter);
    }
    fclose(fp);

return 0;
// that is all!
}


//--------------------------------------------------
// functions block
//--------------------------------------------------

void initialise(int A[], double d[]){
    // initialise the lattice randomly and zero the density to start with.
    int i;
    for (i = 0; i < Ns; i++){
        if ( genrand_real2() <= 0.5) A[i] = 1;
        else A[i] = 0;     

        d[i]  = 0;          //initialise the density to be zero on the site.
        }
}


// add particle
void addParticle(int A[], double lbc){
    if (genrand_real2() <=lbc) A[0]=1;
}


// remove particle
void removeParticle(int A[], double rbc){
    if (genrand_real2() <=rbc) A[Ns-1]=0;
}


// move the particle
// Movement of particles on the lattice depending on the BCs.
void moveParticle(int A[], int rn){
    A[rn]   = 0;
    A[rn+1] = 1;
}
