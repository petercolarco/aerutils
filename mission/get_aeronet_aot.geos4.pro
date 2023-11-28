  url = 'http://opendap:9090/dods/GEOS-4/AeroChem/assim_met/chem_diag.sfc'

; la_parguera
  wantlat = 18.
  wantlon = -67.
  wanttime = ['01:30z1jul2007','22:30z22jul2007']
  ga_getvar, url, ['duexttau','ssexttau','suexttau','ocexttau','bcexttau'], $
                  varout, lon=lon, lat=lat, lev=lev, time=time, $
                  wantlon=wantlon, wantlat=wantlat, wanttime=wanttime, /save, $
                  ofile='geos4.la_parguera.nc'

; guadeloup
  wantlat = 16.3
  wantlon = -61.5
  ga_getvar, url, ['duexttau','ssexttau','suexttau','ocexttau','bcexttau'], $
                  varout, lon=lon, lat=lat, lev=lev, time=time, $
                  wantlon=wantlon, wantlat=wantlat, wanttime=wanttime, /save, $
                  ofile='geos4.guadeloup.nc';

; capo_verde
  wantlat = 16.75
  wantlon = -23.
  ga_getvar, url, ['duexttau','ssexttau','suexttau','ocexttau','bcexttau'], $
                  varout, lon=lon, lat=lat, lev=lev, time=time, $
                  wantlon=wantlon, wantlat=wantlat, wanttime=wanttime, /save, $
                  ofile='geos4.capo_verde.nc'

; tuxtla_gutierrez
  wantlat = 16.75
  wantlon = -93.
  ga_getvar, url, ['duexttau','ssexttau','suexttau','ocexttau','bcexttau'], $
                  varout, lon=lon, lat=lat, lev=lev, time=time, $
                  wantlon=wantlon, wantlat=wantlat, wanttime=wanttime, /save, $
                  ofile='geos4.tuxtla_gutierrez.nc'

end
