; Restore the preccon saved fields and make plots
  restore, file='diurnal.preccon.sav'

; Make a series of plots
  fileh = ['global','global_lnd','global_ocn', $
           'north','north_lnd','north_ocn', $
           'south','south_lnd','south_ocn', $
           'tropic','tropic_lnd','tropic_ocn']

  for i = 0, 11 do begin

  ymax = 0.8
;  if(i ge 3 and i le 8) then ymax = 1.
  ymin = 0.5

  set_plot, 'ps'
  device, file=fileh[i]+'.preccon.ps', /color,/helvetica,font_size=14, $
   xsize=24, ysize=14
  !p.font=0

  plot, indgen(20), /nodata, $
   xtitle='Hour (Local)', xrange=[-1,24], xstyle=9, ystyle=9, $
   xticks=25, xtickn=[' ',string(indgen(24),format='(i2)'),' '], $
   yrange=[ymin,ymax], ytitle='Convective Precipitation [mm day!E-1!N]'
  x = indgen(24)
  oplot, x, out_full[i,*], thick=10
  loadct, 39
  oplot, x, out_n45[i,*], thick=6, color=60
  oplot, x, out_n50[i,*], thick=6, color=84
  oplot, x, out_n55[i,*], thick=6, color=176
  oplot, x, out_n60[i,*], thick=6, color=208
  oplot, x, out_n65[i,*], thick=6, color=254
  oplot, x, out_w45[i,*], thick=6, color=60, lin=2
  oplot, x, out_w50[i,*], thick=6, color=84, lin=2
  oplot, x, out_w55[i,*], thick=6, color=176, lin=2
  oplot, x, out_w60[i,*], thick=6, color=208, lin=2
  oplot, x, out_w65[i,*], thick=6, color=254, lin=2

  device, /close

  endfor

end
