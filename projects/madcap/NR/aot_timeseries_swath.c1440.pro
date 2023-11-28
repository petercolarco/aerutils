; Set up the permutations
  tle   = ['gpm','sunsynch_500km']
  swath = ['nadir','100km','300km','500km','1000km']

  ntle = n_elements(tle)
  nswa = n_elements(swath)

; Get the full model
  ddf = 'c1440_NR.full.day.cloud.monthly.ddf'
  print, ddf
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'totexttau', aot
  aot[where(aot gt 1.e14)] = !values.f_nan
  area, lon, lat, nx, ny, dx, dy, area, grid='nr'
  tau = fltarr(12)
  for k = 0, 11 do begin
   tau[k] = aave(aot[*,*,k],area,/nan)
  endfor
  taum = tau

; Get the global mean aod
  taug = fltarr(12,nswa,ntle)
  taud = fltarr(12,nswa,ntle)
  for j = 0, ntle-1 do begin
   for i = 0, nswa-1 do begin
    ddf = 'c1440_NR.'+tle[j]+'.nodrag.'+swath[i]+'.day.cloud.monthly.ddf'
    print, ddf
    ga_times, ddf, nymd, nhms, template=template
    filename=strtemplate(template,nymd,nhms)
    nc4readvar, filename, 'totexttau', aot_
    aot_[where(aot_ gt 1.e14)] = !values.f_nan
    area, lon, lat, nx, ny, dx, dy, area, grid='nr'
    tau  = fltarr(12)
    tau_ = fltarr(12)
    for k = 0, 11 do begin
     tau[k]  = aave(aot_[*,*,k],area,/nan)
     tau_[k] = aave(aot_[*,*,k]-aot[*,*,k],area,/nan)
    endfor
    taug[*,i,j] = tau
    taud[*,i,j] = tau_
   endfor
  endfor


; Make some plots
  set_plot, 'ps'
  device, file='aot_timeseries_swath.day.cloud.c1440.ps', /helvetica, font_size=12, /color
  !p.font=0

  loadct, 39
  plot, indgen(13), /nodata, $
   xrange=[0,13], xstyle=1, xticks=13, $
   xtickn=[' ','J','F','M','A','M','J','J','A','S','O','N','D',' '], $
   yrange=[0.08,.16], yticks=8, ystyle=1

  colors = [80,120,160,192,255]
  loadct, 63  ; greens
  for i = 0, 4 do begin
   oplot, indgen(12)+1, taug[*,i,0], thick=6, color=colors[i]
  endfor
  loadct, 56  ; oranges
  for i = 0, 4 do begin
   oplot, indgen(12)+1, taug[*,i,1], thick=6, color=colors[i]
  endfor
  loadct, 0
  oplot, indgen(12)+1, taum, thick=6, lin=2


  device, /close


; Difference in global mean
  device, file='aot_timeseries_swath.day.cloud.global_diff.c1440.ps', /helvetica, font_size=12, /color
  !p.font=0

  loadct, 39
  plot, indgen(13), /nodata, $
   xrange=[0,13], xstyle=1, xticks=13, $
   xtickn=[' ','J','F','M','A','M','J','J','A','S','O','N','D',' '], $
   yrange=[-.05,.05], yticks=10, ystyle=1
  oplot, indgen(14), make_array(14,val=0), thick=6
  oplot, indgen(14), make_array(14,val=.01), thick=1, lin=2
  oplot, indgen(14), make_array(14,val=-.01), thick=1, lin=2

  colors = [80,120,160,192,255]
  loadct, 63  ; greens
  for i = 0, 4 do begin
   oplot, indgen(12)+1, taud[*,i,0], thick=6, color=colors[i]
  endfor
  loadct, 56  ; oranges
  for i = 0, 4 do begin
   oplot, indgen(12)+1, taud[*,i,1], thick=6, color=colors[i]
  endfor

  device, /close

; Difference in global mean -- alternative
  device, file='aot_timeseries_swath.day.cloud.global_diff2.c1440.ps', /helvetica, font_size=12, /color
  !p.font=0

  loadct, 39
  plot, indgen(13), /nodata, $
   xrange=[0,13], xstyle=1, xticks=13, $
   xtickn=[' ','J','F','M','A','M','J','J','A','S','O','N','D',' '], $
   yrange=[-.05,.05], yticks=10, ystyle=1
  oplot, indgen(14), make_array(14,val=0), thick=6
  oplot, indgen(14), make_array(14,val=.01), thick=1, lin=2
  oplot, indgen(14), make_array(14,val=-.01), thick=1, lin=2

  colors = [80,120,160,192,255]
  loadct, 63  ; greens
  for i = 0, 4 do begin
   oplot, indgen(12)+1, taug[*,i,0]-taum, thick=6, color=colors[i]
  endfor
  loadct, 56  ; oranges
  for i = 0, 4 do begin
   oplot, indgen(12)+1, taug[*,i,1]-taum, thick=6, color=colors[i]
  endfor

  device, /close

end

