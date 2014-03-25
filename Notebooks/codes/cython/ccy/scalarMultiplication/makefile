
PYTHON = ~/software/anaconda/bin/python

all: multiply.so

multiply.so: multiply.pyx
	$(PYTHON) setup.py build_ext --inplace

clean:
	rm -rf build multiply.so multiply.c multiply.html 
