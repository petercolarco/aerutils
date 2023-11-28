; Get the emissions
  wantlat = [9,35]
  wantlon = [-18,35]
  nc4readvar, 'duem.nc', 'duem', duem, wantlat=wantlat, wantlon=wantlon, /sum, /tem, lon=lon, lat=lat

  area, lon_, lat_, nx, ny, dx, dy, area, grid='e'
  a = where(lon_ ge min(lon) and lon_ le max(lon))
  b = where(lat_ ge min(lat) and lat_ le max(lat))

  area = area[a,*]
  area = area[*,b]

  nx = n_elements(a)
  ny = n_elements(b)

; Generate the total dust load
  nt = n_elements(duem[0,0,*])
  nt = nt/8
  duemt = fltarr(nx,ny,nt)
  duemtt = fltarr(nt)
  for it = 0, nt-1 do begin
   duemt[*,*,it] = total(duem[*,*,it*8:it*8+7],3)/1e9*3.*3600.  ; Tg m-2 day-1
   duemtt[it]    = total(duemt[*,*,it]*area)
  endfor
stop
; Now make a daily mean
  nt_ = nt/8
  ducmtd = fltarr(nt_)
  duemtd = fltarr(nt_)
  for it = 0, nt_-1 do begin
   ducmtd[it] = mean(ducmt[it*8:it*8+7])
   duemtd[it] = mean(duemt[it*8:it*8+7])*8.
  endfor

; Make a plot
  x = findgen(nt_)-16
  x[where(x le 0)] = 31+x[where(x le 0)]
  xtickn = [string(x,format='(i2)'), '29']
  xtickn[1:45:2] = ' '
  x = findgen(nt_)-16
  set_plot, 'ps'
  device, file='ducmass.ps', /color, /helvetica, font_size=14, $
   xsize=24, ysize=12
  !p.font=0
  loadct, 39
  plot, x, ducmtd, /nodata, yrange=[5,13], ystyle=9, $
   xrange=[2,28], xstyle=1, xtickn= xtickn[18:45], xticks=nt_-18, $
   position=[.1,.15,.9, .95], xtitle='Day of June', ytitle='Loading [Tg]'
  oplot, x, ducmtd, thick=6, color=254
  axis, yaxis=1, yrange=[0,5], /save, ytitle='Emissions [Tg day!E-1!N]'
  oplot, x, duemtd, thick=6, color=0
  device, /close
end

