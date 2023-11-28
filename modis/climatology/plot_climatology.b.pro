  ga_getvar,'modis_b.ctl', 'aodtau', aodmodis, lon=lon, lat=lat, lev=lev, $
   time=time, wantlev=550., wanttime=['1','12']
  aodmodis = reform(aodmodis)
  lon = shift(lon,72)
  aodmodis = shift(aodmodis,72,0,0)

  aodmodel = 0
  modelvar = ['du001','du002','du003','du004','du005', $
              'ss001','ss002','ss003','ss004','ss005', $
              'so4','bcphilic','bcphobic','ocphilic','ocphobic']
  plotend = '.b.ps'
  for ibin = 0, 4 do begin
   ibinstr = '00'+strcompress(string(ibin),/rem)
   ga_getvar,'model_b.ctl', modelvar[ibin], aodin, lon=lon, lat=lat, lev=lev, $
    time=time, wantlev=5.5e-7, wanttime=['1','12']
   aodmodel = aodmodel+aodin
  endfor
  aodmodel = reform(aodmodel)

; Seasonalize it all
  a = where(aodModel gt 1e14)
  if(a[0] ne -1) then aodModel[a] = !values.f_nan
  a = where(aodModis gt 1e14)
  aodModis[a] = !values.f_nan

  nx = n_elements(lon)
  ny = n_elements(lat)
  summerModel = fltarr(nx,ny)
  winterModel = fltarr(nx,ny)
  autumnModel = fltarr(nx,ny)
  springModel = fltarr(nx,ny)
  summerModis = fltarr(nx,ny)
  winterModis = fltarr(nx,ny)
  autumnModis = fltarr(nx,ny)
  springModis = fltarr(nx,ny)
  for ix = 0, nx-1 do begin
   for iy = 0, ny-1 do begin
    summerModel[ix,iy] = mean(aodModel[ix,iy,5:7],/nan)
    autumnModel[ix,iy] = mean(aodModel[ix,iy,8:10],/nan)
    winterModel[ix,iy] = mean([aodModel[ix,iy,11],aodModel[ix,iy,0],aodModel[ix,iy,1]],/nan)
    springModel[ix,iy] = mean(aodModel[ix,iy,2:4],/nan)

    summerModis[ix,iy] = mean(aodModis[ix,iy,5:7],/nan)
    autumnModis[ix,iy] = mean(aodModis[ix,iy,8:10],/nan)
    winterModis[ix,iy] = mean([aodModis[ix,iy,11],aodModis[ix,iy,0],aodModis[ix,iy,1]],/nan)
    springModis[ix,iy] = mean(aodModis[ix,iy,2:4],/nan)
   endfor
  endfor

; Now plot
  lat[0] = -89.5
  lat[ny-1] = 89.5
  dx = 2.5
  dy = 2.

  set_plot, 'ps'
  device, file='summer'+plotend, /color, /helvetica, font_size=14, $
    xoff=.5, yoff=.5, xsize=12, ysize=10
  !p.font=0
  seasonplot, summermodis, summermodel, lon, lat, dx, dy
  device, /close

  set_plot, 'ps'
  device, file='autumn'+plotend, /color, /helvetica, font_size=14, $
    xoff=.5, yoff=.5, xsize=12, ysize=10
  !p.font=0
  seasonplot, autumnmodis, autumnmodel, lon, lat, dx, dy
  device, /close

  set_plot, 'ps'
  device, file='winter'+plotend, /color, /helvetica, font_size=14, $
    xoff=.5, yoff=.5, xsize=12, ysize=10
  !p.font=0
  seasonplot, wintermodis, wintermodel, lon, lat, dx, dy
  device, /close

  set_plot, 'ps'
  device, file='spring'+plotend, /color, /helvetica, font_size=14, $
    xoff=.5, yoff=.5, xsize=12, ysize=10
  !p.font=0
  seasonplot, springmodis, springmodel, lon, lat, dx, dy
  device, /close

end
