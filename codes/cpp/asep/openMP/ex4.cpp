#include <iostream>
#include <cmath>
#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
using namespace std;

#define N 10000

int main()
{
int i, j;
//int nthreads = 4;
//omp_set_num_threads(nthreads);
double A[N], B[N], F[N];


    #pragma omp parallel for
    for (i = 0; i < N; i++) {
        for (j = 0; j < N; j++) {
            A[i] = 1234;
            B[i] = A[i]*12 + 32;
            F[i] = A[j]*B[j] + B[i];
            F[i] = F[i]/sqrt(A[i]);
        }
    }

}
