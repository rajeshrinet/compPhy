# Driver file, for finite size scaling
#
#

from __future__ import division
import numpy as np
import ising
import matplotlib.pyplot as plt
f = plt.figure(figsize=(18, 10), dpi=80, linewidth=3, facecolor='w', edgecolor='k');    
for i in range(4):
    N, NP       = (i+1)*2**2, 256
    eqSteps, mcSteps = 8000, 8000


    Temperature   = np.zeros((NP), dtype=np.float64)
    Energy        = np.zeros((NP), dtype=np.float64)
    Magnetization = np.zeros((NP), dtype=np.float64)
    SpecificHeat  = np.zeros((NP), dtype=np.float64)
    Suseptibility = np.zeros((NP), dtype=np.float64)
    Spin          = np.zeros((N+2,N+2), dtype=np.int32  )

    #Temperature
    Temperature = np.linspace(1.0, 4, NP)
    Beta = 1.0/Temperature   # set k_B = 1

    #instantiate the class Ising model
    Ising = ising.Ising(N, NP, eqSteps, mcSteps)

    Ising.twoD(Spin, Energy, Magnetization, SpecificHeat, Suseptibility, Beta)

    #sp =  f.add_subplot(2, 2, (i+1) ); 
    ## Finite size scaling of suseptibility: chi(L) = chi*L^(-\gamma/nu)
    plt.plot(Temperature, Suseptibility*N**(-7.0/4.0), 's', label='N=%s'%N);
    plt.legend(loc='best', fontsize=15); 
    plt.xlabel("Temperature (T)", fontsize=20);
    plt.ylabel("Suseptibility", fontsize=20);


plt.show()
