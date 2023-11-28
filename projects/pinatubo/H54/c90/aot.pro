  area, lon, lat, nx, ny, dx, dy, area, grid='c'

  expid = 'c90Fc_H54p2v8_pin'
  filetemplate = expid+'.inst2d_hwl_x.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'carma_suexttau', suF, lon=lon, lat=lat, time=time
  nc4readvar, filename, 'carma_duexttau', duF, lon=lon, lat=lat, time=time

  expid = 'c90Rrc_H54p2v8_pin'
  filetemplate = expid+'.inst2d_hwl_x.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'carma_suexttau', suR, lon=lon, lat=lat, time=time
  nc4readvar, filename, 'carma_duexttau', duR, lon=lon, lat=lat, time=time

; Make a time series global mean
  nt = n_elements(time)
jump:
  suFt = fltarr(nt)
  suRt = fltarr(nt)
  duFt = fltarr(nt)
  duRt = fltarr(nt)
  for it = 0, nt-1 do begin
   suFt[it] = total(suF[*,*,it]*area)/total(area)
   suRt[it] = total(suR[*,*,it]*area)/total(area)
   duFt[it] = total(duF[*,*,it]*area)/total(area)
   duRt[it] = total(duR[*,*,it]*area)/total(area)
  endfor

  set_plot, 'ps'
  device, file='aot.ps', /color, /helvetica, font_size=14
  !p.font=0

  loadct, 39
  plot, duft, thick=6, color=0, /nodata, $
   xtitle='hours since 1z15jun1991', $
   ytitle='Global Mean AOT', yrange=[0,.06]
  oplot, duft, thick=6, color=208
  oplot, durt, thick=6, color=208, lin=2

  oplot, suft, thick=6, color=254
  oplot, surt, thick=6, color=254, lin=2

  plots, [10,30], .055, thick=6, color=254
  plots, [10,30], .052, thick=6, color=208
  xyouts, 32, .054, 'Sulfate (solid=free running, dashed=replay)'
  xyouts, 32, .051, 'Ash (solid=free running, dashed=replay)'

  device, /close


end
