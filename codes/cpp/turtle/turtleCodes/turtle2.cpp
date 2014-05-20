// Classes and constructors in C++. 
//
// Rajesh Singh
// 20140429
//
//
//

#include <iostream>
using namespace std;

class turtle{
public :
    int x , y ;
    turtle(){  // constructor
        x = y = 0;
    }
    
    turtle(int a, int b){  // constructor
        x = a;
        y = b;
    }

    void move(int dx , int dy ){
    x += dx ; 
    y += dy ;
    }
    
    void reset( ){
    x = 0 ; 
    y = 0 ;
    }
}; 


int main()
{
    
    turtle t ;              // turtle is at (0 , 0)
    cout << "Turtle started at x = " << t.x << endl;
    cout << "Turtle started at y = " << t.y << endl;
    
    cout << endl;
    t.move(4 , 4);          // turlte has moved to (4, 4)
    cout << "Turtle is now at x = " << t.x << endl;
    cout << "Turtle is now at y = " << t.y << endl;
    
    t.reset();          // turlte has moved to (4, 4)
    cout << "Turtle is now at x = " << t.x << endl;
    cout << "Turtle is now at y = " << t.y << endl;
    
    cout << endl;
    
    turtle t1(5, 6) ;              // Define a new turtle is at (5 , 6)
    cout << "New Turtle is now at x = " << t1.x << endl;
    cout << "New Turtle is now at y = " << t1.y << endl;
    
    return 0;
}

