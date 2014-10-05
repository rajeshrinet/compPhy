// destructors to delete the pointer  passed to the classs
//
// Rajesh Singh
// 20140429
//
//
//

#include <iostream>
#include <math.h>
using namespace std;

class turtle{
public :
    int *x , *y ;

    //constructor: it has same name as the class name
    turtle(const int x0, const int y0){
    x = new int;
    y = new int;
    *x = x0 ; 
    *y = y0 ;
    }
    double disp () {return sqrt( (*x * * x ) + (*y * *y ) );}     
  
    //destructor: it also has the same name as the class name and deletes the pointer
    // The destructor must have the same name as the class, but preceded with a tilde sign (~)  
    ~turtle(){
    delete x;
    delete y;
    }
}; 


int main()
{
    turtle t(3, 4) ;                                  // turtle starts here 
    cout << "Turtle is away from the origin by "<< t.disp() << endl;
    cout << "New Turtle is now at x = " << *t.x << endl;
    cout << "New Turtle is now at y = " << *t.y << endl;
    delete [] t.x ;
    delete [] t.y ;
    return 0;
}

