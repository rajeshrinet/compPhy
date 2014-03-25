#!/usr/bin/env python

"""
simple test of the multiply.pyx and c_multiply.c test code
"""


import numpy as np

import matMul

a = np.arange(9, dtype=np.float64).reshape((3, 3))
b = np.arange(9, dtype=np.float64).reshape((3, 3))
c = np.arange(9, dtype=np.float64).reshape((3, 3))

print c

matMul.multiply(a, b, c,  3)

print c
