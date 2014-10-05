#include <iostream>
#include <cmath>
#include <stdio.h>
#include <stdlib.h>
#include "../../../utils//mt19937ar.h"
#include "../../../utils//mt19937ar.c"
using namespace std;


int main()
{
    int Np=1E7, i;
    double sum=0, x, y;
	init_genrand(time(NULL));     // seed the random number generator with the NULL of the time!
    
    for (i = 0; i < Np; i++) {
        x = genrand_real2() ;
        y = genrand_real2() ;
        if(x*x + y*y < 1.0)  sum++;      // Check if point lies in circle
        }
    cout<< sum/(0.25*Np) << endl;
}
