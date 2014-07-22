import test
N = 2400
rm = test.cythontest(N)
rm.withGIL()
print rm.C
rm.withoutGIL()
print rm.C
rm.withoutGIL2D()
print rm.CC
