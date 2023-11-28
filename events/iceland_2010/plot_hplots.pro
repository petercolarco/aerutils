; Colarco, Sept. 2006
; Plot AOT from model diag files

  dates = '201004'+['14','15','16','17','18']

  for idates = 0, n_elements(dates)-1 do begin

  datewant0=dates[idates]
  datewant = datewant0 + ['00','23']
  dir = 'output/plots'
;  wantlat = ['10','85']
;  wantlon = ['-180','-100']
  wantlat = ['45','70']
  wantlon = ['-30','30']
  levelarray = [0.002,0.05,0.1,0.15,0.2,0.3,0.4,0.5,0.7,1,1.5]
  formatstr = '(f4.2)'


  urlo = 'MYD04_L2_051.ocn.d.ctl'
  urll = 'MYD04_L2_051.lnd.d.ctl'
  varwant = ['aodtau']
  wantlev = ['550']
  title   = 'MYD04 Total AOT [550 nm] valid '+datewant0
  ga_getvar, urlo, varwant, varouto, lon=lon, lat=lat, lev=lev, time=time, $
             wanttime=datewant, wantlon=wantlon, wantlat=wantlat, wantlev=wantlev, /noprint
  ga_getvar, urll, varwant, varoutl, lon=lon, lat=lat, lev=lev, time=time, $
             wanttime=datewant, wantlon=wantlon, wantlat=wantlat, wantlev=wantlev, /noprint
  a = where(varouto gt 1e14)
  if(a[0] ne -1) then varouto[a] = !values.f_nan
  a = where(varoutl lt 1e14)
  if(a[0] ne -1) then varouto[a] = varoutl[a]
  varouto = reform(varouto)
  nx = n_elements(lon)
  ny = n_elements(lat)
  varout = fltarr(nx,ny)
  for ix = 0, nx-1 do begin
   for iy = 0, ny-1 do begin
    varout[ix,iy] = mean(varouto[ix,iy,*],/nan)
   endfor
  endfor

  hplot, varout, lon, lat, title=title, dir=dir, image='MYD04'+datewant0, $
         levelarray=levelarray, formatstr='(f4.2)', /countries

  endfor

end
