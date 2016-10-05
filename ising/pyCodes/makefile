
PYTHON = ~/software/anaconda/bin/python

all: core/ising.so

core/ising.so: core/ising.pyx
	$(PYTHON) setup.py build_ext --inplace

clean:
	rm -rf build core/ising.so core/ising.c core/ising.html 
