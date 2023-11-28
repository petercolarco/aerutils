  url = 'http://opendap.gsfc.nasa.gov:9090/dods/GEOS-5/TC4/0.5_deg/assim/tavg2d_aer_x'

; la_parguera
  wantlat = 18.
  wantlon = -67.
  wanttime = ['1','178']
  ga_getvar, url, ['duexttau','ssexttau','suexttau','ocexttau','bcexttau'], $
                  varout, lon=lon, lat=lat, lev=lev, time=time, $
                  wantlon=wantlon, wantlat=wantlat, wanttime=wanttime, /save, $
                  ofile='geos5.la_parguerra.nc'

; guadeloup
  wantlat = 16.3
  wantlon = -61.5
  wanttime = ['1','178']
  ga_getvar, url, ['duexttau','ssexttau','suexttau','ocexttau','bcexttau'], $
                  varout, lon=lon, lat=lat, lev=lev, time=time, $
                  wantlon=wantlon, wantlat=wantlat, wanttime=wanttime, /save, $
                  ofile='geos5.guadeloup.nc'

; capo_verde
  wantlat = 16.75
  wantlon = -23.
  wanttime = ['1','178']
  ga_getvar, url, ['duexttau','ssexttau','suexttau','ocexttau','bcexttau'], $
                  varout, lon=lon, lat=lat, lev=lev, time=time, $
                  wantlon=wantlon, wantlat=wantlat, wanttime=wanttime, /save, $
                  ofile='geos5.capo_verde.nc'

; tuxtla_gutierrez
  wantlat = 16.75
  wantlon = -93.
  wanttime = ['1','178']
  ga_getvar, url, ['duexttau','ssexttau','suexttau','ocexttau','bcexttau'], $
                  varout, lon=lon, lat=lat, lev=lev, time=time, $
                  wantlon=wantlon, wantlat=wantlat, wanttime=wanttime, /save, $
                  ofile='geos5.tuxtla_gutierrez.nc'

end
