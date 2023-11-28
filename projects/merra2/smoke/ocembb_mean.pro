; Make a plot of the time series of global mean AOT
  expctl = 'merra2.d5124_m2_jan79.tavg1_2d_aer_Nx.ddf'
  ga_times, expctl, nymd, nhms, template=filetemplate, tdef=tdef, jday=jday, rc=rc
; pick off first period
  nymd = nymd[251:502]
  nhms = nhms[251:502]
  filename = strtemplate(parsectl_dset(expctl),nymd,nhms)

  lat2 = 1
  lon2 = 1
  area, lon, lat, nx, ny, dx, dy, area, grid='d', lon2=lon2, lat2=lat2
  a = where(lat2 ge 30 and lat2 le 80 and lon2 ge -170 and lon2 le -90)
  area = area[a]

  nc4readvar, filename, 'ocembb', duem, lon=lon, lat=lat, /temp, /sum, $
   wantlat=[30,80], wantlon=[-170,-60]
  duem = duem*30*86400/1e9  ; Tg m-2 mon-1

; Now make a global mean
  du    = fltarr(n_elements(nymd))
  for i = 0, n_elements(nymd)-1 do begin
   du[i] = total(duem[*,*,i]*area)
  endfor
  
  a = where(du eq 0)
  if(a[0] ne -1) then du[a] = !values.f_nan

; Make a nice plot!
  set_plot, 'ps'
  device, file='ocembb_mean.ps', /color, /helvetica, font_size=12, $
          xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0
  loadct, 0

  plot, findgen(252), /nodata, color=0, $
    xrange=[0,252], yrange=[0,5], xstyle=9, ystyle=9, thick=3, $
    ytitle='Biomass Burning Emissions [Tg mon!E-1!N]', xticks=11, xminor=2, $
    xtickv = [findgen(11)*24,252], $
    xtickname=[string(nymd[0:251:24]/10000L,format='(i4)'),' ']
  oplot, findgen(252), du, thick=2, color=180
  dus = smooth(du,12)
  dus[0:5] = !values.f_nan
  dus[246:251] = !values.f_nan
  oplot, findgen(252), dus, thick=6
  device, /close


  duclim = fltarr(12)
  for i = 0, 11 do begin
   duclim[i] = mean(du[i:251:12])
  endfor

  duanom = fltarr(252)
  for i = 0, 251 do begin
   duanom[i] = du[i] - duclim[i mod 12]
  endfor

  set_plot, 'ps'
  device, file='ocembb_anom.ps', /color, /helvetica, font_size=12, $
          xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0
  loadct, 0

  plot, findgen(252), /nodata, color=0, $
    xrange=[0,252], yrange=[-5,5], xstyle=9, ystyle=9, thick=3, $
    ytitle='Biomass Burning Emissions Anomaly [Tg mon!E-1!N]', xticks=5, xminor=5, $
    xtickname=[string(nymd[0:251:60]/10000L,format='(i4)'),' ']
  oplot, findgen(252), duanom, thick=2, color=180
  dus = smooth(duanom,12)
  dus[0:5] = !values.f_nan
  dus[246:251] = !values.f_nan
  oplot, findgen(252), dus, thick=6
  device, /close


end
