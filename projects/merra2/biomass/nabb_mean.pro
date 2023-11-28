; Make a plot of the time series of global mean AOT
  expctl = 'd5124_m2_jan79.ddf'
  ga_times, expctl, nymd, nhms, template=filetemplate, tdef=tdef, jday=jday, rc=rc
; pick off first period
  a = where(nymd ge 20030000L and nymd lt 20230000L)
  nymd = nymd[a]
  nhms = nhms[a]
  filename = strtemplate(parsectl_dset(expctl),nymd,nhms)

  nc4readvar, filename, 'bcembb', bcembb, lon=lon, lat=lat, /temp, /sum
  bcembb = bcembb*30*86400/1e9  ; Tg m-2 mon-1

; Now make a global mean
  lat2 = 1
  lon2 = 1
  area, lon, lat, nx, ny, dx, dy, area, grid='d', lon2=lon2, lat2=lat2
  bcembb_ = reform(bcembb,nx*ny*1L,n_elements(nymd))
  du    = fltarr(n_elements(nymd))
  a = where(lat2 gt 26 and lat2 lt 50 and lon2 gt -130 and lon2 lt -60)
  for i = 0, n_elements(nymd)-1 do begin
   du[i] = total(bcembb_[a,i]*area[a])
  endfor
  
  a = where(du eq 0)
  if(a[0] ne -1) then du[a] = !values.f_nan
  

; Make a nice plot!
  set_plot, 'ps'
  device, file='nabb_mean.ps', /color, /helvetica, font_size=12, $
          xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0
  loadct, 0

  plot, findgen(224), /nodata, color=0, $
    xrange=[0,240], yrange=[0,.25], xstyle=9, ystyle=9, thick=3, $
    ytitle='Biomass Burning Emissions [Tg mon!E-1!N]', xticks=5, xminor=4, $
    xtickname=[string(nymd[0:239:48]/10000L,format='(i4)'),' ']
  oplot, findgen(240), du, thick=4, color=180
  dus = smooth(du,12)
;  dus[0:5] = !values.f_nan
;  dus[414:419] = !values.f_nan
;  oplot, findgen(240), dus, thick=6
  device, /close

  duclim = fltarr(12)
  for i = 0, 11 do begin
   duclim[i] = mean(du[i:239:12])
  endfor

  duanom = fltarr(240)
  for i = 0, 239 do begin
   duanom[i] = du[i] - duclim[i mod 12]
  endfor

  set_plot, 'ps'
  device, file='nabb_anom.ps', /color, /helvetica, font_size=12, $
          xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0
  loadct, 0

  plot, findgen(240), /nodata, color=0, $
    xrange=[0,240], yrange=[-.05,.15], xstyle=9, ystyle=9, thick=3, $
    ytitle='Biomass Burning Emissions Anomaly [Tg mon!E-1!N]', xticks=5, xminor=5, $
    xtickname=[string(nymd[0:239:48]/10000L,format='(i4)'),' ']
  oplot, findgen(420), duanom, thick=4, color=180
  plots, [0,240], 0., lin=1
;  dus = smooth(duanom,12)
;  dus[0:5] = !values.f_nan
;  dus[414:419] = !values.f_nan
 ; oplot, findgen(420), dus, thick=6
  device, /close


end
