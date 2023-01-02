# Basic cython class for calculating multiplication of two arrays.
#
# Rajesh Singh
# 20131223
#               
#             : this codes uses OpenMP multithreading
#             : it also employs the concept of memory views 
#


import  numpy as np
cimport numpy as np
cimport cython
from libc.math cimport sqrt
from cython.parallel import prange

DTYPE   = np.float64
ctypedef np.float_t DTYPE_t

@cython.wraparound(False)
@cython.boundscheck(False)
@cython.cdivision(True)
cdef class cythontest:
    cdef readonly np.ndarray A, B, C 
    cdef readonly int Nint, someN
       
    def __init__(self, Nint):

        self.someN = Nint
        self.C   = np.empty(Nint, dtype=DTYPE)
    
    
    cpdef calcC(self, np.ndarray A, np.ndarray B, int iter):
        cdef int N = self.someN
        cdef double [:] t1   = A 
        cdef double [:] t2   = B
        
        
        cdef double [:] F   = self.C
        cdef int i, j 
    
    
        for i in prange(N, nogil=True):
            for j in range(iter):            
                F[i] = t1[i] * t2[i] 
                     
        return 
       




