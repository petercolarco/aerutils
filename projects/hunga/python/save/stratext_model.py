import model
import numpy as np
import datetime
import numpy.ma as ma

import matplotlib.pyplot as plt
import matplotlib.dates as mdates
from matplotlib.dates import MonthLocator, WeekdayLocator, DateFormatter
import matplotlib.ticker as ticker

def levindex(lev=26):
    return {
        26: 31,
        24: 30,
        21: 28
    }.get(lev,'junk')


def plot(lev,varn='SUEXTCOEF'):

    levz = levindex(lev)
    start = datetime.datetime.strptime("01-01-2022", "%d-%m-%Y")
    end   = datetime.datetime.strptime("31-12-2022", "%d-%m-%Y")

    dates = [start + datetime.timedelta(days=x) for x in range(0, (end-start).days)]

    exto = ma.masked_array(data=np.zeros((len(dates),181)),fill_value=1.e15)

    i = 0
    for date in dates:
        yy = int(date.strftime("%Y"))
        mm = int(date.strftime("%m"))
        dd = int(date.strftime("%d"))
        ext,lat, rc = model.readzonal(yy,mm,dd=dd,lev=levz,varn=varn)
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
    fig.savefig('C90c_HTerupV03a_%02dkm_2012_2022.png'%(lev))       
    print('done')
    plt.close(fig)



def plotdry(lev):

    levz = levindex(lev)
    start = datetime.datetime.strptime("01-01-2022", "%d-%m-%Y")
    end   = datetime.datetime.strptime("31-12-2022", "%d-%m-%Y")

    dates = [start + datetime.timedelta(days=x) for x in range(0, (end-start).days)]

    exto = ma.masked_array(data=np.zeros((len(dates),181)),fill_value=1.e15)

    i = 0
    for date in dates:
        yy = int(date.strftime("%Y"))
        mm = int(date.strftime("%m"))
        dd = int(date.strftime("%d"))
        ext,lat, rc = model.readzonaldry(yy,mm,dd=dd,lev=levz)
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
    fig.savefig('C90c_HTerupV03a_%02dkm_2012_2022_dry.png'%(lev))       
    print('done')
    plt.close(fig)
