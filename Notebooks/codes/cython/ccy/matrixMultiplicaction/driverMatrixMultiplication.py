import numpy as np
import matMul

A = np.arange(9, dtype=np.float64).reshape((3, 3))
B = np.arange(9, dtype=np.float64).reshape((3, 3))
C = np.arange(9, dtype=np.float64).reshape((3, 3))

print C

# Multiply using the function in C
matMul.multiply(A, B, C, 1)  # c = 1*a*b

print
print 'Updated value of the array is:'
print
print C
