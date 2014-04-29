// pointer
#include <iostream>
using namespace std;

/*
//// program 1: Basics
int main ()
{
    int A, B;
    int * P;  // P is a pointer
    
    P = &A;            // &A means the address of 
    *P = 10;           // *A means value of A
    
    cout << "Address of A is " << &P << '\n';
    P = &B;
    *P = 20;
    cout << "A is " << A << '\n';
    cout << "B is " << B << '\n';
    return 0;
}
*/

/*
// Program 2: Address of the pointer
int main ()
{
    int B;
    int * P1, *P2, *P3;  // P is a pointer
    B = 10;    
    P1 = &B;
    P2 = P1 + 5;    
    P3 = P1 - 5;    
  
    cout << "Address of B is  " << &P1 << '\n';
    cout << "Difference in addresses is  " << P2 - P3 << '\n';

return 0;
}
*/


// Program 3: Pointer and arrays
int main ()
{
    int i, B, N;
    cout << "Enter the number of person\n ";
    cin  >> N;
    int age[N];
    float sum = 0;
    int * P1;  // P is a pointer
    B = 10;    
    P1 = age;  // P1 point to the first element of the age
   
    for(i=0; i<N; i++) 
    {
        cout<< "Enter ages"<<endl;
        cin>> *P1;
        sum += *P1;
        P1++;        // point to the next memory location
    }    
    P1 = age;        // reset the pointer to the first element of the array
    cout << "Sum of the ages is "<< sum<< endl;
    cout << "Age of last person is " << *(P1+N-1)<<endl;
return 0;
}
