PYTHON = ~/software/anaconda/bin/python

all: test.so 


test.so: test.pyx
	$(PYTHON) setup.py build_ext --inplace

clean:
	rm -rf build test.so test.c test.html 
