; Make a plot of the time series of global mean AOT
  expctl = 'd5124_m2_jan79.ddf'
  ga_times, expctl, nymd, nhms, template=filetemplate, tdef=tdef, jday=jday, rc=rc
; pick off first period
  nymd = nymd[0:419]
  nhms = nhms[0:419]
  filename = strtemplate(parsectl_dset(expctl),nymd,nhms)

  nc4readvar, filename, 'totexttau', totexttau, lon=lon, lat=lat
  nc4readvar, filename, 'duexttau',  duexttau, lon=lon, lat=lat

; Now make a global mean
  lat2 = 1
  lon2 = 1
  area, lon, lat, nx, ny, dx, dy, area, grid='d', lon2=lon2, lat2=lat2
  totexttau_ = reform(totexttau,nx*ny*1L,n_elements(nymd))
  duexttau_  = reform(duexttau,nx*ny*1L,n_elements(nymd))
  a = where(lat2 gt 0 and lat2 lt 45 and lon2 gt -30 and lon2 lt 75)
  tau   = aave(totexttau_[a,*],area[a],/nan)
  taudu = aave(duexttau_[a,*],area[a],/nan)
  a = where(tau eq 0)
  if(a[0] ne -1) then tau[a] = !values.f_nan
  a = where(taudu eq 0)
  if(a[0] ne -1) then taudu[a] = !values.f_nan

; Make a nice plot!
  set_plot, 'ps'
  device, file='mena_mean.ps', /color, /helvetica, font_size=12, $
          xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0
  loadct, 39

  plot, findgen(420), /nodata, color=0, $
    xrange=[0,420], yrange=[0,.6], xstyle=9, ystyle=9, thick=3, $
    ytitle='AOT', xticks=7, xminor=5, $
    xtickname=[string(nymd[0:419:60]/10000L,format='(i4)'),' ']
  oplot, findgen(420), tau, thick=6, color=0
  oplot, findgen(420), taudu, thick=6, color=208
  device, /close

end
