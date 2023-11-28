  url = 'http://opendap:9090/dods/GEOS-4/AeroChem/assim_met/chem_diag.sfc'

  wanttime = ['01:30z1jul2007','22:30z24jul2007']
  ga_getvar, url, ['duem','ssem','suem','bcem','ocem'], $
                  varout, lon=lon, lat=lat, lev=lev, time=time, $
                  wantlon=wantlon, wantlat=wantlat, wanttime=wanttime, /save, $
                  ofile='geos4.emissions.nc', /bin, options='-mean '


end
