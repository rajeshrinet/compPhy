# Driver file, for Ising simulations
#
#


import numpy as np
import ising
import matplotlib.pyplot as plt

Nsites, Npoints = 64, 32
Beta = np.zeros(Npoints)
Energy        = np.zeros(Npoints)
Magnetisation = np.zeros(Npoints)
SpecificHeat  = np.zeros(Npoints)

#Beta = np.array(([0.25,0.50,0.75,1.0,2.0,4.0,8.0]));	
Beta = np.linspace(0.01, 4.5, 32)


#instantiate the class Ising model
Ising = ising.Ising(1)

N, Nt  = 10, 128
eqm, msrmnt = 1000, 10000
Tot_E = np.zeros(Nt)
Tot_M = np.zeros(Nt)
config = np.zeros((N, N), dtype=np.dtype("i"))

temp  = np.linspace(0.01, 10, Nt)        #np.array([0.25, 0.11, 2, 4, 8, 10])


Ising.twoD(N, Nt, eqm, msrmnt, config, Tot_E, Tot_M, temp)

# plot the energy and magnetisation
f = plt.figure(figsize=(18, 5), dpi=80, facecolor='w', edgecolor='k');    

sp =  f.add_subplot(1, 2, 1 );
plt.plot(temp, Tot_E, 'o', color="#A60628", label=' Energy (E)');
plt.legend(loc='lower right', fontsize=15); 
plt.xlabel("Temperature (T)", fontsize=20);

sp =  f.add_subplot(1, 2, 2 );
plt.plot(temp, Tot_M, '*', label='Magnetisation (m)');
plt.legend(loc='lower right', fontsize=15); 
plt.xlabel("Temperature (T)", fontsize=20);
plt.show()
