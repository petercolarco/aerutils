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

import math

dir = "/misc/prc18/colarco/"

def plot(varn='TOTSTEXTTAU870',expid='c180R_v10p23p0_sc',ens=-1):

    nmons = 48
    start = datetime(2016,1,15)

    dates = [start + relativedelta(months=x) for x in range(0,nmons)]

    exto = ma.masked_array(data=np.zeros((len(dates),361)),fill_value=1.e15)
    aod  = ma.masked_array(data=np.zeros((len(dates))),fill_value=1.e15)

    i = 0
    for date in dates:
        print(date)
        yy = int(date.strftime("%Y"))
        mm = int(date.strftime("%m"))
        dd = int(date.strftime("%d"))
        ext,lat, rc = model.readzonal(yy,mm,lev=1,varn=varn,dir=dir,expid=expid)
        print(rc)
        if rc == 0:
                exto[i,:] = ma.array(ext.data,mask=ext.mask)
                latsav = lat
        lat = latsav
        cosfac = ma.masked_array(data=np.zeros(361),fill_value=1.e15)
        for j in range (0,361):
            cosfac[j] = math.cos(math.pi/180.*lat[j])
        print(lat.shape)
        aod[i] = ma.sum(np.squeeze(exto[i,:])*cosfac)
        i = i+1

    wt = ma.sum(cosfac)
    exto = exto/wt

    daysx, latsx = np.meshgrid(dates,lat)

    fig, ax = plt.subplots(1,1,figsize=(20,5))
    cf = ax.plot(np.squeeze(daysx[0,:]), aod/wt*1.e3*0.32)

    plt.tight_layout()
        #plt.show()
    print('plotting')
    if ens < 0:
        fig.savefig('%s_2016_2019.aod.monthly.png'%(expid))
    else:
        fig.savefig('C90c_HTerupV02ens_2022_2024.aod.monthly.png')
    print('done')
    plt.close(fig)

