; Restore from Feng Li provided IDL save files and make high quality
; plots of time series
; dta_dtoa.sav is the change in the 4xCO2 over time

  set_plot, 'ps'
  device, file='plot_seaice.ps', /color, /helvetica, $
   font_size=20, xsize=24, ysize=14
  !p.font=1

  restore, file='SIE_4xco2.sav'
  plot, indgen(150), /nodata, /noerase, $
   title='Sea Ice Extent', $
   ytitle='Millions of km!E2!N', $
   xtitle='Year', $
   xrange=[0,150], xticks=15, xminor=2, xstyle=1, $
   yrange=[0,15], yticks=3, yminor=5, $
   thick=3
  loadct, 39
  oplot, mean(SIESH_4CO2,dim=1)/1.e12, thick=12, color=84
  oplot, mean(SIENH_4CO2,dim=1)/1.e12, thick=12
  xyouts, 30, 10.5, 'Antarctic', color=84
  xyouts, 30, 3.5, 'Arctic'

  


  device, /close

end

