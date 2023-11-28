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

def cntrlexp(expid='C90c_HTerupV02a'):
    return{
        'C90c_HTerupV02a': 'C90c_HTcntl',
        'C90c_HTerupV02b': 'C90c_HTcntl_b',
        'C90c_HTerupV02c': 'C90c_HTcntl_c',
        'C90c_HTerupV02d': 'C90c_HTcntl_d',
    }.get(expid,'junk')

dir = "/misc/prc18/colarco/"

def plot(varn='SWTNT',expid='C90c_HTerupV02a',ens=-1):

    expid2 = cntrlexp(expid)
    nmons = 31
    start = datetime(2022,6,15)

    dates = [start + relativedelta(months=x) for x in range(0,nmons)]

    exto = ma.masked_array(data=np.zeros((len(dates),181)),fill_value=1.e15)

    i = 0
    for date in dates:
        yy = int(date.strftime("%Y"))
        mm = int(date.strftime("%m"))
        dd = int(date.strftime("%d"))
        if ens <= 0:
            ext,lat, rc = model.readzonal(yy,mm,varn=varn,dir=dir,expid=expid,lev=1)
            ext2,lat, rc = model.readzonal(yy,mm,varn=varn,dir=dir,expid=expid2,lev=1)
            ext = ext-ext2
            if rc == 0:
                exto[i,:] = ma.array(ext.data,mask=ext.mask)
                latsav = lat
        else:
            ext1,lat, rc = model.readzonal(yy,mm,varn=varn,dir=dir,expid='C90c_HTerupV02a',lev=1)
            expid2 = cntrlexp('C90c_HTerupV02a')
            ext1_,lat, rc = model.readzonal(yy,mm,varn=varn,dir=dir,expid=expid2,lev=1)
            ext2,lat, rc = model.readzonal(yy,mm,varn=varn,dir=dir,expid='C90c_HTerupV02b',lev=1)
            expid2 = cntrlexp('C90c_HTerupV02b')
            ext2_,lat, rc = model.readzonal(yy,mm,varn=varn,dir=dir,expid=expid2,lev=1)
            ext3,lat, rc = model.readzonal(yy,mm,varn=varn,dir=dir,expid='C90c_HTerupV02c',lev=1)
            expid2 = cntrlexp('C90c_HTerupV02c')
            ext3_,lat, rc = model.readzonal(yy,mm,varn=varn,dir=dir,expid=expid2,lev=1)
            ext4,lat, rc = model.readzonal(yy,mm,varn=varn,dir=dir,expid='C90c_HTerupV02d',lev=1)
            expid2 = cntrlexp('C90c_HTerupV02d')
            ext4_,lat, rc = model.readzonal(yy,mm,varn=varn,dir=dir,expid=expid2,lev=1)
            ext = (ext1+ext2+ext3+ext4-ext1_-ext2_-ext3_-ext4_)/4.
            if rc == 0:
                exto[i,:] = ma.array(ext.data,mask=ext.mask)
                latsav = lat
        i = i+1
        lat = latsav

    daysx, latsx = np.meshgrid(dates,lat)

    fig, ax = plt.subplots(1,1,figsize=(20,5))
    clevs = np.arange(-.5,.5,.025)
    print(np.min(np.transpose(exto)))
    cf = ax.contourf(daysx, latsx, np.transpose(exto), clevs, cmap='Spectral_r', extend='both')
    #fig.colorbar(cf)

    cbar1=plt.colorbar(cf, ax=ax, orientation='vertical', pad=0.1, extend="max")
    cbar1.ax.tick_params(labelsize=12)
    cbar1.set_label(label='%s [W m^-2]'%(varn),size=12)

    plt.tight_layout()
        #plt.show()
    print('plotting')
    if ens < 0:
        fig.savefig('%s_2022_2024.%s.monthly.png'%(expid,varn.lower()))
    else:
        fig.savefig('C90c_HTerupV02ens_2022_2024.%s.monthly.png'%(varn.lower()))
    print('done')
    plt.close(fig)



def plotdry(lev,expid='C90c_HTerupV02a'):

    levz = levindex(lev)
    start = datetime.datetime.strptime("01-01-2022", "%d-%m-%Y")
    end   = datetime.datetime.strptime("31-12-2024", "%d-%m-%Y")

    dates = [start + datetime.timedelta(days=x) for x in range(0, (end-start).days)]

    exto = ma.masked_array(data=np.zeros((len(dates),181)),fill_value=1.e15)

    i = 0
    for date in dates:
        yy = int(date.strftime("%Y"))
        mm = int(date.strftime("%m"))
        dd = int(date.strftime("%d"))
        ext,lat, rc = model.readzonaldry(yy,mm,dd=dd,dir=dir,expid=expid)
        if rc == 0:
            exto[i,:] = ma.array(ext.data,mask=ext.mask)
            latsav = lat
        i = i+1
        print(exto.shape,np.max(exto))
        lat = latsav

    daysx, latsx = np.meshgrid(dates,lat)

    fig, ax = plt.subplots(1,1,figsize=(20,5))
    clevs = np.arange(0,20,.1)
#    clevs = np.arange(0,5,.1)
#   Scale to 870 nm ad hoc
    cf = ax.contourf(daysx, latsx, np.transpose(exto)*1e7*0.32, clevs, cmap='Spectral_r', extend='both')
    #fig.colorbar(cf)

    cbar1=plt.colorbar(cf, ax=ax, orientation='vertical', pad=0.1, extend="max")
    cbar1.ax.tick_params(labelsize=12)
    cbar1.set_label(label='Extinction 869 nm [10^-4 km^-1]',size=12)

    plt.tight_layout()
        #plt.show()
    print('plotting')
    fig.savefig('%s_%02dkm_2022_2024_dry.png'%(expid,lev))
    print('done')
    plt.close(fig)
