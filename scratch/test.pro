  fileinp = '/misc/prc10/GEOS5.0/fortest/tavg2d_aer_x/Y1999/M11/fortest.tavg2d_aer_x.monthly.199911.nc4'
;  fileinp = 'fortest.tavg2d_aer_x.ctl'
  ga_getvar, fileinp, 'duexttau', duexttau, lon=lon, lat=lat, time=time

  fileinp = '/misc/prc10/MODIS/Level3/MOD04/b/GRITAS/Y2001/M01/MOD04_L2_ocn.aero_tc8_005.qawt.20010101.nc4'
  ga_getvar, fileinp, 'aodtau', aodtau, lon=lon, lat=lat, time=time, lev=lev
