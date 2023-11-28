; Colarco, December, 2010
; Plot the model AOT for some geographic region similar to how
; satellite plotted


; MODIS climatology

  satids = ['MOD04','MYD04','MISR']
  nymd = '20070715'
  nhms = '120000'
  xrange = [-100,-20]
  yrange = [10,20]
  varwant = [ 'aodtau']

  for isat = 0, 2 do begin
  satid = satids[isat]

  filetemplate = '/misc/prc10/MODIS/Level3/'+satid+'/d/GRITAS/clim/'+ $
                 satid+'_L2_ocn.aero_tc8_051.qawt.clim%m2.nc4'
  if(satid eq 'MISR') then filetemplate = '/misc/prc10/MISR/Level3/d/GRITAS/clim/'+ $
                 satid+'_L2.aero_tc8_F12_0022.noqawt.clim%m2.nc4'
  filename = strtemplate(filetemplate,nymd,nhms)
  nc4readvar, filename, varwant, aotocn, /sum, lon=lon, lat=lat, lev=lev
  aotocn = aotocn[*,*,1]

  filetemplate = '/misc/prc10/MODIS/Level3/'+satid+'/d/GRITAS/clim/'+ $
                 satid+'_L2_lnd.aero_tc8_051.qawt3.clim%m2.nc4'
  if(satid eq 'MISR') then filetemplate = '/misc/prc10/MISR/Level3/d/GRITAS/clim/'+ $
                 satid+'_L2.aero_tc8_F12_0022.noqawt.clim%m2.nc4'
  filename = strtemplate(filetemplate,nymd,nhms)
  nc4readvar, filename, varwant, aotlnd, /sum, lon=lon, lat=lat, lev=lev
  aotlnd = aotlnd[*,*,1]

; Now average results together
  a = where(aotocn gt 1.e14)
  aotocn[a] = !values.f_nan
  a = where(aotlnd gt 1.e14)
  aotlnd[a] = !values.f_nan

  nx = n_elements(lon)
  ny = n_elements(lat)
  aotsat = fltarr(nx,ny)
  for i = 0L, nx*ny-1 do begin
   aotsat[i] = mean([aotocn[i],aotlnd[i]],/nan)
  endfor

; Now do the averaging
  x = where(lon ge min(xrange) and lon le max(xrange))
  y = where(lat ge min(yrange) and lat le max(yrange))
  n = n_elements(x)
  area, lon, lat, nx, ny, dx, dy, area, grid='d'
  aotsat = aotsat[x,*]
  aotsat = aotsat[*,y]
  area   = area[x,*]
  area   = area[*,y]
  lon    = lon[x]

  aot_    = fltarr(n)
  for ix = 0, n-1 do begin
   b = where(finite(aotsat[ix,*]) eq 1)
   if(b[0] eq -1) then begin
    aot_[ix] = !values.f_nan
   endif else begin
    aot_[ix] = total(aotsat[ix,b]*area[ix,b])/total(area[ix,b])
   endelse
  endfor

  if(isat eq 0) then aot = aot_
  if(isat gt 0) then aot = [aot,aot_]
  endfor ; satids
  aot = reform(aot,n,3)


; Now to get the extrema
  for isat = 0, 2 do begin
  satid = satids[isat]
  yyyy = strpad(indgen(10)+2000,1000)
  nyr  = n_elements(yyyy)
  for iyr = 0, nyr-1 do begin
  nymd = yyyy[iyr]+'0715'

  filetemplate = '/misc/prc10/MODIS/Level3/'+satid+'/d/GRITAS/Y%y4/M%m2/'+ $
                 satid+'_L2_ocn.aero_tc8_051.qawt.%y4%m2.nc4'
  if(satid eq 'MISR') then filetemplate = '/misc/prc10/MISR/Level3/d/GRITAS/Y%y4/M%m2/'+ $
                 satid+'_L2.aero_tc8_F12_0022.noqawt.%y4%m2.nc4'
  filename = strtemplate(filetemplate,nymd,nhms)
  nc4readvar, filename, varwant, aotocn, /sum, lon=lon, lat=lat, lev=lev
  aotocn = aotocn[*,*,1]

  filetemplate = '/misc/prc10/MODIS/Level3/'+satid+'/d/GRITAS/Y%y4/M%m2/'+ $
                 satid+'_L2_lnd.aero_tc8_051.qawt3.%y4%m2.nc4'
  if(satid eq 'MISR') then filetemplate = '/misc/prc10/MISR/Level3/d/GRITAS/Y%y4/M%m2/'+ $
                 satid+'_L2.aero_tc8_F12_0022.noqawt.%y4%m2.nc4'
  filename = strtemplate(filetemplate,nymd,nhms)
  nc4readvar, filename, varwant, aotlnd, /sum, lon=lon, lat=lat, lev=lev
  aotlnd = aotlnd[*,*,1]

; Now average results together
  a = where(aotocn gt 1.e14)
  aotocn[a] = !values.f_nan
  a = where(aotlnd gt 1.e14)
  aotlnd[a] = !values.f_nan

  nx = n_elements(lon)
  ny = n_elements(lat)
  aotsat = fltarr(nx,ny)
  for i = 0L, nx*ny-1 do begin
   aotsat[i] = mean([aotocn[i],aotlnd[i]],/nan)
  endfor

; Now do the averaging
  x = where(lon ge min(xrange) and lon le max(xrange))
  y = where(lat ge min(yrange) and lat le max(yrange))
  n = n_elements(x)
  area, lon, lat, nx, ny, dx, dy, area, grid='d'
  aotsat = aotsat[x,*]
  aotsat = aotsat[*,y]
  area   = area[x,*]
  area   = area[*,y]
  lon    = lon[x]

  aot_    = fltarr(n)
  for ix = 0, n-1 do begin
   b = where(finite(aotsat[ix,*]) eq 1)
   if(b[0] eq -1) then begin
    aot_[ix] = !values.f_nan
   endif else begin
    aot_[ix] = total(aotsat[ix,b]*area[ix,b])/total(area[ix,b])
   endelse
  endfor

  if(isat eq 0 and iyr eq 0) then aotall = aot_ else aotall = [aotall,aot_]

  endfor ; years
  endfor ; satids
  aotall = reform(aotall,n,nyr*3)

  set_plot, 'ps'
  device, file='./output/plots/aodtau550.clim.10_20n.ps', $
          /color, /helvetica, font_size=14, $
          xoff=.5, yoff=.5, xsize=16, ysize=12
  !p.font=0

  plot, lon, aot[*,0], /nodata, $
   xrange=xrange, xstyle=9, xtitle='longitude', $
   yrange=[0,0.8], ystyle=9, ytitle='AOT'
  polymaxmin, lon, aotall, fillcolor=208, color=208
  oplot, lon, aot[*,0], thick=6
  oplot, lon, aot[*,1], thick=6, color=200
  oplot, lon, aot[*,2], thick=6, color=80
  device, /close



end
