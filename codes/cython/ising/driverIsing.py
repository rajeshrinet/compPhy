# Driver file, for Ising simulations
#
#


import numpy as np
import ising
import matplotlib.pyplot as plt

Nsites, Npoints = 32, 32
Spin = np.zeros(Npoints, dtype=np.dtype("i"))
Beta = np.zeros(Npoints)
Energy        = np.zeros(Npoints)
Magnetisation = np.zeros(Npoints)
SpecificHeat  = np.zeros(Npoints)
eqSteps, mcSteps = 10000, 10000

#Beta = np.array(([0.25,0.50,0.75,1.0,2.0,4.0,8.0]));	
Beta = np.linspace(0.2, 4, 32)


#instantiate the class Ising model
Ising = ising.Ising(Nsites, Npoints, eqSteps, mcSteps)



Ising.oneD(Spin, Energy, Magnetisation, SpecificHeat, Beta)  


#Plotting business
f = plt.figure(num=None, figsize=(18, 6), dpi=80, facecolor='w', edgecolor='k')
f.add_subplot(1, 3, 1)
plt.plot(Beta, Energy, 'o', color="#348ABD", linewidth=2, linestyle="-", label='Energy')
plt.xlabel('Beta',fontsize=16)
plt.legend(loc="upper left")
plt.ylim([-1.2, 0])

f.add_subplot(1, 3, 2)
plt.plot(Beta, np.abs(Magnetisation), 'o', color="#A60628", linewidth= 3, linestyle="", label='Magnetization')
plt.xlabel('Beta',fontsize=16)
plt.ylim([-0, 1.2])
plt.legend(loc="upper left")
f.add_subplot(1, 3, 3)
plt.plot(Beta, SpecificHeat, 'o', color="#A60628", linewidth= 3, linestyle="", label='SpecificHeat')
plt.xlabel('Beta',fontsize=16)
plt.legend(loc="upper left")

#show the plot
plt.show()

