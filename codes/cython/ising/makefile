
PYTHON = ~/software/anaconda/bin/python

all: ising.so

ising.so: ising.pyx
	$(PYTHON) setup.py build_ext --inplace

clean:
	rm -rf build ising.so ising.c ising.html 
