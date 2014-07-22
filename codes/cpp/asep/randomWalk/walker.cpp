#include <iostream>
#include <fstream>
#include <cmath>
#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include "/home/rsingh/software/utils/mt19937ar.h"
#include "/home/rsingh/software/utils/mt19937ar.c"
#define Ns 10000        // number of sites
using namespace std;

/* This program generates random numbers using mersenne twister*/



main()
{
    // define the functions!
    void randomWalk(int []);
    void biasedRandomWalk(int [], double);
    void reflectingRandomWalk(int [], double);
    void singleReflectingRandomWalk(int [], double);
    
    
    init_genrand(time(NULL));   // seed the random number generator
    int i;
    double wall=20, a=0.4;
    int disp[Ns], netDisp[Ns];
    
    // initialse the arrays to be zero
    for (i = 0; i<=Ns; i++){
        disp[i] = 0;
        netDisp[i] = 0;
    }
    
    
    for (i=0; i< Ns; i++){                           // this is to sum over the random walks.
        
        //randomWalk(disp) ;                         // random walk in 1D
        
        //biasedRandomWalk(disp, a) ;                // random walk in 1D with bias
        
        singleReflectingRandomWalk(disp, wall);      // random walk in 1D with ony one reflecting wall
        
        //reflectingRandomWalk(disp, wall) ;         // random walk in 1D with reflecting walls
        
        netDisp[i] = disp[Ns-1];                     //net displacement after each walk.
    }
    
    
    // Simulation completed. Now write the data!
    
    ofstream myfile;
    myfile.open ("testData.txt");
    for (i=0; i< Ns; i++){
        myfile << i << "  " << disp[i] << "  " << netDisp[i] << endl;
    }
    myfile.close();

// this is all!
}


// This is the section for the function used in this program.


// simple random walk
void randomWalk(int disp[]){
    int j;
    double x;
    for (j = 0; j<=Ns; j++){
        x = genrand_real2();
        if (j==0){
            if (x<0.5) disp[j] = 1;
            else disp[j] = -1; 
        }
        else{
            if (x<0.5) disp[j] = disp[j-1]+1;
            else disp[j] = disp[j-1]-1; 
        }
    }
}


//biased random walker
void biasedRandomWalk(int disp[], double a){
    int j;
    double x;
    for (j = 0; j<=Ns; j++){
       x = genrand_real2();
       if (j==0){
           if (x<a) disp[j] = 1;
           else disp[j] = -1; 
       }
       else{
           if (x<a) disp[j] = disp[j-1]+1;
           else disp[j] = disp[j-1]-1; 
       }
   }
}


// single reflecting random walker
void singleReflectingRandomWalk(int disp[], double wall){
    int j;
    double x;
    for (j = 0; j<=Ns; j++){
        x = genrand_real2();
        if (j==0){
            if (x<0.5) disp[j] = 1;
            else disp[j] = -1; 
        }
        else{
            if (x<0.5){
                disp[j] = disp[j-1]+1;
                if (disp[j]==wall) disp[j] = disp[j]-1;
            }
            else disp[j] = disp[j-1]-1; {
            }
        }
    }
}


// double reflecting random walker
void reflectingRandomWalk(int disp[], double wall){
    int j;
    double x;
    for (j = 0; j<=Ns; j++){
        x = genrand_real2();
        if (j==0){
            if (x<0.5) disp[j] = 1;
            else disp[j] = -1; 
        }
        else{
            if (x<0.5){
                disp[j] = disp[j-1]+1;
                if (disp[j]==wall) disp[j] = disp[j]-1;
            }
            else disp[j] = disp[j-1]-1; {
                if (disp[j]==-wall) disp[j] = disp[j]+1;
            }
        }
    }
}
