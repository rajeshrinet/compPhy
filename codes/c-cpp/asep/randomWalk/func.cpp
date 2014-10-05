#include <iostream>
#include <stdio.h>
#include <stdlib.h>
using namespace std;

main()
{
    void table(int [], double a);
    int i;
	int A[10];      //define a 1D array of size N
    double a = 4;


    cout << "before the function call, the elements of A are" << endl;
    for (i=0; i<10; i++){
        cout << A[i] << endl;
    }
    
    table(A, a);
   
    cout << "after the function call, the elements of A are" << endl;
    for (i=0; i<10; i++){
        cout << A[i] << endl;
    }
    
}




void table(int A[], double a){
    int i;
    for (i=1; i<11; i++){
        A[i-1] = a*i;
    }
}


