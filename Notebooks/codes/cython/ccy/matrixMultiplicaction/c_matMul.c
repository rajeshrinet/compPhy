void c_matMul (double* A, double* B, double* C, double scalar_k, int m, int n) {

    int i, j ;
    int index = 0 ;

    for (i = 0; i < m; i++) {
        for (j = 0; j < n; j++) {
            C[index] = scalar_k * A[index] * B[index] ;
            index ++ ;
            }
        }
    return ;
}
