import grads
import numpy as np
import os
from geos5 import *
from utilities import *
import matplotlib.pyplot as plt
from matplotlib.colors import LogNorm

# Baseline gocart aot
sug27 = GEOS5V('bF_F25b27', 'suwt003volc',
               expr='susv003volc+susd003volc+suwt003volc+sudp003volc',
               expr_name='suwt003volc', ddfpath='./', ddf='bF_F25b27-pin_carma.tavg2d_aer_x.ddf')
sug27.makeGlobalAvg()
sug27.makeZonalAvg()

# Baseline carma aot
suc27 = GEOS5V('bF_F25b27', 'suwt',
               expr='suwt+sudp+susd+susv',
               expr_name='suwt', ddfpath='./', ddf='bF_F25b27-pin_carma.tavg2d_carma_x.ddf')
suc27.makeGlobalAvg()
suc27.makeZonalAvg()

# Baseline (testvf) carma aot
suc27vf = GEOS5V('bF_F25b27', 'suwt',
               expr='suwt+sudp+susd+susv',
               expr_name='suwt', ddfpath='./', ddf='bF_F25b27-pin_testvf.tavg2d_carma_x.ddf')
suc27vf.makeGlobalAvg()
suc27vf.makeZonalAvg()

# Baseline carma aot (carma active)
suc27c = GEOS5V('bFc_F25b27', 'suwt',
               expr='suwt+sudp+susd+susv',
               expr_name='suwt', ddfpath='./', ddf='bFc_F25b27-pin_carma.tavg2d_carma_x.ddf')
suc27c.makeGlobalAvg()
suc27c.makeZonalAvg()

# High-height gocart aot
sug27z = GEOS5V('bF_F25b27', 'suwt003volc',
               expr='susv003volc+susd003volc+suwt003volc+sudp003volc',
               expr_name='suwt003volc', ddfpath='./', ddf='bF_F25b27-pin_alt16_25.tavg2d_aer_x.ddf')
sug27z.makeGlobalAvg()
sug27z.makeZonalAvg()

# High-height carma aot
suc27z = GEOS5V('bF_F25b27', 'suwt',
               expr='suwt+sudp+susd+susv',
               expr_name='suwt', ddfpath='./', ddf='bF_F25b27-pin_alt16_25.tavg2d_carma_x.ddf')
suc27z.makeGlobalAvg()
suc27z.makeZonalAvg()

# High-height carma aot (carma active)
suc27zc = GEOS5V('bFc_F25b27', 'suwt',
               expr='suwt+sudp+susd+susv',
               expr_name='suwt', ddfpath='./', ddf='bFc_F25b27-pin_alt16_25.tavg2d_carma_x.ddf')
suc27zc.makeGlobalAvg()
suc27zc.makeZonalAvg()


plt.plot(sug27.getGlobalAvg()*5.1e5*30*86400,'k',linewidth=4)
plt.plot(suc27.getGlobalAvg()*5.1e5*30*86400,'r',linewidth=4)
plt.plot(suc27vf.getGlobalAvg()*5.1e5*30*86400,'g',linewidth=4)
plt.plot(sug27z.getGlobalAvg()*5.1e5*30*86400,'k--',linewidth=8)
plt.plot(suc27z.getGlobalAvg()*5.1e5*30*86400,'r--',linewidth=8)
plt.plot(suc27c.getGlobalAvg()*5.1e5*30*86400,'b',linewidth=4)
plt.plot(suc27zc.getGlobalAvg()*5.1e5*30*86400,'b--',linewidth=8)
plt.xlabel('Month')
plt.ylabel('Sulfate Loss [Tg]')
#plt.show()
plt.savefig('volcano_loss.png')
