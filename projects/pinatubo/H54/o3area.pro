; Plot the ozone hole area (o3 < 220 DU)
  lat2 = 1
  area, lon, lat, nx, ny, dx, dy, area, grid='c', lat2=lat2

  expid = 'sc'
  filetemplate = expid+'.geosgcm_surf.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  a = where(nymd lt '19901201')
  filename = filename[a]
  nc4readvar, filename, 'scto3', o3sc, lon=lon, lat=lat, time=time

  expid = 'scspin'
  filetemplate = expid+'.geosgcm_surf.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  a = where(nymd lt '19901201')
  filename = filename[a]
  nc4readvar, filename, 'scto3', o3, lon=lon, lat=lat, time=time

  expid = 'scspinc'
  filetemplate = expid+'.geosgcm_surf.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  a = where(nymd lt '19901201')
  filename = filename[a]
  nc4readvar, filename, 'scto3', o3c, lon=lon, lat=lat, time=time

  expid = 'scv7'
  filetemplate = expid+'.geosgcm_surf.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  a = where(nymd lt '19901201')
  filename = filename[a]
  nc4readvar, filename, 'scto3', o3scv7, lon=lon, lat=lat, time=time

  expid = 'scspinv7'
  filetemplate = expid+'.geosgcm_surf.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  a = where(nymd lt '19901201')
  filename = filename[a]
  nc4readvar, filename, 'scto3', o3v7, lon=lon, lat=lat, time=time

  expid = 'scspinv7c'
  filetemplate = expid+'.geosgcm_surf.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  a = where(nymd lt '19901201')
  filename = filename[a]
  nc4readvar, filename, 'scto3', o3v7c, lon=lon, lat=lat, time=time


; Minimum ozone value
  nt = n_elements(time)
  a = where(lat lt -60)
  o3sc_ = reform(o3sc[*,a,*],nx*n_elements(a)*1L,nt)
  o3_ = reform(o3[*,a,*],nx*n_elements(a)*1L,nt)
  o3c_ = reform(o3c[*,a,*],nx*n_elements(a)*1L,nt)
  o3scv7_ = reform(o3scv7[*,a,*],nx*n_elements(a)*1L,nt)
  o3v7_ = reform(o3v7[*,a,*],nx*n_elements(a)*1L,nt)
  o3v7c_ = reform(o3v7c[*,a,*],nx*n_elements(a)*1L,nt)
  o3minsc = min(o3sc_,dim=1)
  o3min = min(o3_,dim=1)
  o3minc = min(o3c_,dim=1)
  o3minscv7 = min(o3scv7_,dim=1)
  o3minv7 = min(o3v7_,dim=1)
  o3minv7c = min(o3v7c_,dim=1)

; Find the ozone hole area
  o3sc_ = reform(o3sc,nx*ny*1L,nt)
  o3_ = reform(o3,nx*ny*1L,nt)
  o3c_ = reform(o3c,nx*ny*1L,nt)
  o3scv7_ = reform(o3scv7,nx*ny*1L,nt)
  o3v7_ = reform(o3v7,nx*ny*1L,nt)
  o3v7c_ = reform(o3v7c,nx*ny*1L,nt)
  o3areasc = fltarr(nt)
  o3area = fltarr(nt)
  o3areac = fltarr(nt)
  o3areascv7 = fltarr(nt)
  o3areav7 = fltarr(nt)
  o3areav7c = fltarr(nt)
  for it = 0, nt-1 do begin
   a = where(lat2 lt -60 and o3sc_[*,it] lt 220.)
   if(a[0] ne -1) then o3areasc[it] = total(area[a])  ; m2
   a = where(lat2 lt -60 and o3_[*,it] lt 220.)
   if(a[0] ne -1) then o3area[it] = total(area[a])  ; m2
   a = where(lat2 lt -60 and o3c_[*,it] lt 220.)
   if(a[0] ne -1) then o3areac[it] = total(area[a])  ; m2
   a = where(lat2 lt -60 and o3scv7_[*,it] lt 220.)
   if(a[0] ne -1) then o3areascv7[it] = total(area[a])  ; m2
   a = where(lat2 lt -60 and o3v7_[*,it] lt 220.)
   if(a[0] ne -1) then o3areav7[it] = total(area[a])  ; m2
   a = where(lat2 lt -60 and o3v7c_[*,it] lt 220.)
   if(a[0] ne -1) then o3areav7c[it] = total(area[a])  ; m2
  endfor

; Plot
  set_plot, 'ps'
  device, file='o3area.new.ps', /helvetica, font_size=14, /color, $
   xoff=.5, yoff=.5, xsize=32, ysize=14
  !p.font=0
  !p.multi=[0,2,1]
  x = findgen(nt)/8.
  x = findgen(nt)
  plot, x, o3area/1e12, yrange=[0,30], ystyle=1, /nodata, $
   ytitle='ozone hole area [10^6 km^2]', $
   xtitle='days since 1 sep 1990', $
;   position=[.12,.1,.88,.95], xrange=[0,90], xstyle=1
   xrange=[0,90], xstyle=1
  loadct, 39
  oplot, x, o3areasc/1e12, thick=6, lin=1, color=84
  oplot, x, o3area/1e12, thick=6, lin=1
  oplot, x, o3areac/1e12, thick=6, color=254, lin=1
  oplot, x, o3areascv7/1e12, thick=6, color=84
  oplot, x, o3areav7/1e12, thick=6
  oplot, x, o3areav7c/1e12, thick=6, color=254

  plot, x, o3area/1e12, yrange=[100,250], ystyle=1, /nodata, $
   ytitle='minimum total column ozone [du]', $
   xtitle='days since 1 sep 1990', $
;   position=[.12,.1,.88,.95], xrange=[0,90], xstyle=1
   xrange=[0,90], xstyle=1
  loadct, 39
  oplot, x, o3minsc, thick=6, lin=1, color=84
  oplot, x, o3min, thick=6, lin=1
  oplot, x, o3minc, thick=6, lin=1, color=254
  oplot, x, o3minscv7, thick=6, color=84
  oplot, x, o3minv7, thick=6
  oplot, x, o3minv7c, thick=6, color=254

  loadct, 0
  plots, [20,30], 240, thick=6, color=120
  plots, [20,30], 232, thick=6, color=120, lin=1
  loadct, 39
  plots, [20,30], 224, thick=6
  plots, [20,30], 216, thick=6, color=254
  plots, [20,30], 208, thick=6, color=84
  xyouts, 31, 239, 'Ice fall velocity corrected', chars=.75
  xyouts, 31, 231, 'Ice fall velocity NOT corrected', chars=.75
  xyouts, 31, 223, 'GOCART is AERO_PROVIDER', chars=.75
  xyouts, 31, 215, 'CARMA is AERO_PROVIDER', chars=.75
  xyouts, 31, 207, 'Climatological surface area', chars=.75
  

  device, /close

end
