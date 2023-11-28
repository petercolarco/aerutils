; Colarco, Sept. 2006
; Plot AOT from model diag files

  dd = '28'
  datadir = '/Users/colarco/Desktop/TC4/data/'

  datewant=['16:30z'+dd+'jul2007']
  filetag = 'asm1630z'+dd+'jul2007'
  dir = 'p200707'+dd+'/asm'
  wantlat = ['-15','25']
  wantlon = ['-100','-40']
  levelarray = [0.002,0.05,0.1,0.15,0.2,0.3,0.4,0.5,0.7,1,1.5]
  formatstr = '(f4.2)'


  url = 'http://opendap.gsfc.nasa.gov:9090/dods/GEOS-5/TC4/0.5_deg/assim/tavg2d_aer_x'

  varwant = ['suexttau']
  title   = 'GEOS-5 Sulfate AOT [550 nm] valid '+datewant
  ga_getvar, url, varwant, varout, lon=lon, lat=lat, lev=lev, time=time, $
                           wanttime=datewant, wantlon=wantlon, wantlat=wantlat,/noprint
  hplot, varout, lon, lat, title=title, dir=dir, image='aot_sulfate_'+filetag, $
         levelarray=levelarray, formatstr='(f4.2)', $
         /dc8, datewant='200707'+dd, datadir=datadir


  varwant = ['ocexttau','bcexttau']
  title   = 'GEOS-5 Carbonaceous AOT [550 nm] valid '+datewant
  ga_getvar, url, varwant, varout, lon=lon, lat=lat, lev=lev, time=time, $
                           wanttime=datewant, wantlon=wantlon, wantlat=wantlat,/noprint
  hplot, varout, lon, lat, title=title, dir=dir, image='aot_carbon_'+filetag, $
         levelarray=levelarray, formatstr='(f4.2)', $
         /dc8, datewant='200707'+dd, datadir=datadir


  varwant = ['ssexttau']
  title   = 'GEOS-5 Seasalt AOT [550 nm] valid '+datewant
  ga_getvar, url, varwant, varout, lon=lon, lat=lat, lev=lev, time=time, $
                           wanttime=datewant, wantlon=wantlon, wantlat=wantlat,/noprint
  hplot, varout, lon, lat, title=title, dir=dir, image='aot_seasalt_'+filetag, $
         levelarray=levelarray, formatstr='(f4.2)', $
         /dc8, datewant='200707'+dd, datadir=datadir


  varwant = ['ssexttau','ocexttau','bcexttau','suexttau']
  title   = 'GEOS-5 AOT [550 nm] valid '+datewant
  ga_getvar, url, varwant, varout, lon=lon, lat=lat, lev=lev, time=time, $
                           wanttime=datewant, wantlon=wantlon, wantlat=wantlat,/noprint
  varwant = ['duexttau']
  title   = 'GEOS-5 AOT [550 nm] valid '+datewant
  ga_getvar, url, varwant, duexttau, lon=lon, lat=lat, lev=lev, time=time, $
                           wanttime=datewant, wantlon=wantlon, wantlat=wantlat,/noprint
  varout = varout + duexttau/2.2
  hplot, varout, lon, lat, title=title, dir=dir, image='aot_'+filetag, $
         levelarray=levelarray, formatstr='(f4.2)', $
         /dc8, datewant='200707'+dd, datadir=datadir


  varwant = ['duexttau']
  title   = 'GEOS-5 Dust AOT [550 nm] valid '+datewant
  ga_getvar, url, varwant, varout, lon=lon, lat=lat, lev=lev, time=time, $
                           wanttime=datewant, wantlon=wantlon, wantlat=wantlat,/noprint
  varout = varout/2.2
  hplot, varout, lon, lat, title=title, dir=dir, image='aot_dust_'+filetag, $
         levelarray=levelarray, formatstr='(f4.2)', $
         /dc8, datewant='200707'+dd, datadir=datadir


  varwant = ['ducmass']
  title   = 'GEOS-5 Dust Wet Removal Index '+datewant
  ga_getvar, url, varwant, ducmass, lon=lon, lat=lat, lev=lev, time=time, $
                           wanttime=datewant, wantlon=wantlon, wantlat=wantlat,/noprint
  varwant = ['duwt']
  ga_getvar, url, varwant, duwt, lon=lon, lat=lat, lev=lev, time=time, $
                           wanttime=datewant, wantlon=wantlon, wantlat=wantlat,/noprint, /template
  duwt = total(duwt,3)/2.2*1e9
  ducmass = ducmass/2.2
  varout = duwt*ducmass*1e4 / 3.
  hplot, varout, lon, lat, title=title, dir=dir, image='aot_duwt_'+filetag, $
         levelarray=levelarray, formatstr='(f4.2)', $
         /dc8, datewant='200707'+dd, datadir=datadir

  title   = 'GEOS-5 Dust Wet Removal Flux '+datewant
  varwant = ['duwt']
  ga_getvar, url, varwant, duwt, lon=lon, lat=lat, lev=lev, time=time, $
                           wanttime=datewant, wantlon=wantlon, wantlat=wantlat,/noprint, /template
  varout = total(duwt,3)/2.2*1e9
  hplot, varout, lon, lat, title=title, dir=dir, image='aot_duwtfx_'+filetag, $
         levelarray=levelarray, formatstr='(f4.2)', $
         /dc8, datewant='200707'+dd, datadir=datadir

  title   = 'GEOS-5 Dust Wet Removal Fraction '+datewant
  varwant = ['duwt']
  ga_getvar, url, varwant, duwt, lon=lon, lat=lat, lev=lev, time=time, $
                           wanttime=datewant, wantlon=wantlon, wantlat=wantlat,/noprint, /template
  varwant = ['dusd']
  ga_getvar, url, varwant, dusd, lon=lon, lat=lat, lev=lev, time=time, $
                           wanttime=datewant, wantlon=wantlon, wantlat=wantlat,/noprint, /template
  varwant = ['dudp']
  ga_getvar, url, varwant, dudp, lon=lon, lat=lat, lev=lev, time=time, $
                           wanttime=datewant, wantlon=wantlon, wantlat=wantlat,/noprint, /template
  duwtfr = total(duwt,3) / total(duwt+dusd+dudp,3)
  hplot, duwtfr, lon, lat, title=title, dir=dir, image='aot_duwtfr_'+filetag, $
         levelarray=levelarray, formatstr='(f4.2)', $
         /dc8, datewant='200707'+dd, datadir=datadir





  url = 'http://opendap.gsfc.nasa.gov:9090/dods/GEOS-5/TC4/0.5_deg/assim/tavg3d_chm_p'
  varwant = ['co']
  wantlev = ['500']
  title   = 'GEOS-5 CO [ppbv] at 500 hPa valid '+datewant
  scalefac = 1.e9
  levelarray = 50+findgen(11)*10
  ga_getvar, url, varwant, varout, lon=lon, lat=lat, lev=lev, time=time, $
             wantlev=wantlev, wanttime=datewant, wantlon=wantlon, wantlat=wantlat,/noprint
  hplot, varout, lon, lat, title=title, dir=dir, image='co500_'+filetag, $
         scalefac=scalefac, levelarray=levelarray, formatstr='(i3)', $
         /dc8, datewant='200707'+dd, datadir=datadir




end
