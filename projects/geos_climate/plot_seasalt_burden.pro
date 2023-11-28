  expid0 = 'S2S1850nrst'
  expid1 = 'S2S1850CO2x4pl'
  expid2 = 'CO2x4sensSS'
  expid3 = 'CO2x4sensNI'

  set_plot, 'ps'
  device, file='plot_seasalt_burden.ps', /color
  !p.font=0


  loadct, 39
  plot, indgen(10), /nodata, $
   xrange=[0,120], yrange=[0,30], ytitle='Burden [Tg]', xtitle='months'


  expand_yyyy, ['1990','1999'], yyyy1, ny, ndaysmonOut
  get_budget_table, expid0, 'SS', yyyy1, $
                    emis, sed, dep, wet, scav, burden, tau
  oplot, indgen(120), burden[0:11,*], thick=6

  expand_yyyy, ['1990','1999'], yyyy1, ny, ndaysmonOut
  get_budget_table, expid1, 'SS', yyyy1, $
                    emis, sed, dep, wet, scav, burden, tau
  oplot, indgen(120), burden[0:11,*], thick=6, color=254

  expand_yyyy, ['1995','2004'], yyyy1, ny, ndaysmonOut
  get_budget_table, expid2, 'SS', yyyy1, $
                    emis, sed, dep, wet, scav, burden, tau
  oplot, indgen(120), burden[0:11,*], thick=6, color=84

  expand_yyyy, ['1995','1999'], yyyy1, ny, ndaysmonOut
  get_budget_table, expid3, 'SS', yyyy1, $
                    emis, sed, dep, wet, scav, burden, tau
  oplot, indgen(120), burden[0:11,*], thick=12, color=254, lin=2

  device, /close

end
