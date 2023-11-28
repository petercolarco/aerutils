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

aodm = ma.masked_array(data=np.zeros((len(dates),121)),fill_value=1.e15)

with Dataset('geos_daily_zonal.nc', 'r') as ncid:
    lat = ncid.variables['latitude'][:]
    aodm = ncid.variables['aod'][:]

print(lat.shape)
print(aodm.shape)

daysx, latsx = np.meshgrid(dates,lat)

fig, ax = plt.subplots(1,1,figsize=(20,5))
clevs = np.arange(0,30,.1)
#clevs = np.arange(0,5,.1)
cf = ax.contourf(daysx, latsx, np.transpose(np.squeeze(aodm)), clevs, cmap='Spectral_r', extend='both')
#fig.colorbar(cf)

cbar1=plt.colorbar(cf, ax=ax, orientation='vertical', pad=0.01, extend="max")
cbar1.ax.tick_params(labelsize=12)
#plt.xticks(ticks=[2012,2013,2014,2015,2016,2017,2018,2019,2020,2021,2022,2023])
cbar1.set_label(label='Stratospheric AOD 869 nm [x1000]',size=12)

plt.tight_layout()
#plt.show()
print('plotting')
fig.savefig('plot_model_strataod_2016_2019.png')
print('done')
plt.close(fig)

