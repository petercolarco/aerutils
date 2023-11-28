; Plot the seasonal dust AOD variability of the experiment against
; MERRA2

; Get the RefD1
  yyyy = string(findgen(15)+1960,format='(i4)')
  read_budget_table, 'RefD1', 'BC', yyyy, $
                     emis, sed, dep, wet, scav, burden, tau
; Mean seasonal AOD
  aod = mean(tau,dimension=2)

; Get the MERRA-2
  yyyy = string(findgen(15)+2000,format='(i4)')
  read_budget_table, 'merra2.d5124_m2_jan79.tavg1_2d_aer_Nx', 'BC', yyyy, $
                     emis, sed, dep, wet, scav, burden, tau
  aod_ = mean(tau,dimension=2)

; Make a plot
  set_plot, 'ps'
  device, file='seasonal_bc.ps', /helvetica, font_size=14, $
   /color
  !p.font=0

  months = [' ','J','F','M','A','M','J','J','A','S','O','N','D',' ']

  plot, indgen(10), /nodata, $
   xrange=[0,13], xticks=13, xtickn=months, xminor=1, $
   yrange=[0,0.01], ytitle='AOD', xstyle=9, ystyle=9
  loadct, 39
  oplot, indgen(12)+1, aod_[0:11], thick=12, color=208
  oplot, indgen(12)+1, aod[0:11], thick=12, color=84

  device, /close
end
