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
def read1(filename,varn='SUEXTCOEF'):
    lonname = 'lon'
    latname = 'lat'
    levname = 'lev'
    ext     = np.empty((41,121,18))
    ext[:]  = np.nan

    if os.path.isfile(filename)==True:
       rc = 0
       with Dataset(filename,'r') as ncid:
           lon = ncid.variables[lonname][:]
           lat = ncid.variables[latname][:]
           lev = ncid.variables[levname][:]
           ext = np.squeeze(ncid.variables[varn][:])
    else:
        rc = 1
        ext = 1.
        lon = 1.
        lat = 1.
        lev = 1.

    return ext, lon, lat, lev, rc


# Read and form daily average
def readday(yy,mm,dd,varn='SUEXTCOEF'):
    filename="/misc/prc18/colarco/C90c_HTerupV03a/C90c_HTerupV03a.tavg24_3d_aer_Np.%04d%02d%02d.nc4" %(yy,mm,dd)
    print(filename)
    ext, lon, lat, lev, rc = read1(filename,varn)
#    print(np.max(ext),np.min(ext))
    return ext, lon, lat, lev, rc

# Read and form monthly average
def readmon(yy,mm,varn='SUEXTCOEF'):
    dds = calendar.monthrange(yy,mm)[1]
    ext_    =ma.masked_array(data=np.zeros((44,181,360,dds)),fill_value=1.e15)
    for dd in range(1,dds+1):
#        print(dd)
        ext, lon, lat, lev, rc = readday(yy,mm,dd,varn)
        ext_[:,:,:,dd-1] = ma.array(ext.data,mask=ext.mask)
    extmm = ma.mean(ext_,axis=3)
    return extmm, lon, lat, lev, rc

# Read a zonal average
def readzonal(yy,mm,dd='',varn='SUEXTCOEF',lev=''):
    if dd:
        ext,lon,lat,levs,rc = readday(yy,mm,dd,varn)
    else:
        ext,lon,lat,levs,rc = readmon(yy,mm,varn)
    if rc == 0:
        extz = ma.mean(ext,axis=2)
        if lev:
            extz = np.squeeze(extz[lev,:])
    else:
        extz = 1
        lat = 1
    return extz, lat, rc


# Read a zonal average (dry aerosol extinction)
# Ad hoc transfer of MMR to dry extinction [550]
def readzonaldry(yy,mm,dd='',lev=''):
    if dd:
        ext,lon,lat,levs,rc = readday(yy,mm,dd,varn='SO4')
        rho,lon,lat,levs,rc = readday(yy,mm,dd,varn='AIRDENS')
        ext = ext*rho*3150.
    else:
        ext,lon,lat,levs,rc = readmon(yy,mm,varn='SO4')
        ext,lon,lat,levs,rc = readmon(yy,mm,varn='AIRDENS')
        ext= ext*rho*3150.
    if rc == 0:
        extz = ma.mean(ext,axis=2)
        if lev:
            extz = np.squeeze(extz[lev,:])
    else:
        extz = 1
        lat = 1
    return extz, lat, rc
