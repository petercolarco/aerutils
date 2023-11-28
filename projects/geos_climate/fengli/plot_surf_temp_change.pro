; Restore from Feng Li provided IDL save files and make high quality
; plots of time series
; dta_dtoa.sav is the change in the 4xCO2 over time

  restore, file='dta_dtoa.sav'

  set_plot, 'ps'
  device, file='plot_surf_temp_change.ps', /color, /helvetica, $
   font_size=20, xsize=24, ysize=14
  !p.font=1

  plot, indgen(150), dta, $
   title='Global Mean Surface Temperature Change ( !EO!NC )', $
   ytitle='Change in Temperature ( !EO!NC )', $
   xtitle='Year of Simulation', $
   xrange=[0,150], xticks=15, xminor=2, $
   yrange=[0,5], yticks=10, yminor=1, $
   thick=3, /nodata
  oplot, indgen(150), dta, thick=8

  device, /close

end

