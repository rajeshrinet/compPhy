## simulating the Ising model

In the codes we simulate the Ising model in different dimension using the Metropolis algorithm.

##One dimension

There is no phase transition in one dimension for a equilibrium system. But our code show a 
phase transition. This is because the Metropolis algorithm is not very accurate near T=0. This 
is because the weight $e^{-E/T}$ , where we have set the Boltzmann constant to be one.
is very small and hence the spin are aligned in parallel with a 
priority and hence we see an ordered state at lower temperatures once we simulate the Ising model 
using the Metropolis algorithm.



##Two dimension
