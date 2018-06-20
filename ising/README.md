## Simulating the Ising model

Here we simulate the Ising model in one and two dimensions using the Metropolis algorithm.

* oneDimensionIsing.py: simulates one-dimensional Ising model 
* twoDimensionIsing.py: simulates the two-dimensional Ising model
* finiteSize.py: finite size scaling for 2D Ising model

The main steps of Metropolis algorithm are:

1. Prepare an initial configuration of N spins
2. Flip the spin of a randomly chosen lattice site. 
3. Calculate the change in energy dE. 
4. If dE < 0, accept the move. Otherwise accept the move with probability exp^{-dE/T}. This satisfies the detailed balance condition, ensuring a final equilibrium state. 
5. Repeat 2-4.

A small trick can be done to optimally calculate the dE in 2D. Lets assume that spin S[i, j]  is flipped, then only the nearest neighbor spins  will account for a change in energy. There are two ways to calculate dE:
  
* First way is the simplest- take the exponential of the change in energy. Remember calculating the exponential N^2 times for each Monte Carlo move can get expensive!
* The second way is the least expensive in terms of computation time. Here you use the fact that spin can take values 1 and -1, and hence, there are only two possibilities for an energy increasing move. They are

```
  d         d           u         u    
d d d =>  d u d  or   u u u =>  u d u   #change in energy is 8
  d         d           u         u   



  d         d           u         u    
d d u =>  d u u  or   u u d =>  u d d   #change in energy is 4
  d         d           u         u 
```
Here u and d, respectively, denote the up and down configuration of the spins, which correspond to value 1 and -1. 


Read more [here](http://rajeshrinet.github.io/blog/2014/ising-model/).


**Note**: There is no phase transition in one dimension for an equilibrium system. But our code show a phase transition. This is because the Metropolis algorithm is not very accurate near T=0. This can be understood as follows. If T is very small then the probability to accept the move which does not favor ordered state is very low, i.e., exp^{-dE/T} ~ 0. So, for all practical purposes, the probability to accept the moves which increases the energy goes to zero.  So this spurious behaviour, observed in simulation, in 1D is an artifact of the algorithm.

