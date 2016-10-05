
PYTHON = ~/software/anaconda/bin/python # -m cProfile -s cumulative 

all: test.so

test.so: test.pyx
	$(PYTHON) setup.py build_ext --inplace

Force.so: Force.pyx
	$(PYTHON) setup.py build_ext --inplace

clean:
	rm -rf build test.so test.c test.html 
