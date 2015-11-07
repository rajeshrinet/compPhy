# Driver file, for Ising simulations
#
#

from __future__ import division
import numpy as np
import ising
import matplotlib.pyplot as plt

N, nPoints       = 32, 100
eqSteps, mcSteps = 1000, 1000


Energy        = np.zeros((nPoints), dtype=np.float64)
Magnetization = np.zeros((nPoints), dtype=np.float64)
SpecificHeat  = np.zeros((nPoints), dtype=np.float64)
Suseptibility = np.zeros((nPoints), dtype=np.float64)
Spin          = np.zeros((N+2,N+2), dtype=np.int32  )

Beta  = np.linspace(0.2, 1, nPoints)        #np.array([0.25, 0.11, 2, 4, 8, 10])
Temperature = 1.0/Beta

#instantiate the class Ising model
Ising = ising.Ising(N, nPoints, eqSteps, mcSteps)

Ising.twoD(Spin, Energy, Magnetization, SpecificHeat, Suseptibility, Beta)


## plot the energy and Magnetization
f = plt.figure(figsize=(18, 10), dpi=80, linewidth=3, facecolor='w', edgecolor='k');    

sp =  f.add_subplot(2, 2, 1 );
plt.plot(Temperature, Energy, color="#A60628", label=' Energy');
plt.xlabel("Temperature (T)", fontsize=20);
plt.ylabel("Energy ", fontsize=20);

sp =  f.add_subplot(2, 2, 2 );
plt.plot(Temperature, abs(Magnetization), color="#348ABD", label='Magnetization');
plt.xlabel("Temperature (T)", fontsize=20);
plt.ylabel("Magnetization ", fontsize=20);


sp =  f.add_subplot(2, 2, 3 );
plt.plot(Temperature, SpecificHeat, color='black', label='Specific Heat');
plt.xlabel("Temperature (T)", fontsize=20);
plt.ylabel("Specific Heat ", fontsize=20);


sp =  f.add_subplot(2, 2, 4 );
plt.plot(Temperature, Suseptibility, label='Specific Heat');
#plt.legend(loc='best', fontsize=15); 
plt.xlabel("Temperature (T)", fontsize=20);
plt.ylabel("Suseptibility", fontsize=20);


plt.show()
