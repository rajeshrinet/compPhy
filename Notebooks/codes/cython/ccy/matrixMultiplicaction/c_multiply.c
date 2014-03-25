void c_multiply (double* array1, double* arrayr2, double* array3, double multiplier, int m, int n) {

    int i, j ;
    int index = 0 ;

    for (i = 0; i < m; i++) {
        for (j = 0; j < n; j++) {
            array3[index] = array1[index]  * arrayr2[index] ;
            index ++ ;
            }
        }
    return ;
}
