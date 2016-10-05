## Simulating the Ising model

In the codes we simulate the Ising model in different dimension using the Metropolis algorithm.


Metropolis algorithm.

1. Prepare an initial  configuration of N spins
2. Flip the spin of a randomly chosen lattice site. 
3. Calculate the change in energy dE.
4. If $dE < 0$, accept the move. Otherwise accept the move with probability $e^{-dE/T}$. This satisifies the detailed balance condition, ensuring a final equilibrium state. 
5. Repeat 2-4.

##One dimension

There is no phase transition in one dimension for an equilibrium system. But our code show a 
phase transition. This is because the Metropolis algorithm is not very accurate near T=0. This can be understood as follows

If T is very small then the probability to accept the move which does not favor ordered state is very low, i.e., e^{-dE/T} ~ 0. So, for all practical purposes, the probability to accept the moves which increases the energy goes to zero. 

So this phase transition in 1D is more an artifact of the algorithm than that of the concerned system.  

##Two dimension
A small trick can be done to optimally calculate the \delta E, I will assume that we are working on 2D square lattice. Lets assume that spin S[i, j]  is flipped then only spins that will account for a change in energy is S[i+1, j], S[i-1, j], S[i, j+1], S[i, j-1]. The change in energy is simply 2 * S[i, j] * (S[i+1, j], S[i-1, j], S[i, j+1], S[i, j-1]). There are two ways to go after this
  
a) First way is the simplest, it is implemented here. You take the exponential of the change in energy. Remember calculating the exponential $N^2$ times for each mcmove can get expensive!

b) The second way is the least expensive in terms of computation time. Here you use the fact that spin can take values 1 and -1 and hence the there are very few possibilities for the \delta E to take. Also, there are only two possibilities for an energy increasing move. They are
--------------------------------------------
  d         d               u             u        
d d d =>  d u d  or   u u u =>  u d u   # change in energy is 8
  d         d                u            u 



   d             d               u             u        
d d u =>  d u u  or   u u d =>  u d d   # change in energy is 4
   d             d               u             u 
---------------------------------------------

Read more [here](http://rajeshrinet.github.io/blog/2014/ising-model/).
