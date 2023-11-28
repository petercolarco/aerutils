import grads
import numpy as np
import os
from geos5 import *
from utilities import *
import matplotlib.pyplot as plt
from matplotlib.colors import LogNorm

#suc27 = GEOS5V('bF_F25b27', 'suexttau', ddfpath='./', ddf='bF_F25b27-pin_alt16_25.tavg2d_carma_x.ddf')
#suc27.makeGlobalAvg()
#suc27.makeZonalAvg()


#suc27z = GEOS5V('bFc_F25b27', 'suexttau', ddfpath='./', ddf='bFc_F25b27-pin_alt16_25.tavg2d_carma_x.ddf')
#suc27z.makeGlobalAvg(physical=True)
#suc27z.makeZonalAvg(physical=True)

# Global AOT average
#plt.plot(suc27.getGlobalAvg(),'r',linewidth=4)
#plt.plot(suc27z.getGlobalAvg(),'r--',linewidth=4)
#plt.show()

#Angstrom
sug27a = GEOS5V('bF_F25b27', 'suangstrvolc', ddfpath='./', ddf='bF_F25b27-pin_alt16_25.tavg2d_aer_x.ddf')
sug27a.makeGlobalAvg()
sug27a.makeZonalAvg()

suc27a = GEOS5V('bF_F25b27', 'suangstr', ddfpath='./', ddf='bF_F25b27-pin_alt16_25.tavg2d_carma_x.ddf')
suc27a.makeGlobalAvg()
suc27a.makeZonalAvg()


suc27za = GEOS5V('bFc_F25b27', 'suangstr', ddfpath='./', ddf='bFc_F25b27-pin_alt16_25.tavg2d_carma_x.ddf')
suc27za.makeGlobalAvg()
suc27za.makeZonalAvg()

# Global Angstrom average
plt.plot(sug27a.getGlobalAvg(),'k',linewidth=4)
plt.plot(suc27a.getGlobalAvg(),'r',linewidth=4)
plt.plot(suc27za.getGlobalAvg(),'r--',linewidth=8)
#plt.show()
plt.savefig('carma_angstrom.png')

#Hovmuller -- AOT
plt.contourf(suc27.getZonalAvg(),[0.001,0.002,0.005,0.01,0.02,0.05,0.1,0.2,0.5],
             cmap=plt.cm.jet,norm=LogNorm())
plt.colorbar()
CS = plt.contour(suc27z.getZonalAvg(),[0.001,0.002,0.005,0.01,0.02,0.05,0.1,0.2,0.5],
                 colors='k',linewidth=4)
plt.clabel(CS, inline=1, fontsize=14)
plt.show()


#Hovmuller -- Angstrom
plt.contourf(suc27a.getZonalAvg(),cmap=plt.cm.jet)
plt.colorbar()
CS = plt.contour(suc27za.getZonalAvg(), colors='k',linewidth=4)
plt.clabel(CS, inline=1, fontsize=14)
plt.show()



su27 = GEOS5V('bF_F25b27-pin_carma', 'SU', path='/Volumes/bender/prc14/',
              coll='tavg3d_carma_p',numfiles=1)
su27.makeDDF('monthly',1991,mo='oct',nts=1)
su27.gagetVar()
su27.makeZonalAvg()

su27z = GEOS5V('bF_F25b27-pin_alt16_25', 'SU', path='/Volumes/bender/prc14/',
               coll='tavg3d_carma_p',numfiles=1)
su27z.makeDDF('monthly',1991,mo='oct',nts=1,resetDDF=True)
su27z.gagetVar()
su27z.makeZonalAvg()

su27gz = GEOS5V('bF_F25b27-pin_alt16_25', 'SO4v', path='/Volumes/bender/prc14/',
               coll='tavg3d_carma_p',numfiles=1)
su27gz.makeDDF('monthly',1991,mo='oct',nts=1,resetDDF=True)
su27gz.gagetVar()
su27gz.makeZonalAvg()

plt.contourf(su27.lat,su27.lev,np.transpose(su27.getZonalAvg())*1e7,
             [0.01,0.02,0.05,0.1,0.2,0.5,1,2,3],cmap=plt.cm.jet,norm=LogNorm())
plt.colorbar()
plt.ylim(500,1)
plt.yscale('log')
CS = plt.contour(su27z.lat,su27z.lev,np.transpose(su27z.getZonalAvg())*1e7,
                 [0.01,0.02,0.05,0.1,0.2,0.5,1,2,3],colors='k',linewidth=8)
plt.clabel(CS, inline=1, fontsize=14)
CS = plt.contour(su27gz.lat,su27gz.lev,np.transpose(su27gz.getZonalAvg())*1e7,
                 [0.01,0.02,0.05,0.1,0.2,0.5,1,2,3],colors='r',linewidth=8)

plt.clabel(CS, inline=1, fontsize=14)
plt.show()
dir(plt)
##dir(plt)
##help(plt.ylim)
