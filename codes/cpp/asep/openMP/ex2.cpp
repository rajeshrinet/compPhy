#include <iostream>
#include <cmath>
#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
using namespace std;


int main()
{
    #pragma omp parallel
    cout << "This is test!" << endl;
}
