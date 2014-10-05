main=ising

all: $(main)

CFLAGS= mt19937ar.c -lm 

run:
	./$(main)

clean:
	rm -f $(main)

plot:
	gnuplot densityPlot.gnu
