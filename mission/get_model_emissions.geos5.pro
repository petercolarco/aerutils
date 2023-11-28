  url = 'http://opendap.gsfc.nasa.gov:9090/dods/GEOS-5/TC4/0.5_deg/assim/tavg2d_aer_x'
  wanttime = ['01:30z1jul2007','22:30z24jul2007']
  ga_getvar, url, ['duem','ssem','suem','bcem','ocem'], $
                  varout, lon=lon, lat=lat, lev=lev, time=time, $
                  wantlon=wantlon, wantlat=wantlat, wanttime=wanttime, /save, $
                  ofile='geos5.emissions.nc', /bin, options='-mean '


end
