import grads
import numpy as np
import os
from geos5 import *
from utilities import *
import matplotlib.pyplot as plt
from matplotlib.colors import LogNorm

# Baseline gocart aot
sug27 = GEOS5V('bF_F25b27', 'suangstrvolc', ddfpath='./', ddf='bF_F25b27-pin_carma.tavg2d_aer_x.ddf')
sug27.makeGlobalAvg()
sug27.makeZonalAvg()

# Baseline carma aot
suc27 = GEOS5V('bF_F25b27', 'suangstr', ddfpath='./', ddf='bF_F25b27-pin_carma.tavg2d_carma_x.ddf')
suc27.makeGlobalAvg()
suc27.makeZonalAvg()

# Baseline (testvf) carma aot
suc27vf = GEOS5V('bF_F25b27', 'suangstr', ddfpath='./', ddf='bF_F25b27-pin_testvf.tavg2d_carma_x.ddf')
suc27vf.makeGlobalAvg()
suc27vf.makeZonalAvg()

# Baseline carma aot (carma active)
suc27c = GEOS5V('bFc_F25b27', 'suangstr', ddfpath='./', ddf='bFc_F25b27-pin_carma.tavg2d_carma_x.ddf')
suc27c.makeGlobalAvg()
suc27c.makeZonalAvg()

# High-height gocart aot
sug27z = GEOS5V('bF_F25b27', 'suangstrvolc', ddfpath='./', ddf='bF_F25b27-pin_alt16_25.tavg2d_aer_x.ddf')
sug27z.makeGlobalAvg()
sug27z.makeZonalAvg()

# High-height carma aot
suc27z = GEOS5V('bF_F25b27', 'suangstr', ddfpath='./', ddf='bF_F25b27-pin_alt16_25.tavg2d_carma_x.ddf')
suc27z.makeGlobalAvg()
suc27z.makeZonalAvg()

# High-height carma aot (carma active)
suc27zc = GEOS5V('bFc_F25b27', 'suangstr', ddfpath='./', ddf='bFc_F25b27-pin_alt16_25.tavg2d_carma_x.ddf')
suc27zc.makeGlobalAvg()
suc27zc.makeZonalAvg()


plt.plot(sug27.getGlobalAvg(),'k',linewidth=4)
plt.plot(suc27.getGlobalAvg(),'r',linewidth=4)
plt.plot(suc27vf.getGlobalAvg(),'g',linewidth=4)
plt.plot(sug27z.getGlobalAvg(),'k--',linewidth=8)
plt.plot(suc27z.getGlobalAvg(),'r--',linewidth=8)
plt.plot(suc27c.getGlobalAvg(),'b',linewidth=4)
plt.plot(suc27zc.getGlobalAvg(),'b--',linewidth=8)
#plt.ylim(-0.2,1.2)
plt.xlabel('Month')
plt.ylabel('Angstrom Parameter')
#plt.show()
plt.savefig('volcano_angstrom.png')
