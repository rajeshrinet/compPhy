# Driver file, for Ising simulations
#
#

from __future__ import division
import numpy as np
import ising
import matplotlib.pyplot as plt

N, nPoints       = 8, 100
eqSteps, mcSteps = 2000000, 100000


Energy        = np.zeros(nPoints)
Magnetization = np.zeros(nPoints)
SpecificHeat  = np.zeros(nPoints)
Suseptibility  = np.zeros(nPoints)
Spin = np.zeros((N+2, N+2), dtype=np.dtype("i"))

Temp  = np.linspace(0.2, 5, nPoints)        #np.array([0.25, 0.11, 2, 4, 8, 10])


#instantiate the class Ising model
Ising = ising.Ising(N, nPoints, eqSteps, mcSteps)

Ising.twoD(Spin, Energy, Magnetization, SpecificHeat, Suseptibility, Temp)


## plot the energy and Magnetization
f = plt.figure(figsize=(18, 10), dpi=80, facecolor='w', edgecolor='k');    

sp =  f.add_subplot(2, 2, 1 );
plt.plot(Temp, Energy, 'o', color="#A60628", label=' Energy');
plt.xlabel("Temperature (T)", fontsize=20);
plt.ylabel("Energy ", fontsize=20);

sp =  f.add_subplot(2, 2, 2 );
plt.plot(Temp, abs(Magnetization), '*', label='Magnetization');
plt.xlabel("Temperature (T)", fontsize=20);
plt.ylabel("Magnetization ", fontsize=20);


sp =  f.add_subplot(2, 2, 3 );
plt.plot(Temp, SpecificHeat, '*', label='Specific Heat');
plt.xlabel("Temperature (T)", fontsize=20);
plt.ylabel("Specific Heat ", fontsize=20);


sp =  f.add_subplot(2, 2, 4 );
plt.plot(Temp, Suseptibility, '*', label='Specific Heat');
#plt.legend(loc='best', fontsize=15); 
plt.xlabel("Temperature (T)", fontsize=20);
plt.ylabel("Suseptibility", fontsize=20);


plt.show()
