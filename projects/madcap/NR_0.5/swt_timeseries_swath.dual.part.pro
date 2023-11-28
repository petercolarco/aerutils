; Set up the permutations
  tle   = ['gpm.nodrag','sunsynch_500km.nodrag','dual']
  swath = ['300km']

  ntle = n_elements(tle)
  nswa = n_elements(swath)

; Get the full model
  ddf = 'c1440_NR.full.swt.day.monthly.ddf'
  print, ddf
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, ['swtnt','swtntcln'], aot
  aot[where(aot gt 1.e14)] = !values.f_nan
  aot = aot[*,*,*,0]-aot[*,*,*,1]
  area, lon, lat, nx, ny, dx, dy, area, grid='half'
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
    ddf = 'c1440_NR.'+tle[j]+'.'+swath[i]+'.swt.day.monthly.ddf'
    print, ddf
    ga_times, ddf, nymd, nhms, template=template
    filename=strtemplate(template,nymd,nhms)
    nc4readvar, filename, ['swtnt','swtntcln'], aot_
    aot_[where(aot_ gt 1.e14)] = !values.f_nan
    aot_ = aot_[*,*,*,0]-aot_[*,*,*,1]
    area, lon, lat, nx, ny, dx, dy, area, grid='half'
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
  device, file='swt_timeseries_swath.dual.day.part.c1440.ps', /helvetica, font_size=12, /color
  !p.font=0

  loadct, 39
  plot, indgen(13), /nodata, $
   xrange=[0,13], xstyle=1, xticks=13, $
   xtickn=[' ','J','F','M','A','M','J','J','A','S','O','N','D',' '], $
   yrange=[0,-4], yticks=8, ystyle=1

  colors = [160]
  loadct, 63  ; greens
  for i = 0, 0 do begin
   oplot, indgen(12)+1, taug[*,i,0], thick=12, color=colors[i]
  endfor
  loadct, 56  ; oranges
  for i = 0, 0 do begin
   oplot, indgen(12)+1, taug[*,i,1], thick=12, color=colors[i]
  endfor
  loadct, 57  ; blues
  for i = 0, 0 do begin
   oplot, indgen(12)+1, taug[*,i,2], thick=12, color=colors[i]
  endfor
  loadct, 0
  oplot, indgen(12)+1, taum, thick=6


  device, /close


; Difference in global mean
  device, file='swt_timeseries_swath.dual.day.part.global_diff.c1440.ps', /helvetica, font_size=12, /color
  !p.font=0

  loadct, 39
  plot, indgen(13), /nodata, $
   xrange=[0,13], xstyle=1, xticks=13, $
   xtickn=[' ','J','F','M','A','M','J','J','A','S','O','N','D',' '], $
   yrange=[-1,1], yticks=8, ystyle=1
  oplot, indgen(14), make_array(14,val=0), thick=6
  oplot, indgen(14), make_array(14,val=.25), thick=1, lin=2
  oplot, indgen(14), make_array(14,val=-.25), thick=1, lin=2

  colors = [160]
  loadct, 63  ; greens
  for i = 0, 0 do begin
   oplot, indgen(12)+1, taud[*,i,0], thick=6, color=colors[i]
  endfor
  loadct, 56  ; oranges
  for i = 0, 0 do begin
   oplot, indgen(12)+1, taud[*,i,1], thick=6, color=colors[i]
  endfor
  loadct, 57  ; blues
  for i = 0, 0 do begin
   oplot, indgen(12)+1, taud[*,i,2], thick=6, color=colors[i]
  endfor

  device, /close

; Difference in global mean -- alternative
  device, file='swt_timeseries_swath.dual.day.part.global_diff2.c1440.ps', /helvetica, font_size=12, /color
  !p.font=0

  loadct, 39
  plot, indgen(13), /nodata, $
   xrange=[0,13], xstyle=1, xticks=13, $
   xtickn=[' ','J','F','M','A','M','J','J','A','S','O','N','D',' '], $
   yrange=[-1,1], yticks=8, ystyle=1
  oplot, indgen(14), make_array(14,val=0), thick=6
  oplot, indgen(14), make_array(14,val=.25), thick=1, lin=2
  oplot, indgen(14), make_array(14,val=-.25), thick=1, lin=2

  colors = [160]
  loadct, 63  ; greens
  for i = 0, 0 do begin
   oplot, indgen(12)+1, taug[*,i,0]-taum, thick=6, color=colors[i]
  endfor
  loadct, 56  ; oranges
  for i = 0, 0 do begin
   oplot, indgen(12)+1, taug[*,i,1]-taum, thick=6, color=colors[i]
  endfor
  loadct, 57  ; blues
  for i = 0, 0 do begin
   oplot, indgen(12)+1, taug[*,i,2]-taum, thick=6, color=colors[i]
  endfor

  device, /close

end

