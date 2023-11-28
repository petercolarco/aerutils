import grads
import numpy as np
import os
from geos5 import *
from utilities import *
import matplotlib.pyplot as plt

suc27 = GEOS5V('bF_F25b27', 'suexttau', ddfpath='./', ddf='bF_F25b27-pin_carma.tavg2d_carma_x.ddf')
suc27.makeGlobalAvg()

#plt.plot(suc27.getGlobalAvg())
#plt.show()

suc27.makeZonalAvg()
plt.contourf(suc27.getZonalAvg())
plt.colorbar()
plt.show()
