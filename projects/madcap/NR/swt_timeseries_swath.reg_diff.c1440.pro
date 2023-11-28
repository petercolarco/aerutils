; Get a grid
  area, lon, lat, nx, ny, dx, dy, area, grid='nr'

  regstr = ['sam','saf','naf','nrv','igp','chn','sea','npac']
  lon0 = [-75,-15,-30, 30, 75, 100,  95, 135]
  lon1 = [-45, 35,-15, 36, 95, 125, 110, 165]
  lat0 = [-20,-20, 10, 22, 20,  25,  10,  30]
  lat1 = [  0,  0, 30, 32, 30,  42,  25,  55]
  nreg = n_elements(lon0)
  ymax   = [10,10,50,10,20,10,10,10]

; Set up the permutations
  tle   = ['gpm','sunsynch_500km']
  swath = ['100','300','500','1000']

  ntle = n_elements(tle)
  nswa = n_elements(swath)

; Get the full model
  taum = fltarr(12,nreg)
  ddf = 'c1440_NR.full.swt.day.monthly.ddf'
  print, ddf
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, ['swtnt','swtntcln'], aotf
  aotf[where(aotf gt 1.e14)] = !values.f_nan
  aotf = aotf[*,*,*,0]-aotf[*,*,*,1]
  tau = fltarr(12)
  for ireg = 0, nreg-1 do begin
   a = where(lon ge lon0[ireg] and lon le lon1[ireg])
   b = where(lat ge lat0[ireg] and lat le lat1[ireg])
   area_ = area[a,*]
   area_ = area_[*,b]
   aot_  = aotf[a,*,*]
   aot_  = aot_[*,b,*]
   for k = 0, 11 do begin
    tau[k] = aave(aot_[*,*,k],area_,/nan)
   endfor
   taum[*,ireg] = tau
  endfor

; Get the global mean aod
  taug = fltarr(12,nswa,ntle,nreg)
  taud = fltarr(12,nswa,ntle,nreg)
  for j = 0, ntle-1 do begin
   for i = 0, nswa-1 do begin
    ddf = 'c1440_NR.'+tle[j]+'.nodrag.'+swath[i]+'km.swt.day.monthly.ddf'
    print, ddf
    ga_times, ddf, nymd, nhms, template=template
    filename=strtemplate(template,nymd,nhms)
    nc4readvar, filename, ['swtnt','swtntcln'], aot
    aot[where(aot gt 1.e14)] = !values.f_nan
    tau  = fltarr(12)
    tau_ = fltarr(12)
    aot  = aot[*,*,*,0]-aot[*,*,*,1]
    for ireg = 0, nreg-1 do begin
     a = where(lon ge lon0[ireg] and lon le lon1[ireg])
     b = where(lat ge lat0[ireg] and lat le lat1[ireg])
     area_ = area[a,*]
     area_ = area_[*,b]
     aot_  = aot[a,*,*]
     aot_  = aot_[*,b,*]
     aotf_ = aotf[a,*,*]
     aotf_ = aotf_[*,b,*]
     for k = 0, 11 do begin
      tau[k]  = aave(aot_[*,*,k],area_,/nan)
      tau_[k] = aave(aot_[*,*,k]-aotf_[*,*,k],area_,/nan)
     endfor
     taug[*,i,j,ireg] = tau
     taud[*,i,j,ireg] = tau_
    endfor
   endfor
  endfor
jump:

; Make some plots
  for ireg = 0, nreg-1 do begin

  set_plot, 'ps'
  device, file='swt_timeseries_swath.day.'+regstr[ireg]+'.c1440.ps', /helvetica, font_size=12, /color
  !p.font=0

  loadct, 39

  yticks = ymax[ireg]/2.5+1
  ymin   = ymax[ireg]/2.5
  if(ymax[ireg] gt 10) then yticks = ymax[ireg]/5.+1
  if(ymax[ireg] gt 10) then ymin = ymax[ireg]/5.
  plot, indgen(13), /nodata, $
   xrange=[0,13], xstyle=1, xticks=13, $
   xtickn=[' ','J','F','M','A','M','J','J','A','S','O','N','D',' '], $
   yrange=[ymin,-ymax[ireg]], yticks=yticks, ystyle=1
  colors = [80,144,192,255]
  loadct, 63  ; greens
  for i = 0, 3 do begin
   oplot, indgen(12)+1, taug[*,i,0,ireg], thick=6, color=colors[i]
  endfor
  loadct, 56  ; oranges
  for i = 0, 3 do begin
   oplot, indgen(12)+1, taug[*,i,1,ireg], thick=6, color=colors[i]
  endfor
  loadct, 0
  oplot, indgen(12)+1, taum[*,ireg], thick=6, lin=2
  device, /close


  set_plot, 'ps'
  device, file='swt_timeseries_swath.day.'+regstr[ireg]+'_diff.c1440.ps', /helvetica, font_size=12, /color
  !p.font=0

  loadct, 0
  plot, indgen(13), /nodata, $
   xrange=[0,13], xstyle=1, xticks=13, $
   xtickn=[' ','J','F','M','A','M','J','J','A','S','O','N','D',' '], $
   yrange=[-ymax[ireg]/5.,ymax[ireg]/5.], yticks=10, ystyle=1
  oplot, indgen(14), make_array(14,val=0), thick=6
  oplot, indgen(14), make_array(14,val=.25), thick=1, lin=2
  oplot, indgen(14), make_array(14,val=-.25), thick=1, lin=2

  colors = [80,144,192,255]
  loadct, 63  ; greens
  for i = 0, 3 do begin
   oplot, indgen(12)+1, taud[*,i,0,ireg], thick=6, color=colors[i]
  endfor
  loadct, 56  ; oranges
  for i = 0, 3 do begin
   oplot, indgen(12)+1, taud[*,i,1,ireg], thick=6, color=colors[i]
  endfor

  device, /close

  set_plot, 'ps'
  device, file='swt_timeseries_swath.day.'+regstr[ireg]+'_range.c1440.ps', /helvetica, font_size=12, /color
  !p.font=0

  daot = fltarr(12)
  for jj = 0, 11 do begin
   daot[jj] = max(taud[jj,*,*,ireg]) - min(taud[jj,*,*,ireg])
  endfor

  loadct, 0
  plot, indgen(13), /nodata, $
   xrange=[0,13], xstyle=1, xticks=13, $
   xtickn=[' ','J','F','M','A','M','J','J','A','S','O','N','D',' '], $
   yrange=[0,ymax[ireg]/2], yticks=10, ystyle=1
  oplot, indgen(12)+1, daot, thick=6

  device, /close

  endfor

end

