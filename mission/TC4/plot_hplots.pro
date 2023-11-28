; Colarco, Sept. 2006
; Plot AOT from model diag files

  wantlat = ['-85','85']
  wantlon = ['-175','175']
  levelarray = [0.002,0.05,0.1,0.15,0.2,0.3,0.4,0.5,0.7,1,1.5]
  formatstr = '(f4.2)'


; Make the model plot
  mdir = '/misc/prc10/colarco/tc4/d530_tc4_02/tau/Y2007/M07/'
  urlo = mdir + 'd530_tc4_02.inst2d_ext_x.total.MYD04_L2_ocn.aero_051.qawt.200707.hdf'
  urll = mdir + 'd530_tc4_02.inst2d_ext_x.total.MYD04_L2_lnd.aero_051.qawt.200707.hdf'
  urlb = mdir + 'd530_tc4_02.inst2d_ext_x.total.MYD04_L2_blu.aero_051.noqawt.200707.hdf'

  varwant = ['aodtau']
  wantlev = ['5.5e-7']
  title   = 'GEOS-5 Total AOT [550 nm] July 2007'
  ga_getvar, urlo, varwant, varouto, lon=lon, lat=lat, lev=lev, time=time, $
             wanttime=datewant, wantlon=wantlon, wantlat=wantlat, wantlev=wantlev, /noprint
  ga_getvar, urll, varwant, varoutl, lon=lon, lat=lat, lev=lev, time=time, $
             wanttime=datewant, wantlon=wantlon, wantlat=wantlat, wantlev=wantlev, /noprint
  ga_getvar, urlb, varwant, varoutb, lon=lon, lat=lat, lev=lev, time=time, $
             wanttime=datewant, wantlon=wantlon, wantlat=wantlat, wantlev=wantlev, /noprint
  a = where(varouto gt 1e14)
  if(a[0] ne -1) then varouto[a] = !values.f_nan
  a = where(varoutl lt 1e14)
  if(a[0] ne -1) then varouto[a] = varoutl[a]
  a = where(varoutb lt 1e14)
  if(a[0] ne -1) then varouto[a] = varoutb[a]
  varouto = reform(varouto)
  nx = n_elements(lon)
  ny = n_elements(lat)
  varout = fltarr(nx,ny)
  for ix = 0, nx-1 do begin
   for iy = 0, ny-1 do begin
    varout[ix,iy] = mean(varouto[ix,iy,*],/nan)
   endfor
  endfor

  hplot, varout, lon, lat, title=title, dir='./output/plots/', image='GEOS5.tc4.200707', $
         levelarray=levelarray, formatstr='(f4.2)', /countries


; Make the MODIS plot
  mdir = '/misc/prc10/MODIS/Level3/MYD04/d/GRITAS/Y2007/M07/
  urlo = mdir + 'MYD04_L2_ocn.aero_tc8_051.qawt.200707.nc4'
  urll = mdir + 'MYD04_L2_lnd.aero_tc8_051.qawt.200707.nc4'
  urlb = mdir + 'MYD04_L2_blu.aero_tc8_051.qawt3.200707.nc4'

  varwant = ['aodtau']
  wantlev = ['550']
  title   = 'MODIS Total AOT [550 nm] July 2007'
  ga_getvar, urlo, varwant, varouto, lon=lon, lat=lat, lev=lev, time=time, $
             wanttime=datewant, wantlon=wantlon, wantlat=wantlat, wantlev=wantlev, /noprint
  ga_getvar, urll, varwant, varoutl, lon=lon, lat=lat, lev=lev, time=time, $
             wanttime=datewant, wantlon=wantlon, wantlat=wantlat, wantlev=wantlev, /noprint
  ga_getvar, urlb, varwant, varoutb, lon=lon, lat=lat, lev=lev, time=time, $
             wanttime=datewant, wantlon=wantlon, wantlat=wantlat, wantlev=wantlev, /noprint
  a = where(varouto gt 1e14)
  if(a[0] ne -1) then varouto[a] = !values.f_nan
  a = where(varoutl lt 1e14)
  if(a[0] ne -1) then varouto[a] = varoutl[a]
  a = where(varoutb lt 1e14)
  if(a[0] ne -1) then varouto[a] = varoutb[a]
  varouto = reform(varouto)
  nx = n_elements(lon)
  ny = n_elements(lat)
  varout = fltarr(nx,ny)
  for ix = 0, nx-1 do begin
   for iy = 0, ny-1 do begin
    varout[ix,iy] = mean(varouto[ix,iy,*],/nan)
   endfor
  endfor

  hplot, varout, lon, lat, title=title, dir='./output/plots/', image='MYD04.tc4.200707', $
         levelarray=levelarray, formatstr='(f4.2)', /countries


end
