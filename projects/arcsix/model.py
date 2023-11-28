# Module of functions to manipulate GEOS/NNR MODIS Level 3 files
import numpy as np
import numpy.ma as ma
import os.path
from netCDF4 import Dataset
import calendar
import copy
import datetime

def channelvar(channel=1):
    return {
        1: 'SUEXTCOEF',
        2: 'SO4',
        3: 'ext675',
        4: 'ext745',
        5: 'ext869',
        6: 'ext997',
        7: 'troph', 
        8: 'scatang'
    }.get(channel,'junk')


# Read channel = channel of tau_ from single file
# Need trap that if not found return NaN
def read1(filename,varn='SUEXTCOEF',z=-1,merra2=-1):
    lonname = 'lon'
    latname = 'lat'
    levname = 'lev'

    if os.path.isfile(filename)==True:
       rc = 0
       with Dataset(filename,'r') as ncid:
           lon = ncid.variables[lonname][:]
           lat = ncid.variables[latname][:]
           ext = np.empty([lat.size,lon.size])
           ext[:]  = np.nan
           if z < 1:
               try:
                   ncid.variables[levname][:]
                   lev = ncid.variables[levname][:]
                   ext = np.squeeze(ncid.variables[varn][:])
               except:
                   lev = 1
                   ext = np.squeeze(ncid.variables[varn][:])
           else:
               lev = ncid.variables[levname][:][z]
               ext = np.squeeze(ncid.variables[varn][:][:,z,:,:])
    else:
        rc = 1
        ext = 1.
        lon = 1.
        lat = 1.
        lev = 1.

    return ext, lon, lat, lev, rc


# Read and form daily average
def readday(yy,mm,dd,varn='SUEXTCOEF',z=-1,
            expid='C90c_HTerupV03a',merra2=-1):
    dir = '/misc/prc18/colarco/'
    filename = dir+expid+"/%s.tavg2d_aer_x.%04d%02d%02d.nc4" %(expid,yy,mm,dd)
    if(merra2 > 0):
        dir = '/misc/prc13/MERRA2/d5124_m2_jan79/Y%04d/M%02d/' %(yy,mm)
        filename = dir+'d5124_m2_jan79.tavg1_2d_aer_Nx.%04d%02d%02d.nc4' %(yy,mm,dd)
    print(filename)
    ext, lon, lat, lev, rc = read1(filename,varn,z=z,merra2=merra2)
    return ext, lon, lat, lev, rc

# Read and form monthly average
def readmon(yy,mm,varn='TOTEXTTAU550',z=-1,
            expid='C90c_HTerupV03a',merra2=-1):
    dir = '/misc/prc18/colarco/'
    filename = dir+expid+"/tavg2d_aer_x/%s.tavg2d_aer_x.monthly.%04d%02d.nc4" %(expid,yy,mm)
    if(merra2 > 0):
        dir = '/misc/prc13/MERRA2/d5124_m2_jan79/Y%04d/M%02d/' %(yy,mm)
        filename = dir+'d5124_m2_jan79.tavg1_2d_aer_Nx.monthly.%04d%02d.nc4' %(yy,mm)
    print(varn,filename)
    ext, lon, lat, lev, rc = read1(filename,varn,merra2=merra2)
    return ext, lon, lat, lev, rc

# Read a zonal average
def readzonal(yy,mm,dd='',varn='SUEXTCOEF',lev=-1,
              expid='C90c_HTerupV03a',merra2=-1):
    if dd:
        ext,lon,lat,levs,rc = readday(yy,mm,dd,varn=varn,expid=expid,merra2=merra2)
    else:
        ext,lon,lat,levs,rc = readmon(yy,mm,varn=varn,expid=expid,merra2=merra2)
    if rc == 0:
#        print(ext.shape)
        if lev > 0:
            extz = ma.mean(ext,axis=1)
        else:
            extz = ma.mean(ext,axis=2)
    else:
        extz = 1
        lat = 1
    return extz, lat, rc
