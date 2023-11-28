; Restore from Feng Li provided IDL save files and make high quality
; plots of time series
; dta_dtoa.sav is the change in the 4xCO2 over time

  restore, file='dta_dtoa.sav'

  set_plot, 'ps'
  device, file='plot_surf_temp_change_wgregory.ps', /color, /helvetica, $
   font_size=20, xsize=24, ysize=14
  !p.font=1

  plot, indgen(150), dta, $
   title='Global Mean Surface Temperature Change ( !EO!NC )', $
   ytitle='Change in Temperature ( !EO!NC )', $
   xtitle='Year', $
   xrange=[0,150], xticks=15, xminor=2, $
   yrange=[0,5], yticks=10, yminor=1, $
   thick=3, /nodata
  oplot, indgen(150), dta, thick=8

  plot, indgen(150), dta, /nodata, /noerase, $
   title='TOA Radiative Flux vs. Surface T', $
   ytitle='Net TOA Radiative Flux (W m!E-2!N)', $
   xtitle='', $
   xrange=[0,7], xticks=7, xminor=2, xstyle=1, $
   yrange=[0,8], yticks=8, yminor=2, $
   thick=2, charsize=.78, $
   position=[.6,.28,.9,.7]
  plots, dta, dtoa, psym=4, symsize=.75
  par = linfit(dta,dtoa)
  x0 = 0
  x1 = -par[0]/par[1]
  y0 = par[0]
  y1 = 0
  plots, [x0,x1], [y0,y1], thick=6
  xyouts, 3.5, -1.5, '!9D!3T ( !EO!NC )', align=.5, /data, chars=.78


  device, /close

end

