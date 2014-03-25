import numpy as np
import matMul

a = np.arange(9, dtype=np.float64).reshape((3, 3))
b = np.arange(9, dtype=np.float64).reshape((3, 3))
c = np.arange(9, dtype=np.float64).reshape((3, 3))

print c

matMul.multiply(a, b, c,  3)

print
print 'Updated value of the array is:'
# declare the interface to the C code
print
print c
