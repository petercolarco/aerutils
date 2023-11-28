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

def cntrlexp(expid='C90c_HTerupV02a'):
    return{
        'C90c_HTerupV02a': 'C90c_HTcntl',
        'C90c_HTerupV02b': 'C90c_HTcntl_b',
        'C90c_HTerupV02c': 'C90c_HTcntl_c',
        'C90c_HTerupV02d': 'C90c_HTcntl_d',
    }.get(expid,'junk')

dir = "/science/gmao/geosccm/data/Hunga-Tonga/"

def plot(varn='SUEXTTAU',expid='C90c_HTerupV02a',ens=-1):

    expid2 = cntrlexp(expid)
    nmons = 36
    start = datetime(2022,1,15)

    dates = [start + relativedelta(months=x) for x in range(0,nmons)]

    exto = ma.masked_array(data=np.zeros((len(dates),181)),fill_value=1.e15)
    aod  = ma.masked_array(data=np.zeros((len(dates))),fill_value=1.e15)

    i = 0
    for date in dates:
        yy = int(date.strftime("%Y"))
        mm = int(date.strftime("%m"))
        dd = int(date.strftime("%d"))
        if ens <= 0:
            ext,lat, rc = model.readzonal(yy,mm,lev=1,varn=varn,dir=dir,expid=expid)
            ext2,lat, rc = model.readzonal(yy,mm,lev=1,varn=varn,dir=dir,expid=expid2)
            ext = ext-ext2
            if rc == 0:
                exto[i,:] = ma.array(ext.data,mask=ext.mask)
                latsav = lat
        else:
            ext1,lat, rc = model.readzonal(yy,mm,lev=1,varn=varn,dir=dir,expid='C90c_HTerupV02a')
            expid2 = cntrlexp('C90c_HTerupV02a')
            ext1_,lat, rc = model.readzonal(yy,mm,lev=1,varn=varn,dir=dir,expid=expid2)
            ext2,lat, rc = model.readzonal(yy,mm,lev=1,varn=varn,dir=dir,expid='C90c_HTerupV02b')
            expid2 = cntrlexp('C90c_HTerupV02b')
            ext2_,lat, rc = model.readzonal(yy,mm,lev=1,varn=varn,dir=dir,expid=expid2)
            ext3,lat, rc = model.readzonal(yy,mm,lev=1,varn=varn,dir=dir,expid='C90c_HTerupV02c')
            expid2 = cntrlexp('C90c_HTerupV02c')
            ext3_,lat, rc = model.readzonal(yy,mm,lev=1,varn=varn,dir=dir,expid=expid2)
            ext4,lat, rc = model.readzonal(yy,mm,lev=1,varn=varn,dir=dir,expid='C90c_HTerupV02d')
            expid2 = cntrlexp('C90c_HTerupV02d')
            ext4_,lat, rc = model.readzonal(yy,mm,lev=1,varn=varn,dir=dir,expid=expid2)
            ext = (ext1+ext2+ext3+ext4-ext1_-ext2_-ext3_-ext4_)/4.
            if rc == 0:
                exto[i,:] = ma.array(ext.data,mask=ext.mask)
                latsav = lat
        lat = latsav
        cosfac = ma.masked_array(data=np.zeros(181),fill_value=1.e15)
        for j in range (0,181):
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
        fig.savefig('%s_2022_2024.aod.monthly.png'%(expid))
    else:
        fig.savefig('C90c_HTerupV02ens_2022_2024.aod.monthly.png')
    print('done')
    plt.close(fig)

