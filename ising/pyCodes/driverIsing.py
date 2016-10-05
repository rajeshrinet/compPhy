# Driver file, for Ising simulations
#
#


import numpy as np
import ising
import matplotlib.pyplot as plt

Nsites, Npoints = 64, 128
Spin = np.zeros(Npoints, dtype=np.dtype("i"))
Energy        = np.zeros(Npoints)
Magnetization = np.zeros(Npoints)
Suseptibility = np.zeros(Npoints)
SpecificHeat  = np.zeros(Npoints)
eqSteps, mcSteps = 1000, 1000

Beta = np.linspace(0.2, 4, Npoints)


#instantiate the class Ising model
Ising = ising.Ising(Nsites, Npoints, eqSteps, mcSteps)



Ising.oneD(Spin, Energy, Magnetization, SpecificHeat, Suseptibility, Beta)  


# plot the energy and Magnetization
f = plt.figure(figsize=(18, 10), dpi=80, facecolor='w', edgecolor='k');    

sp =  f.add_subplot(2, 2, 1 );
plt.plot(Beta, Energy, 'o', color="#A60628", label=' Energy');
plt.xlabel("Beta (T)", fontsize=20);
plt.ylabel("Energy ", fontsize=20);

sp =  f.add_subplot(2, 2, 2 );
plt.plot(Beta, abs(Magnetization), '*', label='Magnetization');
plt.xlabel("Beta (T)", fontsize=20);
plt.ylabel("Magnetization ", fontsize=20);


sp =  f.add_subplot(2, 2, 3 );
plt.plot(Beta, SpecificHeat, '*', label='Specific Heat');
plt.xlabel("Beta (T)", fontsize=20);
plt.ylabel("Specific Heat ", fontsize=20);


sp =  f.add_subplot(2, 2, 4 );
plt.plot(Beta, Suseptibility, '*', label='Specific Heat');
#plt.legend(loc='best', fontsize=15); 
plt.xlabel("Beta (T)", fontsize=20);
plt.ylabel("Suseptibility", fontsize=20);


plt.show()
