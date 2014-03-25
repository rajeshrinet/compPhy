import cython
import numpy as np
cimport numpy as np

cdef extern void c_matMul (double* array1, double* array2, double* array3, double value, int m, int n)

@cython.boundscheck(False)
@cython.wraparound(False)
def multiply(np.ndarray[double, ndim=2, mode="c"] input1 not None, np.ndarray[double, ndim=2, mode="c"] input2 not None, np.ndarray[double, ndim=2, mode="c"] input3 not None, double value):
    """
    Pass A, B, C..
    C = A*B
    Value of C is updated!
    """
    cdef int m, n

    m, n = input1.shape[0], input1.shape[1]
    c_matMul (&input1[0,0], &input2[0,0], &input3[0,0], value, m, n)

    return None

