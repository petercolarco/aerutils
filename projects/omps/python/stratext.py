import ompsl3
import numpy as np
import datetime
import numpy.ma as ma

import matplotlib.pyplot as plt
import matplotlib.dates as mdates
from matplotlib.dates import MonthLocator, WeekdayLocator, DateFormatter
import matplotlib.ticker as ticker


def plot(lev,channel=5):

    start = datetime.datetime.strptime("01-01-2012", "%d-%m-%Y")
    end   = datetime.datetime.strptime("31-12-2022", "%d-%m-%Y")

    dates = [start + datetime.timedelta(days=x) for x in range(0, (end-start).days)]

    exto = ma.masked_array(data=np.zeros((len(dates),121)),fill_value=1.e15)

    i = 0
    for date in dates:
        yy = int(date.strftime("%Y"))
        mm = int(date.strftime("%m"))
        dd = int(date.strftime("%d"))
        ext,lat = ompsl3.readzonal(yy,mm,dd=dd,lev=lev,channel=channel)
        scat,lon,lat  = ompsl3.readscat(yy,mm,dd)
        scatz = ma.amax(scat,axis=1)
        ext.mask[np.where(scatz>=148)] = True
        exto[i,:] = ma.array(ext.data,mask=ext.mask)
        i = i+1
        print(exto.shape,np.max(exto))

    daysx, latsx = np.meshgrid(dates,lat)

    fig, ax = plt.subplots(1,1,figsize=(20,5))
#    clevs = np.arange(0,20,.1)
    clevs = np.arange(0,5,.1)
    cf = ax.contourf(daysx, latsx, np.transpose(exto)*1e7, clevs, cmap='Spectral_r', extend='both')
    #fig.colorbar(cf)

    cbar1=plt.colorbar(cf, ax=ax, orientation='vertical', pad=0.1, extend="max")
    cbar1.ax.tick_params(labelsize=12)
    cbar1.set_label(label='Extinction 869 nm [10^-4 km^-1]',size=12)

    plt.tight_layout()
        #plt.show()
    print('plotting')
    fig.savefig('snppompslp_%02dkm_2012_2022.png'%(lev))
    print('done')
    plt.close(fig)
