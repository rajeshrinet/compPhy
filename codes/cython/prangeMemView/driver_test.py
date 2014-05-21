# This is the driver file for demonstration of OpenMP multithreading 
# 
# Rajesh Singh
# 20131223
#
#

import cythontest as ct
import numpy as np
import time


N    = 6000   # size of the array
iter = 1000   # number of iterations 


r1         = np.linspace(-10,10, N)
r2         = np.linspace(-10,10, N)
C = r1*0
C1 = r1*0

# call the cython block
t1 = time.time()

rm = ct.cythontest(N)
rm.calcC(r1, r2, iter)

t2 = time.time()
print
print 'Time taken by cython+python: ',t2-t1

# do the same thing in pure python
#
t3 = time.time()
for j in range(N):
    for tn in range(iter):
        C[j] = r1[j]*r2[j] 
#    
t4 = time.time()
print 'Time taken by pure python  : ',t4-t3
print 'Both result are same       : ', np.allclose(C, rm.C)

print 








