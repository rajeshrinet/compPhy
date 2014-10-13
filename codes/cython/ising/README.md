## Simulating the Ising model

In the codes we simulate the Ising model in different dimension using the Metropolis algorithm.


Metropolis algorithm.

1. Prepare an initial  configuration of N spins
2. Flip the spin of a randomly chosen lattice site. 
3. Calculate the change in energy dE.
4. If dE<0, accept the move. Otherwise accept the move with probability e^{-dE/T}. This satisifies the 
detailed balance condition, ensuring a final equilibrium state. 
5. Repeat 2-4.

##One dimension

There is no phase transition in one dimension for an equilibrium system. But our code show a 
phase transition. This is because the Metropolis algorithm is not very accurate near T=0. 

But if T is very small then the probability to accept the move which does not favor ordered state is very low. So this is more an artifact of the algorithm than that of the concerned system. So, for all practical purposed the probability to accept the moves which increases the energy goes to zero. And hence we see a phase transition kind of effect for 1D Ising systems.   




##Two dimension
