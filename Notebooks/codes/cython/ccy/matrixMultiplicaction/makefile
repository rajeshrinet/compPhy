
PYTHON = ~/software/anaconda/bin/python

all: matMul.so

matMul.so: matMul.pyx
	$(PYTHON) setup.py build_ext --inplace

clean:
	rm -rf build matMul.so matMul.c matMul.html 
