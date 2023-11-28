  expid = 'c48F_G41-spin'
  filetemplate = expid+'.tavg2d_aer_x.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
;  nc4readvar, filename, 'duem', duem0, lon=lon, lat=lat, /sum, /tem
  nc4readvar, filename, 'duexttau', duext0, lon=lon, lat=lat

  expid = 'c48F_G41-nopin'
  filetemplate = expid+'.tavg2d_aer_x.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
;  nc4readvar, filename, 'duem', duem1, lon=lon, lat=lat, /sum, /tem
  nc4readvar, filename, 'duexttau', duext1, lon=lon, lat=lat

; Global area average
  area, lon, lat, nx, ny, dx, dy, area, grid='b'
  duext0 = aave(duext0,area)
  duext1 = aave(duext1,area)
;  duem0 = aave(duem0,area)*total(area)*86400*30/1e9
;  duem1 = aave(duem1,area)*total(area)*86400*30/1e9

; Deseasonalize
  nt = n_elements(nymd)  ; assume full years
  duext0_ = fltarr(12)
  duext1_ = fltarr(12)
;  duem0_  = fltarr(12)
;  duem1_  = fltarr(12)

  set_plot, 'ps'
  device, file='plot_global_dust.duexttau.'+expid+'.ps', /helvetica, font_size=12, /color, $
    xsize=18, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  x = indgen(n_elements(nymd))
  plot, x, duext0, /nodata, $
   position=[.15,.2,.85,.9], $
   xstyle=1, xminor=2, xticks=8, $
   xtickname=[string(nymd[0:191:24]/10000L,format='(i4)'),' '], $
   ystyle=1, yrange=[0,0.04], $
   yticks=8, ytitle = 'AOT'

  red   = [246,208,166,103,54,2,1]
  blue  = [239,209,189,169,144,129]
  green = [247,230,219,207,192,138,80]
  tvlct, red, green, blue
  dcolors=indgen(n_elements(red))

  plots, [5,12], .037, thick=3, color=5
  plots, [5,12], .034, thick=3, color=6
  xyouts, 13, .0365, 'Pinatubo', color=5
  xyouts, 13, .0335, 'No-Pinatubo', color=6

  plots, [55,62], .037, thick=3, color=6
  plots, [55,62], .034, thick=3, color=6, lin=2
  xyouts, 63, .0365, 'AOT', color=6
  xyouts, 63, .0335, 'Dust Emissions [Tg]', color=6

  oplot, x, duext0, thick=3, color=5
  oplot, x, duext1, thick=3, color=6

;  axis, yaxis=1, yrange=[-30,50], yticks=8, $
;        ytitle='De-Seasonalized Dust Emissions Anomaly [Tg]', /save, color=6, ymin=1
;  oplot, x, duem0, thick=3, color=5, lin=2
;  oplot, x, duem1, thick=3, color=6, lin=2

  device, /close



end
