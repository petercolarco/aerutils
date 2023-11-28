  timestr = '12z'

  ddf = 'full.swtnet.'+timestr+'.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, ['swtnetc','swtnetcna'], aot
  aot = aot[*,*,*,0]-aot[*,*,*,1]
  area, lon, lat, nx, ny, dx, dy, area, grid='d'
  a = where(lat lt 60 and lat gt -60)
  aot = aot[*,a,*]
  area = area[*,a]
  tau = fltarr(12)
  for i = 0, 11 do begin
   tau[i] = aave(aot[*,*,i],area,/nan)
  endfor
  tau_model = tau

  ddf = 'full_day.swtnet.'+timestr+'.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, ['swtnetc','swtnetcna'], aot
  aot[where(aot gt 1.e14)] = !values.f_nan
  aot = aot[*,*,*,0]-aot[*,*,*,1]
  aot = aot[*,a,*]
  tau = fltarr(12)
  for i = 0, 11 do begin
   tau[i] = aave(aot[*,*,i],area,/nan)
  endfor
  tau_model_day = tau

  ddf = 'full_day_cloud.swtnet.'+timestr+'.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, ['swtnetc','swtnetcna'], aot
  aot[where(aot gt 1.e14)] = !values.f_nan
  aot = aot[*,*,*,0]-aot[*,*,*,1]
  aot = aot[*,a,*]
  tau = fltarr(12)
  for i = 0, 11 do begin
   tau[i] = aave(aot[*,*,i],area,/nan)
  endfor
  tau_model_day_cloud = tau

  ddf = 'calipso.swtnet.'+timestr+'.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, ['swtnetc','swtnetcna'], aot
  aot[where(aot gt 1.e14)] = !values.f_nan
  aot = aot[*,*,*,0]-aot[*,*,*,1]
  aot = aot[*,a,*]
  tau = fltarr(12)
  for i = 0, 11 do begin
   tau[i] = aave(aot[*,*,i],area,/nan)
  endfor
  tau_calipso = tau

  ddf = 'calipso_day.swtnet.'+timestr+'.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, ['swtnetc','swtnetcna'], aot
  aot[where(aot gt 1.e14)] = !values.f_nan
  aot = aot[*,*,*,0]-aot[*,*,*,1]
  aot = aot[*,a,*]
  tau = fltarr(12)
  for i = 0, 11 do begin
   tau[i] = aave(aot[*,*,i],area,/nan)
  endfor
  tau_calipso_day = tau

  ddf = 'calipso_day_cloud.swtnet.'+timestr+'.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, ['swtnetc','swtnetcna'], aot
  aot[where(aot gt 1.e14)] = !values.f_nan
  aot = aot[*,*,*,0]-aot[*,*,*,1]
  aot = aot[*,a,*]
  tau = fltarr(12)
  for i = 0, 11 do begin
   tau[i] = aave(aot[*,*,i],area,/nan)
  endfor
  tau_calipso_day_cloud = tau

  ddf = 'calipso_swath.swtnet.'+timestr+'.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, ['swtnetc','swtnetcna'], aot
  aot[where(aot gt 1.e14)] = !values.f_nan
  aot = aot[*,*,*,0]-aot[*,*,*,1]
  aot = aot[*,a,*]
  tau = fltarr(12)
  for i = 0, 11 do begin
   tau[i] = aave(aot[*,*,i],area,/nan)
  endfor
  tau_calipso_swath = tau

  ddf = 'calipso_swath_day.swtnet.'+timestr+'.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, ['swtnetc','swtnetcna'], aot
  aot[where(aot gt 1.e14)] = !values.f_nan
  aot = aot[*,*,*,0]-aot[*,*,*,1]
  aot = aot[*,a,*]
  tau = fltarr(12)
  for i = 0, 11 do begin
   tau[i] = aave(aot[*,*,i],area,/nan)
  endfor
  tau_calipso_swath_day = tau

  ddf = 'calipso_swath_day_cloud.swtnet.'+timestr+'.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, ['swtnetc','swtnetcna'], aot
  aot[where(aot gt 1.e14)] = !values.f_nan
  aot = aot[*,*,*,0]-aot[*,*,*,1]
  aot = aot[*,a,*]
  tau = fltarr(12)
  for i = 0, 11 do begin
   tau[i] = aave(aot[*,*,i],area,/nan)
  endfor
  tau_calipso_swath_day_cloud = tau

; Make some plots
  set_plot, 'ps'
  device, file='swtnetc_timeseries_swath.'+timestr+'.ps', /helvetica, font_size=12, /color
  !p.font=0

  loadct, 39
  plot, indgen(13), /nodata, $
   xrange=[0,13], xstyle=1, xticks=13, $
   xtickn=[' ','J','F','M','A','M','J','J','A','S','O','N','D',' '], $
   yrange=[-0,-10], yticks=10, ystyle=1
;  oplot, indgen(12)+1, tau_model, thick=6
  oplot, indgen(12)+1, tau_model_day, thick=6, lin=2
  oplot, indgen(12)+1, tau_model_day_cloud, thick=6, lin=1
;  oplot, indgen(12)+1, tau_calipso, thick=6, color=74
  oplot, indgen(12)+1, tau_calipso_day, thick=6, color=74, lin=2
  oplot, indgen(12)+1, tau_calipso_day_cloud, thick=6, color=74, lin=1
;  oplot, indgen(12)+1, tau_calipso_swath, thick=6, color=254
  oplot, indgen(12)+1, tau_calipso_swath_day, thick=6, color=254, lin=2
  oplot, indgen(12)+1, tau_calipso_swath_day_cloud, thick=6, color=254, lin=1
  device, /close

end

