void c_multiply (double* A, double* B, double* C, double multiplier, int m, int n) {

    int i, j ;
    int index = 0 ;

    for (i = 0; i < m; i++) {
        for (j = 0; j < n; j++) {
            C[index] = A[index] * B[index] ;
            index ++ ;
            }
        }
    return ;
}
