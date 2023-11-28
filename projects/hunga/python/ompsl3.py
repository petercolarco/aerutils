# Module of functions to manipulate GEOS/NNR MODIS Level 3 files
import numpy as np
import numpy.ma as ma
import os.path
from netCDF4 import Dataset
import calendar
import copy
import datetime

def channelvar(channel=5):
    return {
        1: 'ext510',
        2: 'ext600',
        3: 'ext675',
        4: 'ext745',
        5: 'ext869',
        6: 'ext997',
        7: 'troph', 
        8: 'scatang'
    }.get(channel,'junk')


# Read channel = channel of tau_ from single file
# Need trap that if not found return NaN
def read1(filename,channel=5):
    lonname = 'longitude'
    latname = 'latitude'
    ext     = np.empty((41,121,18))
    ext[:]  = np.nan

    varn = channelvar(channel)
#    print(varn)
    
    if os.path.isfile(filename)==True:
       with Dataset(filename,'r') as ncid:
           lon = ncid.variables[lonname][:]
           lat = ncid.variables[latname][:]
           ext = np.squeeze(ncid.variables[varn][:])
#           print(np.min(ext),np.max(ext))
#           ext[ext>=999.0]  = np.nan
#           ext[ext<=-900.0] = np.nan
    return ext, lon, lat


# Read and form daily average
def readday(yy,mm,dd,channel=5):
    filename="/misc/prc10/OMPS_LP/v21/omps_aer_3slits_gridded_v21.%04d%02d%02d.nc" %(yy,mm,dd)
#    print(filename)
    ext, lon, lat = read1(filename,channel)
#    print(np.max(ext),np.min(ext))
    return ext, lon, lat

# Read the scattering angle
def readscat(yy,mm,dd):
    filename="/misc/prc10/OMPS_LP/v21/omps_aer_3slits_gridded_v21.%04d%02d%02d.nc" %(yy,mm,dd)
    scatang, lon, lat = read1(filename,channel=8)
    return scatang, lon, lat

# Read the tropopause height
def readtroph(yy,mm,dd):
    filename="/misc/prc10/OMPS_LP/v21/omps_aer_3slits_gridded_v21.%04d%02d%02d.nc" %(yy,mm,dd)
    troph, lon, lat = read1(filename,channel=7)
    return troph, lon, lat


# Read and form monthly average
def readmon(yy,mm,channel=5):
    dds = calendar.monthrange(yy,mm)[1]
    ext_    =ma.masked_array(data=np.zeros((41,121,18,dds)),fill_value=1.e15)
    for dd in range(1,dds+1):
#        print(dd)
        ext, lon, lat = readday(yy,mm,dd,channel=channel)
        ext_[:,:,:,dd-1] = ma.array(ext.data,mask=ext.mask)
    extmm = ma.mean(ext_,axis=3)
    return extmm, lon, lat

# Read a zonal average
def readzonal(yy,mm,dd='',channel=5,lev=''):
    if dd:
        ext,lon,lat = readday(yy,mm,dd,channel=channel)
    else:
        ext,lon,lat = readmon(yy,mm,channel=channel)
    extz = ma.mean(ext,axis=2)
    if lev:
        extz = np.squeeze(extz[lev,:])
    return extz, lat
