  expid = 'c48F_G41-spin'
  filetemplate = expid+'.tavg2d_aer_x.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
;  nc4readvar, filename, 'duem', duem0, lon=lon, lat=lat, /sum, /tem
  nc4readvar, filename, 'dusmass', duext0, wantlon=[-59.5], wantlat=[13.15], lon=lon, lat=lat

  expid = 'c48F_G41-nopin'
  filetemplate = expid+'.tavg2d_aer_x.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
;  nc4readvar, filename, 'duem', duem1, lon=lon, lat=lat, /sum, /tem
  nc4readvar, filename, 'dusmass', duext1, wantlon=[-59.5], wantlat=[13.15], lon=lon, lat=lat

; Units
  duext0 = duext0*1e9
  duext1 = duext1*1e9

  set_plot, 'ps'
  device, file='plot_barbados_dusmass.'+expid+'.ps', /helvetica, font_size=12, /color, $
    xsize=18, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  x = indgen(n_elements(nymd))
  plot, x, duext0, /nodata, $
   position=[.15,.2,.85,.9], $
   xstyle=1, xminor=2, xticks=8, $
   xtickname=[string(nymd[0:191:24]/10000L,format='(i4)'),' '], $
   ystyle=1, yrange=[0,50], $
   yticks=5, yminor=2, ytitle = 'Dust Surface Mass [ug m!E-3!N]'

  red   = [246,208,166,103,54,2,1]
  blue  = [239,209,189,169,144,129]
  green = [247,230,219,207,192,138,80]
  tvlct, red, green, blue
  dcolors=indgen(n_elements(red))

  plots, [7,14], 48, thick=3, color=5
  plots, [7,14], 45, thick=3, color=6
  xyouts, 15, 47.5, 'Pinatubo', color=5
  xyouts, 15, 44.5, 'No-Pinatubo', color=6

  oplot, x, duext0, thick=3, color=5
  oplot, x, duext1, thick=3, color=6


  device, /close



end
