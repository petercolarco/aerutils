; Plot the ozone hole area (o3 < 220 DU)
  lat2 = 1
  area, lon, lat, nx, ny, dx, dy, area, grid='c', lat2=lat2

  expid = 'scspin'
  filetemplate = expid+'.tavg3d_carma_p.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  a = where(nymd lt '19901201')
  filename = filename[a]
  nc4readvar, filename, 'so4sarea', sug, lon=lon, lat=lat, time=time, wantlev=[100]
  nc4readvar, filename, 'susarea', suc, lon=lon, lat=lat, time=time, wantlev=[100]
  nc4readvar, filename, 'so4sarea', sug70, lon=lon, lat=lat, time=time, wantlev=[70]
  nc4readvar, filename, 'susarea', suc70, lon=lon, lat=lat, time=time, wantlev=[70]
  nc4readvar, filename, 'so4sarea', sug150, lon=lon, lat=lat, time=time, wantlev=[150]
  nc4readvar, filename, 'susarea', suc150, lon=lon, lat=lat, time=time, wantlev=[150]

; reform
  nt = n_elements(time)
  a = where(lat lt -60)
  b = where(lat2 lt -60)
  area = area[b]
  sug_ = reform(sug[*,a,*],nx*n_elements(a)*1L,nt)
  suc_ = reform(suc[*,a,*],nx*n_elements(a)*1L,nt)
  sug70_ = reform(sug70[*,a,*],nx*n_elements(a)*1L,nt)
  suc70_ = reform(suc70[*,a,*],nx*n_elements(a)*1L,nt)
  sug150_ = reform(sug150[*,a,*],nx*n_elements(a)*1L,nt)
  suc150_ = reform(suc150[*,a,*],nx*n_elements(a)*1L,nt)

; Find the ozone hole area
  sugt = mean(sug_,dim=1)
  suct = mean(suc_,dim=1)
  sugt70 = mean(sug70_,dim=1)
  suct70 = mean(suc70_,dim=1)
  sugt150 = mean(sug150_,dim=1)
  suct150 = mean(suc150_,dim=1)
stop
; Plot
  set_plot, 'ps'
  device, file='o3area.ps', /helvetica, font_size=14, /color, $
   xoff=.5, yoff=.5, xsize=16, ysize=14
  !p.font=0
  x = findgen(nt)/8.
  x = findgen(nt)
  plot, x, o3area/1e12, yrange=[0,20], ystyle=9, /nodata, $
   ytitle='ozone hole area [10^6 km^2]', $
   xtitle='days since 1 sep 1990', $
   position=[.12,.1,.88,.95], xrange=[0,90], xstyle=1
  loadct, 39
  oplot, x, o3area/1e12, thick=6
  oplot, x, o3areav7/1e12, thick=6, color=254
  oplot, x, o3areav7c/1e12, thick=6, color=80
  axis, yaxis=1, yrange=[100,250], /save, ytitle='minimum ozone value [du]'
  oplot, x, o3min, thick=6, lin=2
  oplot, x, o3minv7, thick=6, lin=2, color=254
  oplot, x, o3minv7c, thick=6, lin=2, color=80
  device, /close

end
