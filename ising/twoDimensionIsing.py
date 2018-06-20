# Driver file, for Ising simulations
#
#

from __future__ import division
import numpy as np
import ising
import matplotlib.pyplot as plt

N, NP       = 16, 512
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


## plot the energy and Magnetization
f = plt.figure(figsize=(18, 10), dpi=80, linewidth=3, facecolor='w', edgecolor='k');    

sp =  f.add_subplot(2, 2, 1 );
plt.plot(Temperature, Energy, 'o', color="#A60628", label=' Energy');
plt.xlabel("Temperature (T)", fontsize=20);
plt.ylabel("Energy ", fontsize=20);

sp =  f.add_subplot(2, 2, 2 );
plt.plot(Temperature, abs(Magnetization), '*', color="#348ABD", label='Magnetization');
plt.xlabel("Temperature (T)", fontsize=20);
plt.ylabel("Magnetization ", fontsize=20);


sp =  f.add_subplot(2, 2, 3 );
plt.plot(Temperature, SpecificHeat, 'd', color='black', label='Specific Heat');
plt.xlabel("Temperature (T)", fontsize=20);
plt.ylabel("Specific Heat ", fontsize=20);


sp =  f.add_subplot(2, 2, 4 );
plt.plot(Temperature, Suseptibility, 's', label='Specific Heat');
#plt.legend(loc='best', fontsize=15); 
plt.xlabel("Temperature (T)", fontsize=20);
plt.ylabel("Suseptibility", fontsize=20);


plt.show()
