; Colarco, Sept. 2006
; Plot AOT from model diag files

  datewant='2010042300'
  fcast = '2010042300'
  flight = 'b6.6_03_10'
  ghawktrack = 'output/tracks/glopac_'+flight+'_path_pfister.txt'
  filetag = flight+'.v'+datewant+'.asm'
  dir = 'output/plots'
  wantlat = ['10','85']
  wantlon = ['-180','-80']
;  wantlat = ['10','65']
;  wantlon = ['-180','-115']
  levelarray = [0.002,0.05,0.1,0.15,0.2,0.3,0.4,0.5,0.7,1,1.5]
  formatstr = '(f4.2)'


  url = 'sfc.ddf'
  varwant = ['duexttau','bcexttau','ocexttau','ssexttau','suexttau']
  title   = 'GEOS-5 Total AOT [550 nm] valid '+datewant
  ga_getvar, url, varwant, varout, lon=lon, lat=lat, lev=lev, time=time, $
                           wanttime=datewant, wantlon=wantlon, wantlat=wantlat,/noprint
  hplot, varout, lon, lat, title=title, dir=dir, image='aot_total_'+filetag, $
         levelarray=levelarray, formatstr='(f4.2)', datewant=datewant, $
         ghawk=ghawktrack, datadir=datadir

  varwant = ['suexttau']
  title   = 'GEOS-5 Sulfate AOT [550 nm] valid '+datewant
  ga_getvar, url, varwant, varout, lon=lon, lat=lat, lev=lev, time=time, $
                           wanttime=datewant, wantlon=wantlon, wantlat=wantlat,/noprint
  hplot, varout, lon, lat, title=title, dir=dir, image='aot_sulfate_'+filetag, $
         levelarray=levelarray, formatstr='(f4.2)', datewant=datewant, $
         ghawk=ghawktrack, datadir=datadir

  varwant = ['duexttau']
  title   = 'GEOS-5 Dust AOT [550 nm] valid '+datewant
  ga_getvar, url, varwant, varout, lon=lon, lat=lat, lev=lev, time=time, $
                           wanttime=datewant, wantlon=wantlon, wantlat=wantlat,/noprint
  hplot, varout, lon, lat, title=title, dir=dir, image='aot_dust_'+filetag, $
         levelarray=levelarray, formatstr='(f4.2)', datewant=datewant, $
         ghawk=ghawktrack, datadir=datadir

  varwant = ['ssexttau']
  title   = 'GEOS-5 Seasalt AOT [550 nm] valid '+datewant
  ga_getvar, url, varwant, varout, lon=lon, lat=lat, lev=lev, time=time, $
                           wanttime=datewant, wantlon=wantlon, wantlat=wantlat,/noprint
  hplot, varout, lon, lat, title=title, dir=dir, image='aot_seasalt_'+filetag, $
         levelarray=levelarray, formatstr='(f4.2)', datewant=datewant, $
         ghawk=ghawktrack, datadir=datadir

  varwant = ['ocexttau','bcexttau']
  title   = 'GEOS-5 Carbonaceous AOT [550 nm] valid '+datewant
  ga_getvar, url, varwant, varout, lon=lon, lat=lat, lev=lev, time=time, $
                           wanttime=datewant, wantlon=wantlon, wantlat=wantlat,/noprint
  hplot, varout, lon, lat, title=title, dir=dir, image='aot_carbon_'+filetag, $
         levelarray=levelarray, formatstr='(f4.2)', datewant=datewant, $
         ghawk=ghawktrack, datadir=datadir
