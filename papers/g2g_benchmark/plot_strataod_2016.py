
import ompsl3
import numpy as np
import datetime
import numpy.ma as ma
from netCDF4 import Dataset

import matplotlib.pyplot as plt
import matplotlib.dates as mdates
from matplotlib.dates import MonthLocator, WeekdayLocator, DateFormatter
import matplotlib.ticker as ticker

start = datetime.datetime.strptime("01-01-2016", "%d-%m-%Y")
end   = datetime.datetime.strptime("31-12-2016", "%d-%m-%Y")

dates = [start + datetime.timedelta(days=x) for x in range(0, (end-start).days)]

aod = ma.masked_array(data=np.zeros((len(dates),121)),fill_value=1.e15)

with Dataset('omps_lp_daily_zonal.nc', 'r') as ncid:
    lat = ncid.variables['latitude'][:]
    aod = ncid.variables['aod'][:]

aod = aod[0:365,:,:]
print(aod.shape,np.max(aod))

daysx, latsx = np.meshgrid(dates,lat)

fig, ax = plt.subplots(1,1,figsize=(20,5))
clevs = np.arange(0,30,.1)
#clevs = np.arange(0,5,.1)
cf = ax.contourf(daysx, latsx, np.transpose(np.squeeze(aod)), clevs, cmap='Spectral_r', extend='both')
#fig.colorbar(cf)

cbar1=plt.colorbar(cf, ax=ax, orientation='vertical', pad=0.01, extend="max")
cbar1.ax.tick_params(labelsize=12)
#plt.xticks(ticks=[2012,2013,2014,2015,2016,2017,2018,2019,2020,2021,2022,2023])
cbar1.set_label(label='Stratospheric AOD 869 nm [x1000]',size=12)

plt.tight_layout()
#plt.show()
print('plotting')
fig.savefig('plot_snppompslp_strataod_2016_2016.png')
print('done')
plt.close(fig)

