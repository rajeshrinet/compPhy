cimport cython
from libc.math cimport sqrt, exp, pow, erfc, sin, cos, int 
from cython.parallel import prange
import numpy as np
cimport numpy as np
cdef double PI = 3.14159265359
DTYPE   = np.float

cdef extern from "complex.h" nogil:
    double complex cexp(double complex x)

@cython.wraparound(False)
@cython.boundscheck(False)
@cython.nonecheck(False)
@cython.cdivision(True)
cdef class cythontest:
    cdef readonly np.ndarray  C, CC , CC1, fk0, fkx, fky
    cdef readonly int Nint, someN
    cdef readonly double th

       
    def __init__(self, Nint):
        self.someN = Nint
        self.th   = 2.0
        self.C   = np.zeros(Nint, dtype=np.complex128)
        self.CC = np.zeros((Nint, Nint), dtype=np.complex128)
        self.CC1 = np.zeros((Nint, Nint), dtype=np.complex128)
        self.fk0 = np.zeros((Nint, Nint), dtype=np.complex128)
        self.fkx = np.zeros((Nint, Nint), dtype=np.complex128) 
        self.fky = np.zeros((Nint, Nint), dtype=np.complex128)

    cpdef withGIL(self ):
        cdef int N = self.someN, i, j    
        cdef complex [:] F   = self.C
        
    
        for i in range(N):
            for j in range(N):            
                F[i] += 1j*cexp(1j*4) 
        print 'came out safely!'
        return
    
    
    cpdef withoutGIL(self ):
        cdef int N = self.someN, i, jj    
        cdef complex [:] F   = self.C
        
        #for i in range(N):
        for i in prange(N, nogil=True):
            for jj in range(N):            
                F[i] += 1j* (cos(4) + 1j*sin(4))
                #F[i] += 1j*cexp(1j*4)    # using cexp

        print 'came out safely!'
        return
    
    cpdef withoutGIL2D(self ):
        cdef int N = self.someN, i, jj , t
        cdef complex [:, :] FF   = self.CC
        cdef complex [:, :] FF1   = self.CC1
        
        #for i in range(N):
        for i in prange(N, nogil=True):
            for jj in range(N):            
                for t in range(500):  # this is to see if prange works
                    FF[i, jj] += 1j*FF1[jj, i]* (cos(4) + 1j*sin(4))
                    FF[i, jj] += 1j*FF1[jj, i]* (cexp(4+1j*7))

        print 'came out safely!'
        return
        
    cpdef stressletV(self, np.ndarray v, double [:] r, double [:] S, double sigma=1, int NN=20):
        cdef:
            int i, nx, ny , x, y, Nx, Ny, Np, jx, jy
            double arg, facx, facy, kx, ky, skk, skx, sky, 
            double scale = pow(2*PI*sigma*sigma, 2/2) 
            double kdotdr, pdotk
            double [:, :] fx0 = self.fx0
            complex [:, :] fk0 = self.fk0
            complex [:, :] fkx = self.fkx
            complex [:, :] fky = self.fky
        Nx = self.N
        Ny = self.N 
        facx = self.th
        facy = self.th
        Np = self.N
       
        x = int(Nx/3)
        y = int(Ny/3)
        for ny in range(2*NN+2):
            for nx in range(2*NN+2):
                x = x - NN + nx
                y = y - NN + ny
                arg = ((x-Nx/2 )**2 + (y -Ny/2)**2 )/ (2 * sigma*sigma)
                x = x%Nx
                y = y%Ny
                self.fx0[y, x] += exp(-arg)*scale
        
        self.fk0 = np.fft.fftn(self.fx0)

        for jy in prange(Nx, nogil=True): 
            for jx in range(0, Ny): 
                for i in range(Np):
                    kx = jx*facx if jx <= Nx / 2 else (-Nx+jx)*facx
                    ky = jy*facy if jy <= Ny / 2 else (-Ny+jy)*facy
                    kdotdr = kx*(r[i]-Nx/2) + ky*(r[i+Np]-Ny/2)
                    skx = S[i]*kx    + S[i+Np]*ky
                    sky = S[i+Np]*kx - S[i]*ky
                    fkx[jy, jx] += -1j*fk0[jy, jx]*skx*(cos(kdotdr) + 1j*sin(kdotdr))
                    fky[jy, jx] += -1j*fk0[jy, jx]*sky*(cos(kdotdr) + 1j*sin(kdotdr))
        self.solve( v, np.concatenate(( self.fkx.reshape(Nx*Ny), self.fky.reshape(Ny*Ny) ))   )
        return
    

    cpdef solve(self, np.ndarray v, np.ndarray f, ):
        pass
