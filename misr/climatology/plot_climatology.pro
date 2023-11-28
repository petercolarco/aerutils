  ga_getvar,'misr.ctl', 'aodtau', aodmodis, lon=lon, lat=lat, lev=lev, $
   time=time, wantlev=558., wanttime=['1','12']
  aodmodis = reform(aodmodis)

  aodmodel = 0
  modelvar = ['du001','du002','du003','du004','du005', $
              'ss001','ss002','ss003','ss004','ss005', $
              'so4','bcphilic','bcphobic','ocphilic','ocphobic']
  plotend = '.all.misr.ps'
  for ibin = 0, 14 do begin
   ibinstr = '00'+strcompress(string(ibin),/rem)
   ga_getvar,'model.ctl', modelvar[ibin], aodin, lon=lon, lat=lat, lev=lev, $
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
  dx = 1.25
  dy = 1.

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
