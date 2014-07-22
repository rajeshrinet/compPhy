#include <iostream>
#include <cmath>
#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
using namespace std;


int main()
{
int a= 1024; // a shared variable
#pragma omp parallel
  {
    int x; // a variable local or private to each thread
    x = omp_get_thread_num();
    printf("x = %d, a = %d\n",x,a);
  }
}
