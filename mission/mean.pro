  aerurl = 'http://opendap.gsfc.nasa.gov:9090/dods/GEOS-5/TC4/0.5_deg/assim/tavg2d_aer_x'
  ga_getvar, aerurl, ['ssexttau','suexttau','ocexttau','bcexttau'], varval, $
   lon=lon, lat=lat, lev=lev, time=time, $
   wantlon=[-180,0], wantlat=[-10,40], wanttime=['12z8jul2007','12z14jul2007'], $
   /save, options='-mean', ofile='totexttau.20070708_20070714'

  aerurl = 'http://opendap.gsfc.nasa.gov:9090/dods/GEOS-5/TC4/0.5_deg/assim/tavg3d_chm_p'
  ga_getvar, aerurl, ['co'], varval, $
   lon=lon, lat=lat, lev=lev, time=time, $
   wantlon=[-140,0], wantlat=[-40,40], wantlev=[500], wanttime=['12z11jul2007','12z15jul2007'], $
   /save, options='-mean', ofile='co.20070711_20070715'

end
