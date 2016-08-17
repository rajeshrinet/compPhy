# This is the test of cdivision
#   
# Rajesh Singh  
# 20140601
#
#

import test as ct
import numpy as np
import time

rm = ct.cythonDiv()

for i in np.arange(1):
    rm.A()
    rm.B()


N = 40000

x  = np.random.rand((N))
y  = x*5
z = x*0

for i in range(N):
    ct.withCDivMatMul(x, y, z, N)
    ct.withoutCDivMatMul(x, y, z, N) 
        

#
#
#
# Run with following command to get the profilers output
# anaconda -m cProfile -s cumulative driver_test.py >prof.txt
#
