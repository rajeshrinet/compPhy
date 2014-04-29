#include <iostream>
using namespace std;

class Box
{
    public:
    double length;   
    double breadth;  
    double height;   
};


int main( )
{
    Box Box1; // Instantiate Box1 of type Box
    Box Box2; // Instantiate Box2 of type Box
    cout <<Box1.length<<endl;
    double volume = 0.0;  
 
    Box1.height  = 1.0; 
    Box1.length  = 1.0; 
    Box1.breadth = 1.0;
    
    Box2.height  = 2.0;
    Box2.length  = 2.0;
    Box2.breadth = 2.0;
 
    volume = Box1.height * Box1.length * Box1.breadth;
    cout << "Volume of Box1 : " << volume <<endl;
    
    volume = Box2.height * Box2.length * Box2.breadth;
    cout << "Volume of Box2 : " << volume <<endl;
    
    return 0;
}