stop


  url = 'prsasm.ddf'
  varwant = ['o3']
  wantlev = ['70']
  title   = 'GEOS-5 Ozone [ppmv] at 70 hPa valid '+datewant
  scalefac = 28.97/48.*1e6
  levelarray = [.25,.5,.75,1.,1.25,1.5,1.75,2,2.5,3,3.5]
  ga_getvar, url, varwant, varout, lon=lon, lat=lat, lev=lev, time=time, $
             wantlev=wantlev, wanttime=datewant, wantlon=wantlon, wantlat=wantlat,/noprint
  hplot, varout, lon, lat, title=title, dir=dir, image='o3_70hPa_'+filetag, $
         levelarray=levelarray, formatstr='(f4.2)', datewant=datewant, $
         ghawk=ghawktrack, datadir=datadir, scalefac=scalefac


  varwant = ['qv']
  wantlev = ['70']
  title   = 'GEOS-5 Water Vapor [ppmv] at 70 hPa valid '+datewant
  scalefac = 28.97/18.*1e6
  levelarray = findgen(11)*.2+3
  ga_getvar, url, varwant, varout, lon=lon, lat=lat, lev=lev, time=time, $
             wantlev=wantlev, wanttime=datewant, wantlon=wantlon, wantlat=wantlat,/noprint
  hplot, varout, lon, lat, title=title, dir=dir, image='qv_70hPa_'+filetag, $
         levelarray=levelarray, formatstr='(f3.1)', datewant=datewant, $
         ghawk=ghawktrack, datadir=datadir, scalefac=scalefac


  varwant = ['epv']
  wantlev = ['70']
  title   = 'GEOS-5 EPV at 70 hPa valid '+datewant
  scalefac = 1.e5
  levelarray = findgen(11)*.25+ .25
  ga_getvar, url, varwant, varout, lon=lon, lat=lat, lev=lev, time=time, $
             wantlev=wantlev, wanttime=datewant, wantlon=wantlon, wantlat=wantlat,/noprint
  hplot, varout, lon, lat, title=title, dir=dir, image='epv_70hPa_'+filetag, $
         levelarray=levelarray, formatstr='(f3.1)', datewant=datewant, $
         ghawk=ghawktrack, datadir=datadir, scalefac=scalefac


  varwant = ['epv']
  wantlev = ['150']
  title   = 'GEOS-5 EPV at 150 hPa valid '+datewant
  scalefac = 1.e5
  levelarray = findgen(11)*.25+.25
  ga_getvar, url, varwant, varout, lon=lon, lat=lat, lev=lev, time=time, $
             wantlev=wantlev, wanttime=datewant, wantlon=wantlon, wantlat=wantlat,/noprint
  hplot, varout, lon, lat, title=title, dir=dir, image='epv_150hPa_'+filetag, $
         levelarray=levelarray, formatstr='(f3.1)', datewant=datewant, $
         ghawk=ghawktrack, datadir=datadir, scalefac=scalefac


  url = 'prschm.ddf'
  varwant = ['co']
  wantlev = ['70']
  title   = 'GEOS-5 CO [ppbv] at 70 hPa valid '+datewant
  scalefac = 1e9
  levelarray = [2,4,6,8,10,15,20,30,40,50,60]
  ga_getvar, url, varwant, varout, lon=lon, lat=lat, lev=lev, time=time, $
             wantlev=wantlev, wanttime=datewant, wantlon=wantlon, wantlat=wantlat,/noprint
  hplot, varout, lon, lat, title=title, dir=dir, image='co_70hPa_'+filetag, $
         levelarray=levelarray, formatstr='(f4.1)', datewant=datewant, $
         ghawk=ghawktrack, datadir=datadir, scalefac=scalefac


  url = 'prstag.ddf'
  varwant = ['cfc12strat','cfc12trop']
  wantlev = ['70']
  title   = 'GEOS-5 CFC-12 [pptv] at 70 hPa valid '+datewant
  scalefac = 1e12
  levelarray = findgen(11)*30+300
  ga_getvar, url, varwant, varout, lon=lon, lat=lat, lev=lev, time=time, $
             wantlev=wantlev, wanttime=datewant, wantlon=wantlon, wantlat=wantlat,/noprint
  hplot, varout, lon, lat, title=title, dir=dir, image='cfc12_70hPa_'+filetag, $
         levelarray=levelarray, formatstr='(i3)', datewant=datewant, $
         ghawk=ghawktrack, datadir=datadir, scalefac=scalefac




end
