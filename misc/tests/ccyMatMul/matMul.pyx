# matrix multiplication using C and Cython 
#
# Rajesh Singh
# 20140220
#


import cython
import numpy as np
cimport numpy as np

cdef extern void cMatMul(double* A, double* B, double* C, double scalar_k, int m, int n)

@cython.boundscheck(False)
@cython.wraparound(False)
def multiply(np.ndarray[double, ndim=2, mode="c"] A not None, np.ndarray[double, ndim=2, mode="c"] B not None, np.ndarray[double, ndim=2, mode="c"] C not None, double scalar_k):
    """
    Pass A, B, C, k, from outside
    C = k*A*B
    Value of C is updated!
    """
    cdef int m, n

    m, n = A.shape[0], B.shape[1]
    cMatMul(&A[0,0], &B[0,0], &C[0,0], scalar_k, m, n)
    return None

