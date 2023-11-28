import ompsl3
import model
import numpy as np
import datetime
import numpy.ma as ma
from netCDF4 import Dataset

import matplotlib.pyplot as plt
import matplotlib.dates as mdates
from matplotlib.dates import MonthLocator, WeekdayLocator, DateFormatter
import matplotlib.ticker as ticker

start = datetime.datetime.strptime("01-01-2016", "%d-%m-%Y")
end   = datetime.datetime.strptime("31-12-2019", "%d-%m-%Y")

dates = [start + datetime.timedelta(days=x) for x in range(0, (end-start).days)]

aod  = ma.masked_array(data=np.zeros((len(dates),121)),fill_value=1.e15)
aodm = ma.masked_array(data=np.zeros((len(dates),121)),fill_value=1.e15)

alt = np.empty(41)
for k in range(0,41):
    alt[k] = k+0.5

i = 0
for date in dates:
    yy = int(date.strftime("%Y"))
    mm = int(date.strftime("%m"))
    dd = int(date.strftime("%d"))
    ext,lat = ompsl3.readzonal(yy,mm,dd=dd)
    troph,lon,lat = ompsl3.readtroph(yy,mm,dd)
    scat,lon,lat  = ompsl3.readscat(yy,mm,dd)
    extm,latm,rc = model.readzonal(yy,mm,dd=dd)
    tropz = ma.mean(troph,axis=1)
#    scatz = ma.mean(scat,axis=1)
    scatz = ma.amax(scat,axis=1)

    for j in range (0,121):
        if scatz[j] < 148:
            b = np.where(alt>tropz[j])
            aod[i,j] = ma.sum(ext[b,j])
    b = np.where(aod[i,:]<1.e-12)
    aod[i,b] = ma.masked
    aodm[i,:] = np.interp(lat,latm,extm)
    aodm[i,b] = ma.masked
    i = i+1

#print(aod.shape,np.max(aod))

daysx, latsx = np.meshgrid(dates,lat)

fig, ax = plt.subplots(1,1,figsize=(20,5))
clevs = np.arange(0,30,.1)
#clevs = np.arange(0,5,.1)
cf = ax.contourf(daysx, latsx, np.transpose(aodm)*1.e3, clevs, cmap='Spectral_r', extend='both')
#fig.colorbar(cf)

cbar1=plt.colorbar(cf, ax=ax, orientation='vertical', pad=0.01, extend="max")
cbar1.ax.tick_params(labelsize=12)
#plt.xticks(ticks=[2012,2013,2014,2015,2016,2017,2018,2019,2020,2021,2022,2023])
cbar1.set_label(label='Stratospheric AOD 869 nm [x1000]',size=12)

plt.tight_layout()
#plt.show()
print('plotting')
fig.savefig('model_strataod_2016_2019.png')
print('done')
plt.close(fig)

# Write the plotted data to a file
fid = Dataset('geos_daily_zonal.nc', 'w', format='NETCDF4', clobber=True)
fid.description = "source: GEOS/GOCART2G gridded data, zonal/daily average, \
                   sampled as OMPS LP"
fid.createDimension('time',None)
fid.createDimension('latitude',121)
fid.createDimension('longitude',1)
#fid.createDimension('level',41)

vtime = fid.createVariable('time','f8',('time',))
fid.createVariable('latitude','f8',('latitude',))
fid.createVariable('longitude','f8',('longitude',))
#fid.createVariable('level','f8',('level',))
vaod  = fid.createVariable('aod','f8',('time','latitude','longitude',))

vtime.setncatts({'var_desc': u"Days since 12z1Jan2016"})
vaod.setncatts({'var_desc': u"Zonal, daily mean stratospheric AOD @ 869 nm (x 1000)"})
print(aod.shape)

fid.variables['time'][:] = range(0, (end-start).days)
fid.variables['latitude'][:] = lat
fid.variables['longitude'][:] = 180.
fid.variables['aod'][:] = aodm*1.e3
#fid.variables['level'][:] = alt
fid.close()
