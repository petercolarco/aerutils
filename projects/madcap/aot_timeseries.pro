  ddf = 'c180R_pI33p7.monthly.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'totexttau', aot
  area, lon, lat, nx, ny, dx, dy, area, grid='d'
  tau = fltarr(12)
  for i = 0, 11 do begin
   tau[i] = aave(aot[*,*,i],area,/nan)
  endfor
  tau_model = tau

  ddf = 'c180R_pI33p7.monthly_day.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'totexttau', aot
  aot[where(aot gt 1.e14)] = !values.f_nan
  area, lon, lat, nx, ny, dx, dy, area, grid='d'
  tau = fltarr(12)
  for i = 0, 11 do begin
   tau[i] = aave(aot[*,*,i],area,/nan)
  endfor
  tau_model_day = tau

  ddf = 'iss.totexttau.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'totexttau', aot
  aot[where(aot gt 1.e14)] = !values.f_nan
  tau = fltarr(12)
  for i = 0, 11 do begin
   tau[i] = aave(aot[*,*,i],area,/nan)
  endfor
  tau_iss = tau

  ddf = 'iss_sza.totexttau.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'totexttau', aot
  aot[where(aot gt 1.e14)] = !values.f_nan
  tau = fltarr(12)
  for i = 0, 11 do begin
   tau[i] = aave(aot[*,*,i],area,/nan)
  endfor
  tau_iss_day = tau

  ddf = 'calipso.totexttau.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'totexttau', aot
  aot[where(aot gt 1.e14)] = !values.f_nan
  tau = fltarr(12)
  for i = 0, 11 do begin
   tau[i] = aave(aot[*,*,i],area,/nan)
  endfor
  tau_calipso = tau

  ddf = 'calipso_sza.totexttau.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'totexttau', aot
  aot[where(aot gt 1.e14)] = !values.f_nan
  tau = fltarr(12)
  for i = 0, 11 do begin
   tau[i] = aave(aot[*,*,i],area,/nan)
  endfor
  tau_calipso_day = tau

; Make some plots
  set_plot, 'ps'
  device, file='aot_timeseries.ps', /helvetica, font_size=12, /color
  !p.font=0

  loadct, 39
  plot, indgen(13), /nodata, $
   xrange=[0,13], xstyle=1, xticks=13, $
   xtickn=[' ','J','F','M','A','M','J','J','A','S','O','N','D',' '], $
   yrange=[0.1,.16], yticks=6, ystyle=1
  oplot, indgen(12)+1, tau_model, thick=6
;  oplot, indgen(12)+1, tau_model_day, thick=6, lin=2
  oplot, indgen(12)+1, tau_calipso, thick=6, color=74
;  oplot, indgen(12)+1, tau_calipso_day, thick=6, color=74, lin=2
  oplot, indgen(12)+1, tau_iss, thick=6, color=254
;  oplot, indgen(12)+1, tau_iss_day, thick=6, color=254, lin=2
  device, /close

end

