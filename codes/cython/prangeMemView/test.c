#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <omp.h>

#define LOOPS		1000
#define N 			1000


int i, j;
double calcTime(void)
{
    struct timeval tim;
    gettimeofday(&tim, NULL);
    return tim.tv_sec + (1e-6)*tim.tv_usec;
}

int func(int nthreads)
{
    omp_set_num_threads(nthreads);
    double ti[N], tj[N], F[N];
    for (i = 0; i < N; i++)
    {
    	ti[i] 	= i;
    	tj[i] 	= i * i;
    	F[i]	= 0;
    }
    
    double start = calcTime();
    
    for (j = 0; j < LOOPS; j++) {
    	#pragma omp parallel for
    	for (i = 0; i < N; i++) {
    		F[i] = ti[i] + tj[i];
    	}
    }
    
    double end = calcTime();
    printf("%d threads takes %e seconds\n", omp_get_max_threads(), end - start);
}



int main()
{
    int i;
    for (i = 0; i < 4; i++) {
        func(i);
    }
}
