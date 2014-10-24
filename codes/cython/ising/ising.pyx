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
    cdef int Ns, eqSteps, mcSteps, nPoints
    cdef readonly np.ndarray cost2D
    def __init__(self, Ns, nPoints, eqSteps, mcSteps):
        self.Ns      = Ns 
        self.nPoints = nPoints
        self.eqSteps = eqSteps
        self.mcSteps = mcSteps
        self.cost2D  = np.empty(4, dtype=np.float)

        pass
    
    cpdef oneD(self, int    [:] S, double [:] E, double [:] M, double [:] C, double [:] X, double [:] T):
        cIsing (&S[0], &E[0], &M[0], &C[0], &X[0], &T[0], self.nPoints, self.Ns, self.eqSteps, self.mcSteps)
        return 


    cpdef twoD(self, int [:, :] S, double [:] E, double [:] M, double [:] C, double [:] X, double [:] T):
        cdef int eqSteps = self.eqSteps, mcSteps = self.mcSteps, N = self.Ns, nPoints = self.nPoints
        cdef int i, a, b, t, cost, z = 4, N2 = N*N
        cdef double Ene, Mag, E1, M1, E2, M2, beta, Ene0, Ene1
        cdef long int seedval=time.time()
        cdef double [:] cost2D = self.cost2D
        
        for t in range(nPoints):#, nogil=True):
            E1 = E2 = M1 = M2 = 0
            beta = 1/T[t]
            cost2D[1] = exp(-4*beta)
            cost2D[2] = exp(-8*beta)
            initialstate(S, N, seedval)
            for i in range(eqSteps):
                
                a = int(1 + genrand_real2()*N);  b = int(1 + genrand_real2()*N);
                S[0, b]   = S[N, b];    S[N+1, b] = S[0, b];  # ensuring BC
                S[a, 0]   = S[a, N+1];  S[a, N+1] = S[a, 1];
                
                cost = 2*( S[a+1, b] + S[a, b+1] + S[a-1, b] + S[a, b-1] )*S[a, b]
                if (cost <=0 or genrand_real2() < cost2D[cost/4]):
                    S[a, b] = -S[a, b]

            #Ene0 = calcEnergy(S, N)                   # calculate the energy
            for i in range(mcSteps):
                a = int(1 + genrand_real2()*N);  b = int(1 + genrand_real2()*N);
                S[0, b]   = S[N, b];    S[N+1, b] = S[0, b];
                S[a, 0]   = S[a, N+1];  S[a, N+1] = S[a, 1];

                cost = 2*( S[a+1, b] + S[a, b+1] + S[a-1, b] + S[a, b-1] )*S[a, b]
                if (cost <=0 or genrand_real2() < cost2D[cost/z]):
                    S[a, b] = -S[a, b]
                    ##Ene1 = Ene0 + cost                   # calculate the energy
                
                Ene = calcEnergy(S, N)# - Ene1           # calculate the energ
                Mag = calcMag(S, N)                      # calculate the magnetization  
                E1 = E1 + Ene
                M1 = M1 + Mag
                M2 = M2   + Mag*Mag ;
                E2 = E2   + Ene*Ene;
                
            E[t] = E1/(mcSteps*N2)
            M[t] = M1/(mcSteps*N2)
            C[t] = ( E2/mcSteps - E1*E1/(mcSteps*mcSteps) )/(N*T[t]*T[t]);
            X[t] = ( M2/mcSteps - M1*M1/(mcSteps*mcSteps) )/(N*T[t]*T[t]);
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
cdef int initialstate(int [:, :] S, int N, long int seedval) nogil:    # generates a random spin Spin configuration
    init_genrand(seedval)
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
cdef double calcEnergy(int [:, :] S, int N) nogil:
    ''' Energy calculation'''
    cdef double energy = 0
    cdef int i, j, site, nb
    for i in prange(1, N+1, nogil=True):
        for j in range(1, N+1):
            S[0, j] = S[N, j];  S[i, 0] = S[i, N+1];
            energy += -S[i, j] * (S[i-1, j] + S[i, j-1]) 
    return energy


@cython.wraparound(False)
@cython.boundscheck(False)
@cython.cdivision(True)
@cython.nonecheck(False)
cdef double calcMag(int [:, :] S, int N) nogil:                
    ''' magnetization of  the configuration'''
    cdef double mag = 0
    cdef int i, j,
    
    for i in prange(1, N+1, nogil=True):
        for j in range(1, N+1):
            mag += S[i, j]
    return mag


