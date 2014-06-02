# Cython file for the test of cdivision: 
#   
# Rajesh Singh  
# 20140601
#
#

import  numpy as np
cimport numpy as np
cimport cython
from libc.math cimport sqrt
from cython.parallel import prange

DTYPE   = np.float
ctypedef np.float_t DTYPE_t

@cython.boundscheck(False)
@cython.wraparound(False)
@cython.nonecheck(False)
@cython.cdivision(True) 
cdef class cythonDiv:
    cpdef A(self):
        withCDiv()
    cpdef B(self):
        withoutCDiv()


@cython.nonecheck(False)
@cython.wraparound(False)
@cython.boundscheck(False)
@cython.cdivision(False)
cdef withCDiv():
    cdef int aa = -28
    cdef int L = 128
    print 'python way', aa%L
    

@cython.nonecheck(False)
@cython.wraparound(False)
@cython.boundscheck(False)
@cython.cdivision(True)
cdef withoutCDiv():
    cdef int aa = -28
    cdef int L = 128
    print 'C  way', aa%L


    

@cython.nonecheck(False)
@cython.wraparound(False)
@cython.boundscheck(False)
@cython.cdivision(True)
@cython.profile(True)
cpdef int withCDivMatMul(double[:] A, double[:] B, double[:] C, int N):

    cdef int i
    for i in prange(N, nogil=True):
        C[i] = A[i]/B[i]
    return 0

@cython.nonecheck(False)
@cython.wraparound(False)
@cython.boundscheck(False)
@cython.cdivision(False)
@cython.profile(True)
cpdef int withoutCDivMatMul(double[:] A, double[:] B, double[:] C, int N):

    cdef int i
    for i in prange(N, nogil=True):
        C[i] = A[i]/B[i]
    return 0
