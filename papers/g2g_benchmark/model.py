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
        1: 'TOTSTEXTTAU870',
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
def read1(filename,varn='TOTSTEXTTAU870',z=-1):
    lonname = 'lon'
    latname = 'lat'
    levname = 'lev'
    ext     = np.empty((1,361,720))
    ext[:]  = np.nan

    print('PETE',filename)
    if os.path.isfile(filename)==True:
       rc = 0
       with Dataset(filename,'r') as ncid:
           lon = ncid.variables[lonname][:]
           lat = ncid.variables[latname][:]
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
def readday(yy,mm,dd,varn='TOTSTEXTTAU870',z=-1,
            dir='/misc/prc18/colarco/',expid='c180R_v10p23p0_sc'):
#    filename = dir+expid+"/Y%04d/M%02d/%s.tavg24_3d_aer_Np.%04d%02d%02d.nc4" %(yy,mm,expid,yy,mm,dd)
    filename = dir+expid+"/inst2d_hwl_x/Y%04d/%s.inst2d_hwl_x.%04d%02d%02d_1200z.nc4" %(yy,expid,yy,mm,dd)
    if varn=='Q':
        filename = dir+expid+"/Y%04d/M%02d/%s.tavg24_3d_dad_Np.%04d%02d%02d.nc4" %(yy,mm,expid,yy,mm,dd)
    print(filename)
    if varn=='SUEXTTAU':
        filename = dir+expid+"/Y%04d/M%02d/%s.tavg1_2d_aer_Nx.%04d%02d%02d.nc4" %(yy,mm,expid,yy,mm,dd)
    if varn=='SWTNT':
        filename = dir+expid+"/Y%04d/M%02d/%s.tavg24_2d_dad_Nx.%04d%02d%02d.nc4" %(yy,mm,expid,yy,mm,dd)
    if varn=='LWTUP':
        filename = dir+expid+"/Y%04d/M%02d/%s.tavg24_2d_dad_Nx.%04d%02d%02d.nc4" %(yy,mm,expid,yy,mm,dd)
    if varn=='LWGNT':
        filename = dir+expid+"/Y%04d/M%02d/%s.tavg24_2d_dad_Nx.%04d%02d%02d.nc4" %(yy,mm,expid,yy,mm,dd)
    print(filename)
    ext, lon, lat, lev, rc = read1(filename,varn,z=z)
    if varn=='SWTNT':
        ext2, lon, lat, lev, rc = read1(filename,'SWTNTCLN',z=z)
        ext = ext-ext2
    print(filename,ext.shape)
    return ext, lon, lat, lev, rc

# Read and form monthly average
def readmon(yy,mm,varn='TOTSTEXTTAU870',z=-1,
            dir='/misc/prc18/colarco/',expid='c180R_v10p23p0_sc'):
    filename = dir+expid+"/inst2d_hwl_x/%s.inst2d_hwl_x.monthly.%04d%02d.nc4" %(expid,yy,mm)
    print(filename)
    ext, lon, lat, lev, rc = read1(filename,varn)
    return ext, lon, lat, lev, rc

# Read a zonal average
def readzonal(yy,mm,dd='',varn='TOTSTEXTTAU870',lev=-1,
              dir='/misc/prc18/colarco/',expid='c180R_v10p23p0_sc'):
    print(yy,mm,dd,varn,lev,dir,expid)
    if dd:
        ext,lon,lat,levs,rc = readday(yy,mm,dd,varn=varn,dir=dir,expid=expid)
    else:
        ext,lon,lat,levs,rc = readmon(yy,mm,varn=varn,dir=dir,expid=expid)
    if rc == 0:
        print(ext.shape,lev)
        if lev < 0:
            extz = ma.mean(ext,axis=1)
        else:
            extz = ma.mean(ext,axis=2)
    else:
        extz = 1
        lat = 1
    return extz, lat, rc


# Read a zonal average (dry aerosol extinction)
# Ad hoc transfer of MMR to dry extinction [550]
def readzonaldry(yy,mm,dd='',lev=''):
    if dd:
        ext,lon,lat,levs,rc = readday(yy,mm,dd,varn='SO4',dir=dir,expid=expid)
        rho,lon,lat,levs,rc = readday(yy,mm,dd,varn='AIRDENS',dir=dir,expid=expid)
        ext = ext*rho*3150.
    else:
        ext,lon,lat,levs,rc = readmon(yy,mm,varn='SO4',dir=dir,expid=expid)
        ext,lon,lat,levs,rc = readmon(yy,mm,varn='AIRDENS',dir=dir,expid=expid)
        ext= ext*rho*3150.
    if rc == 0:
        extz = ma.mean(ext,axis=2)
        if lev:
            extz = np.squeeze(extz[lev,:])
    else:
        extz = 1
        lat = 1
    return extz, lat, rc
