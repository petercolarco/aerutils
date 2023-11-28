; Restore from Feng Li provided IDL save files and make high quality
; plots of time series
; dta_dtoa.sav is the change in the 4xCO2 over time

  restore, file='dta_dtoa.sav'

  set_plot, 'ps'
  device, file='plot_surf_temp_change_wseaice.ps', /color, /helvetica, $
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

  restore, file='SIE_4xco2.sav'
  plot, indgen(150), dta, /nodata, /noerase, $
   title='Sea Ice Extent', $
   ytitle='Millions of km!E2!N', $
   xtitle='', $
   xrange=[0,150], xticks=5, xminor=3, xstyle=1, $
   yrange=[0,15], yticks=3, yminor=5, $
   thick=2, charsize=.78, $
   position=[.5,.27,.9,.7]
  xyouts, 75, -2.5, 'Year', align=.5, charsize=.78, /data
  loadct, 39
  oplot, mean(SIESH_4CO2,dim=1)/1.e12, thick=8, color=84
  oplot, mean(SIENH_4CO2,dim=1)/1.e12, thick=8
  


  device, /close

end

