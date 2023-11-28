; Colarco, Sept. 2006
; Plot AOT from model diag files

  datewant=['16:30z29jul2007']
  filetag = '1630z29jul2007'
  dir = 'p20070729/20070727_00z'
  wantlat = ['-5','25']
  wantlon = ['-100','-40']
  levelarray = [0.002,0.05,0.1,0.15,0.2,0.3,0.4,0.5,0.7,1,1.5]
  formatstr = '(f4.2)'

  url = 'http://opendap.gsfc.nasa.gov:9090/dods/GEOS-5/TC4/0.5_deg/fcast/tavg2d_aer_x.latest'
  varwant = ['suexttau']
  title   = 'GEOS-5 Sulfate AOT [550 nm] valid '+datewant
  ga_getvar, url, varwant, varout, lon=lon, lat=lat, lev=lev, time=time, $
                           wanttime=datewant, wantlon=wantlon, wantlat=wantlat,/noprint
  hplot, varout, lon, lat, title=title, dir=dir, image='aot_sulfate_'+filetag, $
         levelarray=levelarray, formatstr='(f4.2)'


  url = 'http://opendap.gsfc.nasa.gov:9090/dods/GEOS-5/TC4/0.5_deg/fcast/tavg2d_aer_x.latest'
  varwant = ['ocexttau','bcexttau']
  title   = 'GEOS-5 Carbonaceous AOT [550 nm] valid '+datewant
  ga_getvar, url, varwant, varout, lon=lon, lat=lat, lev=lev, time=time, $
                           wanttime=datewant, wantlon=wantlon, wantlat=wantlat,/noprint
  hplot, varout, lon, lat, title=title, dir=dir, image='aot_carbon_'+filetag, $
         levelarray=levelarray, formatstr='(f4.2)'


  url = 'http://opendap.gsfc.nasa.gov:9090/dods/GEOS-5/TC4/0.5_deg/fcast/tavg2d_aer_x.latest'
  varwant = ['ssexttau']
  title   = 'GEOS-5 Seasalt AOT [550 nm] valid '+datewant
  ga_getvar, url, varwant, varout, lon=lon, lat=lat, lev=lev, time=time, $
                           wanttime=datewant, wantlon=wantlon, wantlat=wantlat,/noprint
  hplot, varout, lon, lat, title=title, dir=dir, image='aot_seasalt_'+filetag, $
         levelarray=levelarray, formatstr='(f4.2)'


  url = 'http://opendap.gsfc.nasa.gov:9090/dods/GEOS-5/TC4/0.5_deg/fcast/tavg2d_aer_x.latest'
  varwant = ['duexttau','ssexttau','ocexttau','bcexttau','suexttau']
  title   = 'GEOS-5 AOT [550 nm] valid '+datewant
  ga_getvar, url, varwant, varout, lon=lon, lat=lat, lev=lev, time=time, $
                           wanttime=datewant, wantlon=wantlon, wantlat=wantlat,/noprint
  hplot, varout, lon, lat, title=title, dir=dir, image='aot_'+filetag, $
         levelarray=levelarray, formatstr='(f4.2)'


  url = 'http://opendap.gsfc.nasa.gov:9090/dods/GEOS-5/TC4/0.5_deg/fcast/tavg2d_aer_x.latest'
  varwant = ['duexttau']
  title   = 'GEOS-5 Dust AOT [550 nm] valid '+datewant
  ga_getvar, url, varwant, varout, lon=lon, lat=lat, lev=lev, time=time, $
                           wanttime=datewant, wantlon=wantlon, wantlat=wantlat,/noprint
  hplot, varout, lon, lat, title=title, dir=dir, image='aot_dust_'+filetag, $
         levelarray=levelarray, formatstr='(f4.2)'



  url = 'http://opendap.gsfc.nasa.gov:9090/dods/GEOS-5/TC4/0.5_deg/fcast/tavg3d_chm_p.latest'
  varwant = ['co']
  wantlev = ['500']
  title   = 'GEOS-5 CO [ppbv] at 500 hPa valid '+datewant
  scalefac = 1.e9
  levelarray = 50+findgen(11)*10
  ga_getvar, url, varwant, varout, lon=lon, lat=lat, lev=lev, time=time, $
             wantlev=wantlev, wanttime=datewant, wantlon=wantlon, wantlat=wantlat,/noprint
  hplot, varout, lon, lat, title=title, dir=dir, image='co500_'+filetag, $
         scalefac=scalefac, levelarray=levelarray, formatstr='(i3)'



  url = 'http://opendap.gsfc.nasa.gov:9090/dods/GEOS-5/TC4/0.5_deg/fcast/tavg3d_chm_p.latest'
  varwant = ['co']
  wantlev = ['700']
  title   = 'GEOS-5 CO [ppbv] at 700 hPa valid '+datewant
  scalefac = 1.e9
  levelarray = 50+findgen(11)*10
  ga_getvar, url, varwant, varout, lon=lon, lat=lat, lev=lev, time=time, $
             wantlev=wantlev, wanttime=datewant, wantlon=wantlon, wantlat=wantlat,/noprint
  hplot, varout, lon, lat, title=title, dir=dir, image='co700_'+filetag, $
         scalefac=scalefac, levelarray=levelarray, formatstr='(i3)'



  url = 'http://opendap.gsfc.nasa.gov:9090/dods/GEOS-5/TC4/0.5_deg/fcast/tavg3d_chm_p.latest'
  varwant = ['co']
  wantlev = ['850']
  title   = 'GEOS-5 CO [ppbv] at 850 hPa valid '+datewant
  scalefac = 1.e9
  levelarray = 50+findgen(11)*10
  ga_getvar, url, varwant, varout, lon=lon, lat=lat, lev=lev, time=time, $
             wantlev=wantlev, wanttime=datewant, wantlon=wantlon, wantlat=wantlat,/noprint
  hplot, varout, lon, lat, title=title, dir=dir, image='co850_'+filetag, $
         scalefac=scalefac, levelarray=levelarray, formatstr='(i3)'




end
