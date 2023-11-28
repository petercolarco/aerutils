; Make a plot of the time series of global mean AOT
  expctl = 'd5124_m2_jan79.ddf'
  ga_times, expctl, nymd, nhms, template=filetemplate, tdef=tdef, jday=jday, rc=rc
; pick off first period
  nymd = nymd[0:419]
  nhms = nhms[0:419]
  filename = strtemplate(parsectl_dset(expctl),nymd,nhms)

  nc4readvar, filename, 'totexttau', totexttau, lon=lon, lat=lat, wantlon=[46.5,46.5], wantlat=[25,25]
  nc4readvar, filename, 'duexttau',  duexttau, lon=lon, lat=lat, wantlon=[46.5,46.5], wantlat=[25,25]

; Deseasonalize based on 2001 - 2014 time series
  dupart = duexttau[252:419]
  nd = n_elements(dupart)
  duseas = fltarr(12)
  for i = 0, 11 do begin
   duseas[i] = total(dupart[i:nd-1:12])/n_elements(dupart[i:nd-1:12])
  endfor

  nd = n_elements(duexttau)
  dudeseasonal = fltarr(nd)
  for i = 0, nd-1 do begin
   dudeseasonal[i] = duexttau[i]-duseas[i mod 12]
   print, i, i mod 12
  endfor

; Make a nice plot!
  set_plot, 'ps'
  device, file='solar_village_mean.ps', /color, /helvetica, font_size=12, $
          xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0
  loadct, 39

  plot, findgen(420), /nodata, color=0, $
    xrange=[0,420], yrange=[0,.6], xstyle=9, ystyle=9, thick=3, $
    ytitle='AOT', xticks=7, xminor=5, $
    xtickname=[string(nymd[0:419:60]/10000L,format='(i4)'),' ']
  oplot, findgen(420), totexttau, thick=6, color=0
  oplot, findgen(420), duexttau, thick=6, color=208
  device, /close

; Plot the deseasonalized AOT
; See Klingmuller 2016
  set_plot, 'ps'
  device, file='solar_village_deseasonal.ps', /color, /helvetica, font_size=12, $
          xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0
  loadct, 39

  plot, findgen(420), /nodata, color=0, $
    xrange=[240,420], yrange=[-0.2,0.2], xstyle=9, ystyle=9, thick=3, $
    ytitle='AOT', xticks=7, xminor=5, $
    xtickname=[string(nymd[240:419:24]/10000L,format='(i4)'),' ']
  oplot, findgen(420), dudeseasonal, thick=6, color=0
  device, /close


end
