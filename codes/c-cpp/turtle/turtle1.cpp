// Dynamics memory allocation in C++ 
// Motion of a turtle in one dimension which is like a random walk 
//
// Rajesh Singh
// 20140429
//
//
//

#include <iostream> 
#include <new>
using namespace std; 
 
int main () 
{ 
    int t, n; 
    int l = 0;
    int r = 0;
    cout << "How many steps does turtle moves? "; 
    cin >> t; 
    int *p = new int[t];     
    
    for (n=0; n<t; n++) 
    { 
        cout << "Enter 1 for left or 2 for right: "; 
        cin >> p[n];
        if (p[n]==1)        l+= 1;
        else if (p[n]==2)   r+= 1;
        else cout << "Enter valid move \n";  
    } 
    
    cout << "The turtle has moved to  " << r-l << endl; 
    cout << "in the following sequence\n";
    
    for (n=0; n<t; n++) 
        if (p[n]==1 or p[n]==2) cout << p[n] << endl;
    
    delete [] p; 
     
    return 0; 
} 
