; Get a grid
  area, lon, lat, nx, ny, dx, dy, area, grid='nr'

  regstr = ['sam','saf','naf','nrv','igp','chn','sea','npac']
  lon0 = [-75,-15,-30, 30, 75, 100,  95, 135]
  lon1 = [-45, 35,-15, 36, 95, 125, 110, 165]
  lat0 = [-20,-20, 10, 22, 20,  25,  10,  30]
  lat1 = [  0,  0, 30, 32, 30,  42,  25,  55]
  nreg = n_elements(lon0)
  ymax   = [0.3,.6,.5,.3,.5,1,.6,.4]

  for ireg = 0, nreg-1 do begin

  a = where(lon ge lon0[ireg] and lon le lon1[ireg])
  b = where(lat ge lat0[ireg] and lat le lat1[ireg])

  area_ = area[a,*]
  area_ = area_[*,b]

  ddf = 'full.c1440.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'totexttau', aot
  aot_ = aot[a,*,*]
  aot_ = aot_[*,b,*]
  tau = fltarr(12)
  for i = 0, 11 do begin
   tau[i] = aave(aot_[*,*,i],area_,/nan)
  endfor
  tau_model = tau

  ddf = 'full_day.c1440.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'totexttau', aot
  aot[where(aot gt 1.e14)] = !values.f_nan
  aot_ = aot[a,*,*]
  aot_ = aot_[*,b,*]
  tau = fltarr(12)
  for i = 0, 11 do begin
   tau[i] = aave(aot_[*,*,i],area_,/nan)
  endfor
  tau_model_day = tau

  ddf = 'full_day_cloud.c1440.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'totexttau', aot
  aot[where(aot gt 1.e14)] = !values.f_nan
  aot_ = aot[a,*,*]
  aot_ = aot_[*,b,*]
  tau = fltarr(12)
  for i = 0, 11 do begin
   tau[i] = aave(aot_[*,*,i],area_,/nan)
  endfor
  tau_model_day_cloud = tau

  ddf = 'calipso.c1440.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'totexttau', aot
  aot[where(aot gt 1.e14)] = !values.f_nan
  aot_ = aot[a,*,*]
  aot_ = aot_[*,b,*]
  tau = fltarr(12)
  for i = 0, 11 do begin
   tau[i] = aave(aot_[*,*,i],area_,/nan)
  endfor
  tau_calipso = tau

  ddf = 'calipso_day.c1440.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'totexttau', aot
  aot[where(aot gt 1.e14)] = !values.f_nan
  aot_ = aot[a,*,*]
  aot_ = aot_[*,b,*]
  tau = fltarr(12)
  for i = 0, 11 do begin
   tau[i] = aave(aot_[*,*,i],area_,/nan)
  endfor
  tau_calipso_day = tau

  ddf = 'calipso_day_cloud.c1440.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'totexttau', aot
  aot[where(aot gt 1.e14)] = !values.f_nan
  aot_ = aot[a,*,*]
  aot_ = aot_[*,b,*]
  tau = fltarr(12)
  for i = 0, 11 do begin
   tau[i] = aave(aot_[*,*,i],area_,/nan)
  endfor
  tau_calipso_day_cloud = tau

  ddf = 'calipso_swath.c1440.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'totexttau', aot
  aot[where(aot gt 1.e14)] = !values.f_nan
  aot_ = aot[a,*,*]
  aot_ = aot_[*,b,*]
  tau = fltarr(12)
  for i = 0, 11 do begin
   tau[i] = aave(aot_[*,*,i],area_,/nan)
  endfor
  tau_calipso_swath = tau

  ddf = 'calipso_swath_day.c1440.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'totexttau', aot
  aot[where(aot gt 1.e14)] = !values.f_nan
  aot_ = aot[a,*,*]
  aot_ = aot_[*,b,*]
  tau = fltarr(12)
  for i = 0, 11 do begin
   tau[i] = aave(aot_[*,*,i],area_,/nan)
  endfor
  tau_calipso_swath_day = tau

  ddf = 'calipso_swath_day_cloud.c1440.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'totexttau', aot
  aot[where(aot gt 1.e14)] = !values.f_nan
  aot_ = aot[a,*,*]
  aot_ = aot_[*,b,*]
  tau = fltarr(12)
  for i = 0, 11 do begin
   tau[i] = aave(aot_[*,*,i],area_,/nan)
  endfor
  tau_calipso_swath_day_cloud = tau

; Make some plots
  set_plot, 'ps'
  device, file='aot_timeseries_swath.'+regstr[ireg]+'.c1440.ps', /helvetica, font_size=12, /color
  !p.font=0

  loadct, 39
  plot, indgen(13), /nodata, $
   xrange=[0,13], xstyle=1, xticks=13, $
   xtickn=[' ','J','F','M','A','M','J','J','A','S','O','N','D',' '], $
   yrange=[0.,ymax[ireg]], yticks=(ymax[ireg]/.1*2), ystyle=1
  oplot, indgen(12)+1, tau_model, thick=6
  oplot, indgen(12)+1, tau_model_day, thick=6, lin=2
  oplot, indgen(12)+1, tau_model_day_cloud, thick=6, lin=1
  oplot, indgen(12)+1, tau_calipso, thick=6, color=74
  oplot, indgen(12)+1, tau_calipso_day, thick=6, color=74, lin=2
  oplot, indgen(12)+1, tau_calipso_day_cloud, thick=6, color=74, lin=1
  oplot, indgen(12)+1, tau_calipso_swath, thick=6, color=254
  oplot, indgen(12)+1, tau_calipso_swath_day, thick=6, color=254, lin=2
  oplot, indgen(12)+1, tau_calipso_swath_day_cloud, thick=6, color=254, lin=1
  device, /close
print, regstr[ireg]
endfor

end

