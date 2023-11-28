  ddf = 'c180R_pI33p7.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'totexttau', aot
  area, lon, lat, nx, ny, dx, dy, area, grid='d'
  tau = fltarr(12)
  for i = 0, 11 do begin
   tau[i] = aave(aot[*,*,i],area,/nan)
  endfor
  tau_model = tau

  ddf = 'c180R_pI33p7.day.ddf'
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

  ddf = 'c180R_pI33p7.misr.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'totexttau', aot
  aot[where(aot gt 1.e14)] = !values.f_nan
  tau = fltarr(12)
  for i = 0, 11 do begin
   tau[i] = aave(aot[*,*,i],area,/nan)
  endfor
  tau_misr = tau

  ddf = 'c180R_pI33p7.mod04_ocn.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'totexttau', aot_ocn
  aot_ocn[where(aot_ocn gt 1.e14)] = !values.f_nan

  ddf = 'c180R_pI33p7.mod04_lnd.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'totexttau', aot_lnd
  aot_lnd[where(aot_lnd gt 1.e14)] = !values.f_nan

  ddf = 'c180R_pI33p7.mod04_blu.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'totexttau', aot_blu
  aot_blu[where(aot_blu gt 1.e14)] = !values.f_nan
  aot = aot_ocn
  aot[where(finite(aot_lnd) eq 1)] = aot_lnd[where(finite(aot_lnd) eq 1)]
  aot[where(finite(aot_blu) eq 1)] = aot_blu[where(finite(aot_blu) eq 1)]
  tau = fltarr(12)
  for i = 0, 11 do begin
   tau[i] = aave(aot[*,*,i],area,/nan)
  endfor
  tau_mod04 = tau

  ddf = 'c180R_pI33p7.myd04_ocn.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'totexttau', aot_ocn
  aot_ocn[where(aot_ocn gt 1.e14)] = !values.f_nan

  ddf = 'c180R_pI33p7.myd04_lnd.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'totexttau', aot_lnd
  aot_lnd[where(aot_lnd gt 1.e14)] = !values.f_nan

  ddf = 'c180R_pI33p7.myd04_blu.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'totexttau', aot_blu
  aot_blu[where(aot_blu gt 1.e14)] = !values.f_nan
  aot = aot_ocn
  aot[where(finite(aot_lnd) eq 1)] = aot_lnd[where(finite(aot_lnd) eq 1)]
  aot[where(finite(aot_blu) eq 1)] = aot_blu[where(finite(aot_blu) eq 1)]
  tau = fltarr(12)
  for i = 0, 11 do begin
   tau[i] = aave(aot[*,*,i],area,/nan)
  endfor
  tau_myd04 = tau

  ddf = 'c180R_pI33p7.mask.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'totexttau', aot
  aot[where(aot gt 1.e14)] = !values.f_nan
  tau = fltarr(12)
  for i = 0, 11 do begin
   tau[i] = aave(aot[*,*,i],area,/nan)
  endfor
  tau_calipso = tau

  ddf = 'c180R_pI33p7.sza.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'totexttau', aot
  aot[where(aot gt 1.e14)] = !values.f_nan
  tau = fltarr(12)
  for i = 0, 11 do begin
   tau[i] = aave(aot[*,*,i],area,/nan)
  endfor
  tau_sza = tau

  ddf = 'c180R_pI33p7.offset+10deg.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'totexttau', aot
  aot[where(aot gt 1.e14)] = !values.f_nan
  tau = fltarr(12)
  for i = 0, 11 do begin
   tau[i] = aave(aot[*,*,i],area,/nan)
  endfor
  tau_calipso_p10 = tau

  ddf = 'c180R_pI33p7.offset-10deg.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'totexttau', aot
  aot[where(aot gt 1.e14)] = !values.f_nan
  tau = fltarr(12)
  for i = 0, 11 do begin
   tau[i] = aave(aot[*,*,i],area,/nan)
  endfor
  tau_calipso_m10 = tau

; Make some plots
  set_plot, 'ps'
  device, file='aot_timeseries.full.ps', /helvetica, font_size=12, /color
  !p.font=0

  loadct, 39
  plot, indgen(13), /nodata, $
   xrange=[0,13], xstyle=1, xticks=13, $
   xtickn=[' ','J','F','M','A','M','J','J','A','S','O','N','D',' '], $
   yrange=[0.1,.15], yticks=5, ystyle=1
  oplot, indgen(12)+1, tau_model, thick=6
  oplot, indgen(12)+1, tau_model_day, thick=6, lin=2
  oplot, indgen(12)+1, tau_calipso, thick=6, color=74
  oplot, indgen(12)+1, tau_calipso_p10, thick=6, color=74, lin=2
  oplot, indgen(12)+1, tau_calipso_m10, thick=6, color=74, lin=1
  oplot, indgen(12)+1, tau_sza, thick=6, color=254
  device, /close

  set_plot, 'ps'
  device, file='aot_timeseries.sat.ps', /helvetica, font_size=12, /color
  !p.font=0

  loadct, 39
  plot, indgen(13), /nodata, $
   xrange=[0,13], xstyle=1, xticks=13, $
   xtickn=[' ','J','F','M','A','M','J','J','A','S','O','N','D',' '], $
   yrange=[0.1,.15], yticks=5, ystyle=1
  oplot, indgen(12)+1, tau_model, thick=6
  oplot, indgen(12)+1, tau_model_day, thick=6, lin=2
  oplot, indgen(12)+1, tau_calipso, thick=6, color=74
  oplot, indgen(12)+1, tau_misr, thick=6, color=176
  oplot, indgen(12)+1, tau_mod04, thick=6, color=208
  oplot, indgen(12)+1, tau_myd04, thick=6, color=254
  device, /close

end

