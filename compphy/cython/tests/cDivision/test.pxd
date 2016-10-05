#  header file
#

from __future__ import division
import  numpy as np
cimport numpy as np
cimport cython
from libc.math cimport sqrt
from cython.parallel import prange



cpdef int withCDivMatMul(double[:] A, double[:] B, double[:] C, int N)

cpdef int withoutCDivMatMul(double[:] A, double[:] B, double[:] C, int N)
