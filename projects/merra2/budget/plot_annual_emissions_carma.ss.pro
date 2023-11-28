; Colarco
; June 2012

; Plot the time series of CARMA annual dust and sea salt
; emissions
  years = strpad(findgen(40)+2011,1000)

; Choose im = 0 - 11 for a particular month, 12 for annual mean
  im = 12

; Experiment
  expid = 'bF_F25b9-base-v1.tavg2d_carma_x'
  read_budget_table, expid, 'SS', years, emis, sed, dep, wet, scav, burden, tau, rc=rc
  duem_bF_v1 = reform(emis[im,*])

  expid = 'bF_F25b9-base-v5.tavg2d_carma_x'
  read_budget_table, expid, 'SS', years, emis, sed, dep, wet, scav, burden, tau, rc=rc
  duem_bF_v5 = reform(emis[im,*])

  expid = 'bF_F25b9-base-v6.tavg2d_carma_x'
  read_budget_table, expid, 'SS', years, emis, sed, dep, wet, scav, burden, tau, rc=rc
  duem_bF_v6 = reform(emis[im,*])

  expid = 'bF_F25b9-base-v7.tavg2d_carma_x'
  read_budget_table, expid, 'SS', years, emis, sed, dep, wet, scav, burden, tau, rc=rc
  duem_bF_v7 = reform(emis[im,*])

  expid = 'b_F25b9-base-v1.tavg2d_carma_x'
  read_budget_table, expid, 'SS', years, emis, sed, dep, wet, scav, burden, tau, rc=rc
  duem_b_v1 = reform(emis[im,*])

; Plot the different instances
  set_plot, 'ps'
  device, file='annual_emissions_carma.ss.ps', /color, /helvetica, $
          font_size=10, xoff=.5, yoff=.5, xsize=12, ysize=8
  !p.font=0
  plot, years, /nodata, $
        title='Annual Mean Sea Salt Emissions [Tg]', $
        xtitle='Year', xrange=[2010,2050], xstyle=9, $
        ytitle='Emissions [Tg]', yrange=[5000,6500], ystyle=9, $
        thick=3
  oplot, years, duem_b_v1, thick=6                   ; no forcing
  loadct, 39
  oplot, years, duem_bF_v1, thick=6, color=254       ; opac mie
  oplot, years, duem_bF_v6, thick=6, color=84        ; levoni mie
  oplot, years, duem_bF_v5, thick=6, color=84, lin=2 ; levoni ellipse
  plots, [2012,2016], 5300, thick=6
  plots, [2012,2016], 5200, thick=6, color=254
  plots, [2026,2030], 5300, thick=6, color=84
  plots, [2026,2030], 5200, thick=6, color=84, lin=2
  xyouts, 2017, 5270, 'No Forcing'
  xyouts, 2017, 5170, 'OPAC'
  xyouts, 2031, 5270, 'Levoni'
  xyouts, 2031, 5170, 'Levoni (Ellipse)'

  device, /close
; Compute the t-statistic -- this result is equivalent to first number
;                            returned by tm_test(x,y)
; I think what is going on here is I'm assuming two series drawn from
; the same population (so, same population variance) and so degrees
; of freedom (df) are nx+ny-2.  This version is from 6.16-6.17 of von
; Storch
  x  = duem_bF_v1
  y  = duem_bF_v6
  nx = n_elements(x)
  ny = n_elements(y)
  df = nx+ny-2.
  sp2 = (total( (x-mean(x))^2.) + total( (y-mean(y))^2.)) / df
  t   = (mean(x)-mean(y)) / (sqrt(sp2)*sqrt(1./nx + 1./ny))
  tt  = tm_test(x,y)
;  print, tt[0], 1.d0-tt[1]

; Paired
  tt  = tm_test(x,y,/paired)
;  print, tt[0], 1.d0-tt[1]

; Unequal - unequal population variances
  tt  = tm_test(x,y,/unequal)
;  print, tt[0], 1.d0-tt[1]

; Print the simple t-statistics for pairs
  x  = duem_b_v1
  y  = duem_bF_v1
  tt = tm_test(x,y)
  print, 'no_force/opac_mie: ', 1.d0-tt[1], correlate(x,y)^2
  y  = duem_bF_v6
  tt = tm_test(x,y)
  print, 'no_force/levoni_mie: ', 1.d0-tt[1], correlate(x,y)^2
  y  = duem_bF_v5
  tt = tm_test(x,y)
  print, 'no_force/levoni_ell: ', 1.d0-tt[1], correlate(x,y)^2

  x  = duem_bF_v1
  y  = duem_bF_v6
  tt = tm_test(x,y)
  print, 'opac_mie/levoni_mie: ', 1.d0-tt[1], correlate(x,y)^2

  x  = duem_bF_v6
  y  = duem_bF_v5
  tt = tm_test(x,y)
  print, 'levoni_mie/levoni_ell: ', 1.d0-tt[1], correlate(x,y)^2

; Notes: behavior /unequal, /paired, nothing similar
; v5 (Levoni non spherical) is less different from
; no forcing than others in annual mean (about 90%)
; but is distinctly different in June mean.
; Levoni Mie and Levoni Ellipse are only different at 
; about the 80% level in the annual mean and not at all
; in the June mean (although other months have some difference).

end
