from geos5 import *
from utilities import *
import os
import matplotlib.pyplot as plt

path  = '/discover/nobackup/crandles/'
expid = 'bR_MERRAero_1'
coll1 = 'tavg3_2d_rad_x'
coll2 = 'tavg6_3d_cld_p'
ddf   = 'xdf.tabl'
http  = 'http://opendap.nccs.nasa.gov:9090/dods/GEOS-5/fp/0.25_deg/assim/inst1_2d_hwl_Nx'
httpv = 'totexttau'

## Test 1: 2-d Test: Provide ddf and ddfpath
print '******************TEST 1**********'
swtnet = GEOS5V(expid, 'swtnet', ddf=ddf, ddfpath=path+expid+'/'+coll1+'/')
swtnet.makeGlobalAvg()
swtnet.makeZonalAvg()

plt.figure(1)
plt.subplot(211)
plt.title(swtnet.getVar()+' Global Average')
plt.ylabel(r' [W m$^{-2}$]')  ## r before a string lets you use LaTeX in the string
plt.xlim((1,swtnet.getNt()))
plt.plot(range(1,swtnet.getNt()+1),swtnet.getGlobalAvg())
plt.subplot(212)
plt.title(swtnet.getVar()+ ' Zonal Average')
plt.xlabel('Month')
plt.ylabel(r' [W m$^{-2}$]')
plt.xlim((1,swtnet.getNt()))
plt.contourf(range(1,swtnet.getNt()+1), swtnet.getLat(), swtnet.getZonalAvg())
plt.colorbar()
plt.show()
##
## TEST 2: 2-d Test: Provide ddf and path; evaluate an expression in grads
##print '******************TEST 2**********'
swtoa = GEOS5V(expid, 'swtnet', expr='swtnet-swtnetna', expr_name='swtoa',
                ddf=ddf, ddfpath=path+expid+'/'+coll1+'/') ## expr must be a valid GrADS expression!!!
swtoa.makeGlobalAvg(physical=False)
swtoa.makeZonalAvg(physical=False)

plt.figure(2)
plt.subplot(211)
plt.title(swtoa.getExpr()+' Global Average')
plt.ylabel(r' [W m$^{-2}$]')
plt.xlim((1,swtnet.getNt()))
plt.plot(range(1,swtoa.getNt()+1),swtoa.getGlobalAvg())
plt.subplot(212)
plt.title(swtoa.getExprName()+ ' Zonal Average')
plt.xlabel('Month')
plt.ylabel(r' [W m$^{-2}$]')
plt.xlim((1,swtnet.getNt()))
plt.contourf(range(1,swtoa.getNt()+1), swtoa.getLat(), swtoa.getZonalAvg())
plt.colorbar()
plt.show()

## TEST 3: 2-d Test:  Make a ddf in current directory (add ddfpath to put elsewhere)
##print '******************TEST 3**********'
swtnet2 = GEOS5V(expid, 'swtnet', path=path, coll=coll1, numfiles=12) ## variable name can be all lower or all uppercase
swtnet2.makeDDF('monthly', '2009', template=False) ## year can be a number or a string; my files not in Y%y4/M%m2 so template is False
swtnet2.gagetVar()
swtnet2.makeGlobalAvg()
swtnet2.makeZonalAvg()

plt.figure(3)
plt.subplot(211)
plt.title(swtnet2.getVar()+' Global Average')
plt.ylabel(r' [W m$^{-2}$]')
plt.xlim((1,swtnet2.getNt()))
plt.plot(range(1,swtnet2.getNt()+1),swtnet2.getGlobalAvg())
plt.subplot(212)
plt.title(swtnet2.getVar()+ ' Zonal Average')
plt.xlabel('Month')
plt.ylabel(r' [W m$^{-2}$]')
plt.xlim((1,swtnet2.getNt()))
plt.contourf(range(1,swtnet2.getNt()+1), swtnet2.getLat(), swtnet2.getZonalAvg())
plt.colorbar()
plt.show()

## TEST 4: 2-d Test:  Open a single netCDF file
##print '******************TEST 4**********'
swtnet3 = GEOS5V(expid, 'swtnet',
                ddf='bR_MERRAero_1.tavg3_2d_rad_x.monthly.clim.SON.nc4',
                ddfpath=path+'/'+expid+'/'+coll1+'/') ## When you only want one file, indicate it as a ddf file and path
