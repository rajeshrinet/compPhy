
PYTHON = ~/software/anaconda/bin/python

all: cythontest.so

cythontest.so: cythontest.pyx
	$(PYTHON) setup.py build_ext --inplace

Force.so: Force.pyx
	$(PYTHON) setup.py build_ext --inplace

clean:
	rm -rf build cythontest.so cythontest.c cythontest.html 
