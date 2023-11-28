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
  tau_bF_v1 = reform(tau[im,*])

  expid = 'bF_F25b9-base-v5.tavg2d_carma_x'
  read_budget_table, expid, 'SS', years, emis, sed, dep, wet, scav, burden, tau, rc=rc
  tau_bF_v5 = reform(tau[im,*])

  expid = 'bF_F25b9-base-v6.tavg2d_carma_x'
  read_budget_table, expid, 'SS', years, emis, sed, dep, wet, scav, burden, tau, rc=rc
  tau_bF_v6 = reform(tau[im,*])

  expid = 'bF_F25b9-base-v7.tavg2d_carma_x'
  read_budget_table, expid, 'SS', years, emis, sed, dep, wet, scav, burden, tau, rc=rc
  tau_bF_v7 = reform(tau[im,*])

  expid = 'b_F25b9-base-v1.tavg2d_carma_x'
  read_budget_table, expid, 'SS', years, emis, sed, dep, wet, scav, burden, tau, rc=rc
  tau_b_v1 = reform(tau[im,*])

; Plot the different instances
  set_plot, 'ps'
  device, file='annual_aot_carma.ss.ps', /color, /helvetica, $
          font_size=10, xoff=.5, yoff=.5, xsize=12, ysize=8
  !p.font=0
  plot, years, /nodata, $
        title='Annual Mean Sea Salt AOT', $
        xtitle='Year', xrange=[2010,2050], xstyle=9, $
        ytitle='AOT', yrange=[0,.04], ystyle=9, $
        thick=3
  oplot, years, tau_b_v1, thick=6                   ; no forcing
  loadct, 39
  oplot, years, tau_bF_v1, thick=6, color=254       ; opac mie
  oplot, years, tau_bF_v6, thick=6, color=84        ; levoni mie
  oplot, years, tau_bF_v5, thick=6, color=84, lin=2 ; levoni ellipse
  plots, [2012,2016], 0.01, thick=6
  plots, [2012,2016], 0.005, thick=6, color=254
  plots, [2026,2030], 0.01, thick=6, color=84
  plots, [2026,2030], 0.005, thick=6, color=84, lin=2
  xyouts, 2017, 0.009, 'No Forcing'
  xyouts, 2017, 0.004, 'OPAC'
  xyouts, 2031, 0.009, 'Levoni'
  xyouts, 2031, 0.004, 'Levoni (Ellipse)'

  device, /close
; Compute the t-statistic -- this result is equivalent to first number
;                            returned by tm_test(x,y)
; I think what is going on here is I'm assuming two series drawn from
; the same population (so, same population variance) and so degrees
; of freedom (df) are nx+ny-2.  This version is from 6.16-6.17 of von
; Storch
  x  = tau_bF_v1
  y  = tau_bF_v6
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
  x  = tau_b_v1
  y  = tau_bF_v1
  tt = tm_test(x,y)
  print, 'no_force/opac_mie: ', 1.d0-tt[1], correlate(x,y)^2
  y  = tau_bF_v6
  tt = tm_test(x,y)
  print, 'no_force/levoni_mie: ', 1.d0-tt[1], correlate(x,y)^2
  y  = tau_bF_v5
  tt = tm_test(x,y)
  print, 'no_force/levoni_ell: ', 1.d0-tt[1], correlate(x,y)^2

  x  = tau_bF_v1
  y  = tau_bF_v6
  tt = tm_test(x,y)
  print, 'opac_mie/levoni_mie: ', 1.d0-tt[1], correlate(x,y)^2

  x  = tau_bF_v6
  y  = tau_bF_v5
  tt = tm_test(x,y)
  print, 'levoni_mie/levoni_ell: ', 1.d0-tt[1], correlate(x,y)^2

; Notes: all pairs tested are significantly different at at least 99%
; confidence except the opac mie/levoni mie pair.  The time series
; are largely uncorrelated.

end