swtnet3.gagetVar()
swtnet3.makeGlobalAvg()
swtnet3.makeZonalAvg()

print 'Global Avg. '+swtnet3.getVar()+': '+str(swtnet3.getGlobalAvg())
plt.figure(4)
plt.title(swtnet3.getVar()+' Zonal Average')
plt.ylabel('Latitude')
plt.ylim((-90,90))
plt.xlabel(r' [W m$^{-2}$]')
plt.plot(swtnet3.getZonalAvg(), swtnet3.getLat())
plt.show()

## TEST 5: 2-d Test: Open a OpenDap file; just get the first time
##print '******************TEST 5**********'
totexttau = GEOS5V('assim', httpv, ddf=http, ts = (1, 36)) ## Here expid can be whatever. Needs URL. If large file, specify time 1 and 2 with ts
totexttau.gagetVar()
totexttau.makeZonalAvg()
totexttau.makeGlobalAvg()


plt.figure(5)
plt.subplot(211)
plt.title(httpv+' Global Avg')
plt.ylabel('AOD')
plt.xlim((1,totexttau.getNt()))
plt.plot(range(totexttau.getNt()), totexttau.getGlobalAvg())
plt.subplot(212)
plt.title(httpv+' ZonalAvg')
plt.xlabel('Month')
plt.ylabel('Latitude')
plt.contourf(range(totexttau.getNt()), totexttau.getLat(), totexttau.getZonalAvg())
plt.colorbar()
plt.show()

## TEST 6: 3-d Test with given ddf file
##print '******************TEST 6**********'
cloud = GEOS5V(expid, 'cloud', ddf=ddf, ddfpath=path+expid+'/'+coll2+'/')
cloud.makeGlobalAvg()
cloud.makeZonalAvg()

plt.figure(6)
plt.subplot(211)
plt.ylim((cloud.getLev()[0], cloud.getLev()[-1]))
plt.title('Global Avg. Cloud Amount')
plt.ylabel('hPa')
plt.contourf(range(0,cloud.getNt()),cloud.getLev(), cloud.getGlobalAvg())
plt.subplot(212)
plt.title('Zonal Avg. Cloud Amount 550 mb')
plt.xlabel('Month')
plt.ylabel('[%]')
## numpy squeeze removes singleton dimensions.  numpy where finds the index
plt.contourf(range(0,cloud.getNt()),cloud.getLat(), np.squeeze(cloud.getZonalAvg()[:, np.where(cloud.getLev() == 550)[0],:]))
plt.colorbar()
plt.show()

## Test 7:  3-d Test making a ddf file
##print '******************TEST 7**********'
cloud = GEOS5V(expid, 'cloud', path=path, coll=coll2, numfiles=12)
cloud.makeDDF('monthly', 2009, template=False) ## My files are not in Y%y4/M%m4 subdirectories, so template=False
cloud.gagetVar()
cloud.makeGlobalAvg()
cloud.makeZonalAvg()

plt.figure(7)
plt.subplot(211)
plt.ylim((cloud.getLev()[0], cloud.getLev()[-1]))
plt.title('Global Avg. Cloud Amount')
plt.ylabel('hPa')
plt.contourf(range(0,cloud.getNt()),cloud.getLev(), cloud.getGlobalAvg())
plt.subplot(212)
plt.title('Zonal Avg. Cloud Amount 550 mb')
plt.xlabel('Month')
plt.ylabel('[%]')
plt.contourf(range(0,cloud.getNt()),cloud.getLat(), np.squeeze(cloud.getZonalAvg()[:, np.where(cloud.getLev() == 550)[0],:]))
plt.colorbar()
plt.show()

## Test 8: Making various ddf files
print '******************TEST 8**********'
cloud = GEOS5V(expid, 'cloud', path=path, coll=coll2, numfiles=1)
cloud.makeDDF('monthly', 2009, clim=True, template=False) ## These are climtology files so clim=True
cloud.makeDDF('monthly', 2009, clim=True, sea='SON', template=False, resetDDF=True) ## Clim files for a particular seaon
cloud2 = GEOS5V(expid, 'cloud', path=path, coll=coll2, numfiles=1)
cloud2.makeDDF('diurnal', 2009, clim=True, sea='ANN', template=False, nts=4, tymefreq=4) ## 4 time steps per file so tymefreq=4, assumes in /diurnal/ subdir unles diurnalpath=False
cloud2.gagetVar()
