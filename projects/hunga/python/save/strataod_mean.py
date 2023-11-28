import ompsl3
import numpy as np
import datetime
import numpy.ma as ma

import matplotlib.pyplot as plt
import matplotlib.dates as mdates
from matplotlib.dates import MonthLocator, WeekdayLocator, DateFormatter
import matplotlib.ticker as ticker

start = datetime.datetime.strptime("01-01-2012", "%d-%m-%Y")
end   = datetime.datetime.strptime("31-12-2022", "%d-%m-%Y")

dates = [start + datetime.timedelta(days=x) for x in range(0, (end-start).days)]

aod = ma.masked_array(data=np.zeros((len(dates),121)),fill_value=1.e15)

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
    tropz = ma.mean(troph,axis=1)
#    scatz = ma.mean(scat,axis=1)
    scatz = ma.amax(scat,axis=1)

    for j in range (0,121):
        if scatz[j] < 148:
            b = np.where(alt>tropz[j])
            aod[i,j] = ma.sum(ext[b,j])
    i = i+1
#print(aod.shape,np.max(aod))

daysx, latsx = np.meshgrid(dates,lat)

fig, ax = plt.subplots(1,1,figsize=(20,5))
cf = ax.plot(np.squeeze(daysx[0,:]), ma.mean(aod,axis=1)*1.e6)

plt.tight_layout()
#plt.show()
print('plotting')
fig.savefig('snppompslp_strataod_mean_2012_2022.png')
print('done')
plt.close(fig)
