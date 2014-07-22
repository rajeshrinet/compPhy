#include <iostream>
#include <stdio.h>
#include <stdlib.h>
using namespace std;

main()
{
    int i, j, N=32;
	double A[N];      //define a 1D array of size N
	
    cout<<"Before the assignment"<<endl;
    for (i = 0; i<=N; i++){
    cout << A[i] << endl;
    }
	
    // assign values to the array.
    for (i = 0; i<=N; i++){
    A[i] = i;
    }
    
    cout<<"After the assignment"<<endl;
    for (i = 0; i<=N; i++){
    cout << A[i] << endl;
    }
}



