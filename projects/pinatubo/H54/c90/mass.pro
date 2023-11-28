  area, lon, lat, nx, ny, dx, dy, area, grid='c'

  expid = 'c90Fc_H54p2v8_pin'
  filetemplate = expid+'.tavg2d_carma_x.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'sucmass', suF, lon=lon, lat=lat, time=time
  nc4readvar, filename, 'ducmass', duF, lon=lon, lat=lat, time=time

; Make a time series global mean
  nt = n_elements(time)
  suFt = fltarr(nt)
  duFt = fltarr(nt)
  for it = 0, nt-1 do begin
   suFt[it] = total(suF[*,*,it]*area)/1.e9
   duFt[it] = total(duF[*,*,it]*area)/1.e9
  endfor

  set_plot, 'ps'
  device, file='mass.ps', /color, /helvetica, font_size=14
  !p.font=0

  loadct, 39
  plot, findgen(nt)*24, duft, thick=6, color=0, /nodata, $
   xtitle='hours since 0z15jun1991', $
   ytitle='Global Mass Loading', yrange=[0,60]
  oplot, findgen(nt)*24, duft, thick=6, color=208
  oplot, findgen(nt)*24, suft, thick=6, color=254

  plots, [10,30], 55, thick=6, color=254
  plots, [10,30], 52, thick=6, color=208
  xyouts, 32, 54, 'Sulfate (solid=free running, dashed=replay)'
  xyouts, 32, 51, 'Ash (solid=free running, dashed=replay)'

  device, /close


end
