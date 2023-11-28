import model
import numpy as np
from datetime import datetime
from dateutil.relativedelta import relativedelta
import numpy.ma as ma

import matplotlib.pyplot as plt
import matplotlib.dates as mdates
from matplotlib.dates import MonthLocator, WeekdayLocator, DateFormatter
import matplotlib.ticker as ticker
import matplotlib.colors as colors

def plot(varn='SUEXTCOEF',expid='c180R_v10p23p0_sc',merra2=-1):

    nmons = 60
    start = datetime(2016,1,15)

    dates = [start + relativedelta(months=x) for x in range(0,nmons)]

    i = 0
    for date in dates:
        yy = int(date.strftime("%Y"))
        mm = int(date.strftime("%m"))
        dd = int(date.strftime("%d"))
        ext,lat, rc = model.readzonal(yy,mm,lev=1,varn=varn,expid=expid,merra2=merra2)
        if i == 0:
            exto = ma.masked_array(data=np.zeros((len(dates),len(lat))),fill_value=1.e15)
        if rc == 0:
            exto[i,:] = ma.array(ext.data,mask=ext.mask)
            latsav = lat
        i = i+1
        lat = latsav

        extf = ma.masked_array(data=np.zeros((len(dates),len(lat[np.where(lat >=60)]))),fill_value=1.e15)
        extf[:,:] = np.squeeze(exto[:,np.where(lat >= 60)])
        latf  = lat[np.where(lat >= 60)]

    daysx, latsx = np.meshgrid(dates,latf)

    fig, ax = plt.subplots(1,1,figsize=(20,5))
    clevs = np.arange(0,.2,.005)
    cf = ax.contourf(daysx, latsx, np.transpose(extf), clevs, cmap='Spectral_r', extend='both')

    cbar1=plt.colorbar(cf, ax=ax, orientation='vertical', pad=0.1, extend="max")
    cbar1.ax.tick_params(labelsize=12)
    cbar1.set_label(label='AOD 550 nm',size=12)

    plt.tight_layout()
    print('plotting')
    fig.savefig('%s.2016_2020.%s.monthly.png'%(expid,varn.lower()))
    print('done')
    plt.close(fig)


