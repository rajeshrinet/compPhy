# Ising model simulation 
#
#
#

import cython
import numpy as np
cimport numpy as np

cdef extern void cIsing (double* A, double* B, double* C, double* D, int Npoints, int Nsites)
@cython.wraparound(False)
@cython.boundscheck(False)
@cython.cdivision(True)
@cython.nonecheck(False)
cdef class Ising:
    cdef int Ns 
    def __init__(self, Ns):
        pass
    
    cpdef oneD(self, np.ndarray[double, ndim=1, mode="c"] A, np.ndarray[double, ndim=1, mode="c"] B, np.ndarray[double, ndim=1, mode="c"] C, np.ndarray[double, ndim=1, mode="c"] D, int Npoints, int Nsites):
    
        cIsing (&A[0], &B[0], &C[0], &D[0], Npoints, Nsites)

        return 

