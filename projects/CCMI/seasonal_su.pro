; Plot the seasonal dust AOD variability of the experiment against
; MERRA2

; Get the RefD1
  yyyy = string(findgen(15)+1960,format='(i4)')
  read_budget_table, 'RefD1', 'SU', yyyy, $
                  emis, sed, dep, wet, scav, burden, tau1, $
                  emisso2=emisso2, emisdms=emisdms, depso2=depso2, $
                  pso4g=pso4g, pso4liq=pso4liq, pso2=pso2, loadso2=loadso2, loaddms=loaddms

  yyyy = string(findgen(15)+1960,format='(i4)')
  read_budget_table, 'RefD1', 'SUV', yyyy, $
                  emis, sed, dep, wet, scav, burden, tau2, $
                  emisso2=emisso2, emisdms=emisdms, depso2=depso2, $
                  pso4g=pso4g, pso4liq=pso4liq, pso2=pso2, loadso2=loadso2, loaddms=loaddms
; Mean seasonal AOD
  aod1 = mean(tau1,dimension=2)
  aod2 = mean(tau2,dimension=2)+aod1

; Get the MERRA-2
  yyyy = string(findgen(15)+2000,format='(i4)')
  read_budget_table, 'merra2.d5124_m2_jan79.tavg1_2d_aer_Nx', 'SU', yyyy, $
                  emis, sed, dep, wet, scav, burden, tau, $
                  emisso2=emisso2, emisdms=emisdms, depso2=depso2, $
                  pso4g=pso4g, pso4liq=pso4liq, pso2=pso2, loadso2=loadso2, loaddms=loaddms
  aod_ = mean(tau,dimension=2)

; Make a plot
  set_plot, 'ps'
  device, file='seasonal_su.ps', /helvetica, font_size=14, $
   /color
  !p.font=0

  months = [' ','J','F','M','A','M','J','J','A','S','O','N','D',' ']

  plot, indgen(10), /nodata, $
   xrange=[0,13], xticks=13, xtickn=months, xminor=1, $
   yrange=[0,0.05], ytitle='AOD', xstyle=9, ystyle=9
  loadct, 39
  oplot, indgen(12)+1, aod_[0:11], thick=12, color=208
  oplot, indgen(12)+1, aod1[0:11], thick=12, color=84
  oplot, indgen(12)+1, aod2[0:11], thick=12, color=84, lin=2

  device, /close
end
