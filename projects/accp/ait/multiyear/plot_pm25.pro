; Restore the pm25 saved fields and make plots
  restore, file='diurnal.pm25.sav'

; Make a series of plots
  fileh = ['global','global_lnd','global_ocn', $
           'north','north_lnd','north_ocn', $
           'south','south_lnd','south_ocn', $
           'tropic','tropic_lnd','tropic_ocn']

  for i = 0, 11 do begin

  ymax = 30
  ymin = 0
;  if(i ge 3 and i le 8) then ymax = 0.1

  set_plot, 'ps'
  device, file=fileh[i]+'.pm25.ps', /color,/helvetica,font_size=14, $
   xsize=24, ysize=14
  !p.font=0

  plot, indgen(20), /nodata, $
   xtitle='Hour (Local)', xrange=[-1,24], xstyle=9, ystyle=9, $
   xticks=25, xtickn=[' ',string(indgen(24),format='(i2)'),' '], $
   yrange=[ymin,ymax], ytitle='PM2.5 [!Mm!Ng m!E-3!N]'
  x = indgen(24)
  oplot, x, 1e9*out_full[i,*], thick=10
  loadct, 39
  oplot, x, 1e9*out_n45[i,*], thick=6, color=60
  oplot, x, 1e9*out_n50[i,*], thick=6, color=84
  oplot, x, 1e9*out_n55[i,*], thick=6, color=176
  oplot, x, 1e9*out_n60[i,*], thick=6, color=208
  oplot, x, 1e9*out_n65[i,*], thick=6, color=254
  oplot, x, 1e9*out_w45[i,*], thick=6, color=60, lin=2
  oplot, x, 1e9*out_w50[i,*], thick=6, color=84, lin=2
  oplot, x, 1e9*out_w55[i,*], thick=6, color=176, lin=2
  oplot, x, 1e9*out_w60[i,*], thick=6, color=208, lin=2
  oplot, x, 1e9*out_w65[i,*], thick=6, color=254, lin=2

  device, /close

  endfor

end
