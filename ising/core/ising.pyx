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


cdef extern void cIsing (int* S, double* E, double* M, double* C, double* X, double* T, int nPoints, int Nsites, int eqSteps, int mcSteps)
cdef extern from "time.h" :
    pass
cdef extern from "../../misc/mt19937ar.h" nogil:
    pass
cdef extern from "../../misc/mt19937ar.c" nogil:
    double genrand_real2()
    double init_genrand(unsigned long)


@cython.wraparound(False)
@cython.boundscheck(False)
@cython.cdivision(True)
@cython.nonecheck(False)
cdef class Ising:
    cdef int Ns, eqSteps, mcSteps, nPoints
    cdef readonly np.ndarray cost2D
    def __init__(self, Ns, nPoints, eqSteps, mcSteps):
        self.Ns      = Ns 
        self.nPoints = nPoints
        self.eqSteps = eqSteps
        self.mcSteps = mcSteps
        self.cost2D  = np.zeros((4), dtype=np.float64)

        pass
    
    cpdef oneD(self, int [:] S, double [:] E, double [:] M, double [:] C, double [:] X, double [:] B):
        cIsing (&S[0], &E[0], &M[0], &C[0], &X[0], &B[0], self.nPoints, self.Ns, self.eqSteps, self.mcSteps)
        return 


    cpdef twoD(self, int [:, :] S, double [:] E, double [:] M, double [:] C, double [:] X, double [:] B):
        cdef int eqSteps = self.eqSteps, mcSteps = self.mcSteps, N = self.Ns, nPoints = self.nPoints
        cdef int i, ii, a, b, tt, cost, z = 4, N2 = N*N,  
        cdef double E1, M1, E2, beta,  Ene, Mag
        cdef double iMCS = 1.0/mcSteps, iNs = 1.0/(N2)
        cdef long int seedval=time.time()
        cdef double [:] cost2D = self.cost2D
         
        init_genrand(seedval)
        for tt in range(nPoints):#, nogil=True):
            E1 = E2 = M1 = M2= 0
            Mag=0
            beta = B[tt]
            cost2D[1] = exp(-z*beta)
            cost2D[2] = cost2D[1]*cost2D[1]
            intialise(S, N)

            # first make sure that the system reaches equilibrium
            for i in range(eqSteps):
                for ii in range(N2):
                    a = int(1 + genrand_real2()*N);  b = int(1 + genrand_real2()*N);
                    S[0, b]   = S[N, b];  S[N+1, b] = S[1, b];  # ensuring BC
                    S[a, 0]   = S[a, N];  S[a, N+1] = S[a, 1];
                    
                    cost = 2*S[a, b]*( S[a+1, b] + S[a, b+1] + S[a-1, b] + S[a, b-1] )
                    if (cost <=0 or genrand_real2() < cost2D[cost/z]):
                        S[a, b] = -S[a, b]

            # now make the measurements  
            for i in range(mcSteps):
                for ii in range(N2):
                    a = int(1 + genrand_real2()*N);  b = int(1 + genrand_real2()*N);
                    S[0, b]   = S[N, b];  S[N+1, b] = S[1, b];  # ensuring BC
                    S[a, 0]   = S[a, N];  S[a, N+1] = S[a, 1];
                    
                    cost = 2*S[a, b]*( S[a+1, b] + S[a, b+1] + S[a-1, b] + S[a, b-1] )
                    if (cost <=0 or genrand_real2() < cost2D[cost/z]):
                        S[a, b] = -S[a, b]
                
                Ene = calcEnergy(S, N)
                Mag = calcMag(S,    N)
                E1 = E1 + Ene
                M1 = M1 + Mag
                E2 = E2 + Ene*Ene
                M2 = M2 + Mag*Mag
            
            E[tt] = E1*iMCS*iNs 
            M[tt] = M1*iMCS*iNs 
            C[tt] = (E2*iMCS - E1*E1*iMCS*iMCS)*beta*beta*iNs;
            X[tt] = (M2*iMCS - M1*M1*iMCS*iMCS)*beta*iNs;
        return


#
#
#
#
#
#-------------------------------------------------------------------
#
#
#
#
#
#-------------------------------------------------------------------
### Functions block
#-------------------------------------------------------------------
@cython.wraparound(False)
@cython.boundscheck(False)
@cython.cdivision(True)
@cython.nonecheck(False)
cdef int intialise(int [:, :] S, int N) nogil:    # generates a random spin Spin configuration
    for i in range(1, N+1):
        for j in range(1, N+1):
            if (genrand_real2()<0.5): 
                S[i, j]=-1
            else:
                S[i, j]=1
    return 0  


@cython.wraparound(False)
@cython.boundscheck(False)
@cython.cdivision(True)
@cython.nonecheck(False)
cdef int equilibrate(int [:, :] S, double beta, int N, int eqSteps) nogil: 
    ''' equilibrate the system'''
    cdef int i, j, a, b, s, nb, cost, eq
    for eq in prange(eqSteps, nogil=True):
        for i in range(N*N):
            a = int(1 + genrand_real2()*N)
            b = int(1 + genrand_real2()*N)
            S[0, b]   = S[N, b];    S[N+1, b] = S[0, b];
            S[a, 0]   = S[a, N+1];  S[a, N+1] = S[a, 1]
            nb = S[a+1, b] + S[a, b+1] + S[a-1, b] + S[a, b-1]
            cost = 2*nb*S[a, b]
            if cost < 0:    
                S[a, b] = -S[a, b]
            elif genrand_real2() < exp(-cost*beta):
                S[a, b] = -S[a, b]
    return 0 


@cython.wraparound(False)
@cython.boundscheck(False)
@cython.cdivision(True)
@cython.nonecheck(False)
cdef int mcmove(int [:, :] S, double beta, int N) nogil:
    ''' Monte Carlo moves'''
    cdef int i, j, a, b, s, nb, cost 
    for i in range(N*N,):
        a = int(1 + genrand_real2()*N)
        b = int(1 + genrand_real2()*N)
        S[0, b]   = S[N, b]
        S[N+1, b] = S[0, b]
        S[a, 0]   = S[a, N+1]
        S[a, N+1] = S[a, 1]
        nb = S[a+1, b] + S[a, b+1] + S[a-1, b] + S[a, b-1]
        cost = 2*nb*S[a, b]
        if cost < 0:    
            S[a, b] = -S[a, b]
        elif genrand_real2() < exp(-cost*beta):
            S[a, b] = -S[a, b]
    return 0 


@cython.wraparound(False)
@cython.boundscheck(False)
@cython.cdivision(True)
@cython.nonecheck(False)
cdef int calcEnergy(int [:, :] S, int N) nogil:
    ''' Energy calculation'''
    cdef int i, j, site, nb, energy = 0
    for i in prange(1, N+1, nogil=True):
        for j in range(1, N+1):
            S[0, j] = S[N, j];  S[i, 0] = S[i, N];
            energy += -S[i, j] * (S[i-1, j] + S[i, j-1]) 
    return energy


@cython.wraparound(False)
@cython.boundscheck(False)
@cython.cdivision(True)
@cython.nonecheck(False)
cdef int calcMag(int [:, :] S, int N) nogil:                
    ''' magnetization of  the configuration'''
    cdef int i, j, mag = 0
    
    for i in prange(1, N+1, nogil=True):
        for j in range(1, N+1):
            mag += S[i, j]
    return mag


