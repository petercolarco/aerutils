  ext_ = 1
  for i = 1, 8 do begin
   filename = 'c180R_v10p23p0_sc.inst2d_hwl_x.argos'+string(i,format='(i1)')+'.trj.nc'
   read_argos, filename, lon_, lat_, time_, sza_, $
               tau=ext_
  
;  Retain only the first day
   if(i eq 1) then begin
    a = where(strmid(time_,5,2) eq '07')
    ext = ext_[a]
    lon = lon_[a]
    lat = lat_[a]
    sza = sza_[a]
    time = time_[a]
   endif else begin
    a = where(strmid(time_,5,2) eq '07')
    ext = [ext,ext_[a]]
    lon = [lon,lon_[a]]
    lat = [lat,lat_[a]]
    sza = [sza,sza_[a]]
    time = [time,time_[a]]
   endelse
  endfor

; Keep only daylight
  a = where(sza le 88.)
  ext = ext[a]
  lon = lon[a]
  lat = lat[a]
  sza = sza[a]
  time = time[a]
  npts = n_elements(a)

; Make an output grid for the plot
  nx = 72
  ny = 46
  dx = 5
  dy = 4.
  lono = -180.+dx/2. + findgen(nx)*dx
  lato = -90.+ findgen(ny)*dy

  ix = interpol(indgen(nx),lono,lon)
  iy = interpol(indgen(ny),lato,lat)
  ix = fix(ix+0.5)
  iy = fix(iy+0.5)
  a = where(ix ge nx)
  if(a[0] ne -1) then ix[a] = 0

; Fill the grid
  extt = fltarr(31,ny)

  for it = 0, 30 do begin

  exto = make_array(nx,ny,val=0.)
  numo = make_array(nx,ny,val=0L)
  strit = string(it+1,format='(i02)')
  a = where(strmid(time,8,2) eq strit)
  for ipts = 0, n_elements(a)-1 do begin
   exto[ix[a[ipts]],iy[a[ipts]]] = exto[ix[a[ipts]],iy[a[ipts]]] + ext[a[ipts]]
   numo[ix[a[ipts]],iy[a[ipts]]] = numo[ix[a[ipts]],iy[a[ipts]]] + 1
  endfor
  a = where(numo gt 0)
  exto[a] = exto[a]/numo[a]
  a = where(numo eq 0)
  if(a[0] ne -1) then exto[a] = !values.f_nan
  extt[it,*] = mean(exto,dim=1,/nan)

  endfor


; Make a plot
  set_plot, 'ps'
  device, file = 'plot_tau_time.all.ps', /color, /helvetica, font_size=14, $
   xsize=16, ysize=12
  !p.font=0


  plot, indgen(10), /nodata, position=[.1,.2,.95,.95], $
   xrange=[0,32], xticks=32, xtickn=[' ',string(findgen(31)+1,format='(i02)'), ' '], $
   yrange=[-60,90], yticks=5, ytitle='Latitude', xminor=1, ystyle=1, charsize=.75
  loadct, 72
  levels = findgen(10)*0.005
  levels[0] = 1.e-12
  colors = reverse(findgen(10)*25+25)
  plotgrid, extt, levels, colors, findgen(31)+1, lato, 1., dy, /map

  loadct, 0
  makekey, .15, .08, .775, .05, 0, -0.04, align=0, charsize=.75, $
   colors=make_array(n_elements(levels),val=0), labels=string(levels,format='(f5.3)')

  loadct, 72
  makekey, .15, .08, .775, .05, 0, -0.04, $
   colors=colors, labels=make_array(n_elements(levels),val=' ')

  loadct, 0

  device, /close
end
