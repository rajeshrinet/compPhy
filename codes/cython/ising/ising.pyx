# Ising model simulation 
#
#
#

import cython
import numpy as np
cimport numpy as np
import matplotlib.pyplot as plt
from numpy.random import rand
from libc.math cimport sqrt, fabs, int, exp
from cython.parallel import prange
import time


cdef extern void cIsing (double* A, double* B, double* C, double* D, int Npoints, int Nsites)
cdef extern from "time.h" :
    pass
cdef extern from "../../c-cpp/utils/mt19937ar.h" nogil:
    pass
cdef extern from "../../c-cpp/utils/mt19937ar.c" nogil:
    double genrand_real2()
    double init_genrand(unsigned long)
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


    cpdef twoD(self, int N, int Nt, int eqm, int msrmnt, config, Tot_E, Tot_M, temp):
        cdef int i, m
        cdef double [:] E = Tot_E
        cdef double [:] M = Tot_M
        cdef double [:] T = temp
        cdef int [:, :] C = config
        cdef double Energy, Mag, 
        cdef long int seedval=time.time()
        
        for m in range(Nt):#, nogil=True):
            initialstate(C, N, seedval)
            equilibrate(C, 1.0/T[m], N, eqm)                 # This is to equilibrate the system

            for i in range(msrmnt):#, nogil=True):
                mcmove(C, 1.0/T[m], N)                   # monte carlo moves
                Energy = calcEnergy(C, N)                        # calculate the energy
                Mag    = calcMag(C, N)                              # calculate the magnetisation  
                E[m] = E[m] + Energy
                M[m] = M[m] + Mag
                    
        for i in prange(Nt, nogil=True):
            E[i] /= (2*msrmnt*N*N)
            M[i] /= (msrmnt*N*N)
        return

#-------------------------------------------------------------------
### Functions block
#-------------------------------------------------------------------
@cython.boundscheck(False)
cdef int initialstate(int [:, :] C, int N, long int seedval) nogil:    # generates a random spin configuration
    init_genrand(seedval)
    for i in range(N):
        for j in range(N):
            if (genrand_real2()<0.5): 
                C[i, j]=-1
            else:
                C[i, j]=1
    return 0  

@cython.boundscheck(False)
cdef int equilibrate(int [:, :] C, double beta, int N, int eqm) nogil:
    cdef int i, j, a, b, s, nb, cost, eq
    for eq in prange(eqm, nogil=True):
        for i in range(N):
            for j in range(N):            
                    a = int(genrand_real2()*N)
                    b = int(genrand_real2()*N)
                    nb = C[(a+1)%N,b] + C[a,(b+1)%N] + C[(a-1)%N,b] + C[a,(b-1)%N]
                    cost = 2*nb*C[a, b]
                    if cost < 0:    
                        C[a, b] = -C[a, b]
                    elif genrand_real2() < exp(-cost*beta):
                        C[a, b] = -C[a, b]
                    else:
                        C[a, b] = C[a, b]
    return 0 

@cython.boundscheck(False)
cdef int mcmove(int [:, :] C, double beta, int N) nogil:
    cdef int i, j, a, b, s, nb, cost 
    for i in prange(N, nogil=True):
        for j in range(N):            
                a = int(genrand_real2()*N)
                b = int(genrand_real2()*N)
                nb = C[(a+1)%N,b] + C[a,(b+1)%N] + C[(a-1)%N,b] + C[a,(b-1)%N]
                cost = 2*nb*C[a, b]
                if cost < 0:    
                    C[a, b] = -C[a, b]
                elif genrand_real2() < exp(-cost*beta):
                    C[a, b] = -C[a, b]
                else:
                    C[a, b] = C[a, b]
    return 0 


## Energy calculation
@cython.boundscheck(False)
cdef double calcEnergy(int [:, :] C, int N) nogil:
    cdef double energy = 0
    cdef int i, j, S, nb
    for i in prange(N, nogil=True):
        for j in range(N):
            S = C[i,j]
            nb = C[(i+1)%N, j] + C[i,(j+1)%N] + C[(i-1)%N, j] + C[i,(j-1)%N]
            energy += -nb*S 
    return energy/2. 

## magnetization of  the configuration
@cython.boundscheck(False)
cdef double calcMag(int [:, :] C, int N) nogil:                
    cdef double mag = 0
    cdef int i, j,

    for i in prange(N, nogil=True):
        for j in range(N):
            mag += C[i, j]
    return mag

cdef int iMod(int A, int B ):
    ''' mod function for integers'''
    pass

cdef double dMod(double A, double B ):
    '''  mod function for doubles'''
    pass
