#include "../../../c-cpp/utils/mt19937ar.h"
#include "../../../c-cpp/utils/mt19937ar.c"

void cMatMul(double* A, double* B, double* C, double scalar_k, int m, int n) {

init_genrand(12);
    int i, j ;
    int index = 0 ;

    for (i = 0; i < m; i++) {
        for (j = 0; j < n; j++) {
            C[index] = scalar_k * A[index] * B[index] + genrand_real2();
            index ++ ;
            }
        }
    return ;
}
