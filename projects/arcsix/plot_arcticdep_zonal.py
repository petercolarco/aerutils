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

def variables(varn='BC'):
    return {
        'BC': ['BCDP001','BCDP002','BCWT002','BCSV'],
        'OC': ['OCDP001','OCDP002','OCWT002','OCSV'],
        'BR': ['BRDP001','BRDP002','BRWT002','BRSV'],
        'DU': ['DUDP001','DUDP002','DUDP003','DUDP004','DUDP005',
               'DUWT001','DUWT002','DUWT003','DUWT004','DUWT005',
               'DUSD001','DUSD002','DUSD003','DUSD004','DUSD005',
               'DUSV'],
        'SS': ['SSDP001','SSDP002','SSDP003','SSDP004','SSDP005',
               'SSWT001','SSWT002','SSWT003','SSWT004','SSWT005',
               'SSSD001','SSSD002','SSSD003','SSSD004','SSSD005',
               'SSSV'],
        'NI': ['NIDP001','NIDP002','NIDP003',
               'NIWT001','NIWT002','NIWT003',
               'NISD001','NISD002','NISD003',
               'NISV'],
        'SU': ['SUDP003','SUWT003','SUSD003','SUSV']
    }.get(varn,'junk')

def plot(varn='BC',expid='c180R_v10p23p0_sc',merra2=-1):

    varn_ = variables(varn)

    nmons = 60
    start = datetime(2016,1,15)

    dates = [start + relativedelta(months=x) for x in range(0,nmons)]

    i = 0
    for date in dates:
        yy = int(date.strftime("%Y"))
        mm = int(date.strftime("%m"))
        dd = int(date.strftime("%d"))
        for j in range(0,len(varn_)):
            l = len(varn_[j])
            ext_,lat, rc = model.readzonal(yy,mm,lev=1,varn=varn_[j],expid=expid,merra2=merra2)
            fac = 1.
            if varn_[j][l-2:] == 'SV':
                fac=-1.
            if j == 0:
                ext = fac*ext_
            else:
                ext = ext+fac*ext_

        #Scale the deposition to g m-2 mon-1 assuming 30 day month
        ext = ext*1.e3*86400.*30.
        print(np.min(ext[np.where(lat >=60)]),np.max(ext[np.where(lat >=60)]))
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
    clevs = np.arange(0,.1,.001)
    if varn == 'BC' or varn =='OC' or varn == 'NI':
        clevs = np.arange(0,.02,.0002)
    if varn == 'DU' or varn =='SS':
        clevs = np.arange(0,.5,.005)
    cf = ax.contourf(daysx, latsx, np.transpose(extf), clevs, cmap='Spectral_r', extend='both')

    cbar1=plt.colorbar(cf, ax=ax, orientation='vertical', pad=0.1, extend="max")
    cbar1.ax.tick_params(labelsize=12)
    cbar1.set_label(label='%s Deposition [g m-2 mon-1]'%(varn),size=12)

    plt.tight_layout()
    print('plotting')
    fig.savefig('%s.2016_2020.%sdep.monthly.png'%(expid,varn.lower()))
    print('done')
    plt.close(fig)


