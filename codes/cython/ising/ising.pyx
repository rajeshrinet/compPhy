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


cdef extern void cIsing (int* S, double* E, double* M, double* C, double* T, int nPoints, int Nsites, int eqSteps, int mcSteps)
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
    def __init__(self, Ns, nPoints, eqSteps, mcSteps):
        self.Ns      = Ns 
        self.nPoints = nPoints
        self.eqSteps = eqSteps
        self.mcSteps = mcSteps

        pass
    
    cpdef oneD(self, int    [:] S, double [:] E, double [:] M, double [:] C, double [:] T):
        cIsing (&S[0], &E[0], &M[0], &C[0], &T[0], self.nPoints, self.Ns, self.eqSteps, self.mcSteps)
        return 


    cpdef twoD(self, int [:, :] S, double [:] E, double [:] M, double [:] C, double [:] X, double [:] T):
        cdef int i, m, eqSteps = self.eqSteps, mcSteps = self.mcSteps, N = self.Ns, nPoints = self.nPoints
        cdef double Ene, Mag, E1, M1, E2, M2
        cdef long int seedval=time.time()
        
        for m in range(nPoints):#, nogil=True):
            E1 = E2 = M1 = M2 = 0
            initialstate(S, N, seedval)
            equilibrate(S, 1.0/T[m], N, eqSteps)                 # This is to equilibrate the system

            for i in range(mcSteps):#, nogil=True):
                mcmove(S, 1.0/T[m], N)                   # Monte Carlo moves
                Ene = calcEnergy(S, N)                   # calculate the energy
                Mag = calcMag(S, N)                      # calculate the magnetization  
                E1 = E1 + Ene
                M1 = M1 + Mag
                M2 = M2   + Mag*Mag ;
                E2 = E2   + Ene*Ene;
                    
            E[m] = E1/(mcSteps*N*N)
            M[m] = M1/(mcSteps*N*N)
            C[m] = ( E2/mcSteps - E1*E1/(mcSteps*mcSteps) )/(N*T[m]*T[m]);
            X[m] = ( M2/mcSteps - M1*M1/(mcSteps*mcSteps) )/(N*T[m]*T[m]);
        return


#-------------------------------------------------------------------
### Functions block
#-------------------------------------------------------------------
@cython.wraparound(False)
@cython.boundscheck(False)
@cython.cdivision(True)
@cython.nonecheck(False)
cdef int initialstate(int [:, :] S, int N, long int seedval) nogil:    # generates a random spin Spin configuration
    init_genrand(seedval)
    for i in range(N):
        for j in range(N):
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
        for i in range(N):
            for j in range(N):            
                    a = int(genrand_real2()*N)
                    b = int(genrand_real2()*N)
                    nb = S[iMod(a+1, N), b] + S[a, iMod(b+1, N)] + S[iMod(a-1, N), b] + S[a, iMod(b-1, N)]
                    cost = 2*nb*S[a, b]
                    if cost < 0:    
                        S[a, b] = -S[a, b]
                    elif genrand_real2() < exp(-cost*beta):
                        S[a, b] = -S[a, b]
                    else:
                        S[a, b] = S[a, b]
    return 0 


@cython.wraparound(False)
@cython.boundscheck(False)
@cython.cdivision(True)
@cython.nonecheck(False)
cdef int mcmove(int [:, :] S, double beta, int N) nogil:
    ''' Monte Carlo moves'''
    cdef int i, j, a, b, s, nb, cost 
    for i in prange(N, nogil=True):
        for j in range(N):            
                a = int(genrand_real2()*N)
                b = int(genrand_real2()*N)
                nb = S[iMod(a+1, N), b] + S[a, iMod(b+1, N)] + S[iMod(a-1, N), b] + S[a, iMod(b-1, N)]
                cost = 2*nb*S[a, b]
                if cost < 0:    
                    S[a, b] = -S[a, b]
                elif genrand_real2() < exp(-cost*beta):
                    S[a, b] = -S[a, b]
                else:
                    S[a, b] = S[a, b]
    return 0 


@cython.wraparound(False)
@cython.boundscheck(False)
@cython.cdivision(True)
@cython.nonecheck(False)
cdef double calcEnergy(int [:, :] S, int N) nogil:
    ''' Energy calculation'''
    cdef double energy = 0
    cdef int i, j, site, nb
    for i in prange(N, nogil=True):
        for j in range(N):
            site = S[i,j]
            nb = S[iMod(i+1, N), j] + S[i, iMod(j+1, N) ] + S[ iMod(i-1, N), j] + S[i, iMod(j-1, N)]
            energy += -nb*site 
    return energy/4. 


@cython.wraparound(False)
@cython.boundscheck(False)
@cython.cdivision(True)
@cython.nonecheck(False)
cdef double calcMag(int [:, :] S, int N) nogil:                
    ''' magnetization of  the configuration'''
    cdef double mag = 0
    cdef int i, j,

    for i in prange(N, nogil=True):
        for j in range(N):
            mag += S[i, j]
    return mag


@cython.wraparound(False)
@cython.boundscheck(False)
@cython.cdivision(True)
@cython.nonecheck(False)
cdef int iMod(int A, int B ) nogil:
    ''' mod function for integers,  tailor-made for this case'''
    if (A==B)   :    A = 0
    elif (A==-1):    A = B-1
    return A

