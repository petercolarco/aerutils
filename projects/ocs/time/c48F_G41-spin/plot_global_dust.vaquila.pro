; From Valentina's runs, get the ensemble of global dust
; optical thickness and plot

  area, lon, lat, nx, ny, dx, dy, area, grid='b'

  duext = fltarr(240,3,2)

; Volcanic cases
  expid = ['25b28_01Vbr', '25b28_02Vbr', '25b28_03Vbr']
  for iexpid = 0, 2 do begin
   filetemplate = 'vaquila.'+expid[iexpid]+'.tavg2d_aer_x.ctl'
   ga_times, filetemplate, nymd, nhms, template=template
   filename=strtemplate(template,nymd,nhms)
   nc4readvar, filename, 'duexttau', duext_, lon=lon, lat=lat
   duext[*,iexpid,0] = aave(duext_,area)
  endfor

; Non-Volcanic cases
  expid = ['25b28_01Rbr', '25b28_02Rbr', '25b28_03Rbr']
  for iexpid = 0, 2 do begin
   filetemplate = 'vaquila.'+expid[iexpid]+'.tavg2d_aer_x.ctl'
   ga_times, filetemplate, nymd, nhms, template=template
   filename=strtemplate(template,nymd,nhms)
   nc4readvar, filename, 'duexttau', duext_, lon=lon, lat=lat
   duext[*,iexpid,1] = aave(duext_,area)
  endfor

  set_plot, 'ps'
  device, file='plot_global_dust.vaquila.duexttau.ps', /helvetica, font_size=12, /color, $
    xsize=18, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  x = indgen(n_elements(nymd))
  plot, x, duext, /nodata, $
   position=[.15,.2,.85,.9], $
   xstyle=1, xminor=2, xticks=10, $
   xtickname=[string(nymd[0:239:24]/10000L,format='(i4)'),' '], $
   ystyle=1, yrange=[0,0.1], $
   yticks=4, yminor=2, ytitle = 'AOT'

  red   = [246,208,166,103,54,2,1]
  blue  = [239,209,189,169,144,129]
  green = [247,230,219,207,192,138,80]
  tvlct, red, green, blue
  dcolors=indgen(n_elements(red))

  plots, [5,15], .095, thick=3, color=5
  plots, [5,15], .087, thick=3, color=6
  xyouts, 18, .093, 'Volcanoes', color=5
  xyouts, 18, .085, 'No Volcanoes', color=6

  oplot, x, mean(duext[*,*,0],dim=2), thick=6, color=5
  oplot, x, mean(duext[*,*,1],dim=2), thick=3, color=6, lin=2

  device, /close



end
