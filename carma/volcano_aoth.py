import grads
import numpy as np
import os
from geos5 import *
from utilities import *
import matplotlib.pyplot as plt
from matplotlib.colors import LogNorm

# Baseline gocart aot
sug27 = GEOS5V('bF_F25b27', 'suexttauvolc', ddfpath='./', ddf='bF_F25b27-pin_carma.tavg2d_aer_x.ddf')
sug27.makeGlobalAvg()
sug27.makeZonalAvg()

# Baseline carma aot
suc27 = GEOS5V('bF_F25b27', 'suexttau', ddfpath='./', ddf='bF_F25b27-pin_carma.tavg2d_carma_x.ddf')
suc27.makeGlobalAvg()
suc27.makeZonalAvg()

# Baseline carma aot (carma active)
suc27c = GEOS5V('bFc_F25b27', 'suexttau', ddfpath='./', ddf='bFc_F25b27-pin_carma.tavg2d_carma_x.ddf')
suc27c.makeGlobalAvg()
suc27c.makeZonalAvg()

# Baseline (testvf) carma aot
suc27vf = GEOS5V('bF_F25b27', 'suexttau', ddfpath='./', ddf='bF_F25b27-pin_testvf.tavg2d_carma_x.ddf')
suc27vf.makeGlobalAvg()
suc27vf.makeZonalAvg()

# High-height gocart aot
sug27z = GEOS5V('bF_F25b27', 'suexttauvolc', ddfpath='./', ddf='bF_F25b27-pin_alt16_25.tavg2d_aer_x.ddf')
sug27z.makeGlobalAvg()
sug27z.makeZonalAvg()

# High-height carma aot
suc27z = GEOS5V('bF_F25b27', 'suexttau', ddfpath='./', ddf='bF_F25b27-pin_alt16_25.tavg2d_carma_x.ddf')
suc27z.makeGlobalAvg()
suc27z.makeZonalAvg()

# High-height carma aot (carma active)
suc27zc = GEOS5V('bFc_F25b27', 'suexttau', ddfpath='./', ddf='bFc_F25b27-pin_alt16_25.tavg2d_carma_x.ddf')
suc27zc.makeGlobalAvg()
suc27zc.makeZonalAvg()

plt.contourf(suc27.getZonalAvg(),[0.001,0.002,0.005,0.01,0.02,0.05,0.1,0.2,0.5],
             cmap=plt.cm.jet,norm=LogNorm())
plt.colorbar()
CS = plt.contour(sug27.getZonalAvg(),[0.001,0.002,0.005,0.01,0.02,0.05,0.1,0.2,0.5],
                 colors='k',linewidth=4)
plt.clabel(CS, inline=1, fontsize=14)
plt.savefig('volcano_aoth.baseline.png')



plt.clf()
plt.contourf(suc27z.getZonalAvg(),[0.001,0.002,0.005,0.01,0.02,0.05,0.1,0.2,0.5],
             cmap=plt.cm.jet,norm=LogNorm())
plt.colorbar()
CS = plt.contour(sug27z.getZonalAvg(),[0.001,0.002,0.005,0.01,0.02,0.05,0.1,0.2,0.5],
                 colors='k',linewidth=4)
plt.clabel(CS, inline=1, fontsize=14)
plt.savefig('volcano_aoth.higheight.png')


plt.clf()
plt.contourf(suc27c.getZonalAvg(),[0.001,0.002,0.005,0.01,0.02,0.05,0.1,0.2,0.5],
             cmap=plt.cm.jet,norm=LogNorm())
plt.colorbar()
plt.savefig('volcano_aoth.baseline_c.png')

plt.clf()
plt.contourf(suc27zc.getZonalAvg(),[0.001,0.002,0.005,0.01,0.02,0.05,0.1,0.2,0.5],
             cmap=plt.cm.jet,norm=LogNorm())
plt.colorbar()
plt.savefig('volcano_aoth.highheight_c.png')
