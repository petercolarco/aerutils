  expid0 = 'S2S1850nrst'
  expid1 = 'S2S1850CO2x4pl'
  expid2 = 'CO2x4sensSS'

  set_plot, 'ps'
  device, file='plot_nitrate_pno3aq.ps', /color
  !p.font=0


  loadct, 39
  plot, indgen(10), /nodata, $
   xrange=[0,120], yrange=[-2,0], $
   ytitle='Nitrate Aqueous Production/Loss [Tg]', xtitle='months'


  expand_yyyy, ['1990','1999'], yyyy1, ny, ndaysmonOut
  get_budget_table, expid0, 'NI', yyyy1, $
                    emis, sed, dep, wet, scav, burden, tau, pno3aq=pno3aq
  oplot, indgen(120), pno3aq[0:11,*], thick=6


  expand_yyyy, ['1945','1954'], yyyy1, ny, ndaysmonOut
  get_budget_table, expid1, 'NI', yyyy1, $
                    emis, sed, dep, wet, scav, burden, tau, pno3aq=pno3aq
  oplot, indgen(120), pno3aq[0:11,*], thick=6, color=254

  expand_yyyy, ['1995','2004'], yyyy1, ny, ndaysmonOut
  get_budget_table, expid2, 'NI', yyyy1, $
                    emis, sed, dep, wet, scav, burden, tau, pno3aq=pno3aq
  oplot, indgen(120), pno3aq[0:11,*], thick=6, color=84

  device, /close

end
