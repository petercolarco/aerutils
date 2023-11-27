; Colarco
; June 2012

; Plot the time series of CARMA annual dust and sea salt
; emissions
  years = strpad(findgen(40)+2011,1000)

; Choose im = 0 - 11 for a particular month, 12 for annual mean
  im = 12

; Experiment
  expid = 'bF_F25b9-base-v1.tavg2d_carma_x'
  read_budget_table, expid, 'DU', years, emis, sed, dep, wet, scav, burden, tau, rc=rc
  tau_bF_v1 = reform(tau[im,*])

  expid = 'bF_F25b9-base-v5.tavg2d_carma_x'
  read_budget_table, expid, 'DU', years, emis, sed, dep, wet, scav, burden, tau, rc=rc
  tau_bF_v5 = reform(tau[im,*])

  expid = 'bF_F25b9-base-v6.tavg2d_carma_x'
  read_budget_table, expid, 'DU', years, emis, sed, dep, wet, scav, burden, tau, rc=rc
  tau_bF_v6 = reform(tau[im,*])

  expid = 'bF_F25b9-base-v7.tavg2d_carma_x'
  read_budget_table, expid, 'DU', years, emis, sed, dep, wet, scav, burden, tau, rc=rc
  tau_bF_v7 = reform(tau[im,*])

  expid = 'b_F25b9-base-v1.tavg2d_carma_x'
  read_budget_table, expid, 'DU', years, emis, sed, dep, wet, scav, burden, tau, rc=rc
  tau_b_v1 = reform(tau[im,*])

  expid = 'bF_F25b9-base-v8.tavg2d_carma_x'
  read_budget_table, expid, 'DU', years, emis, sed, dep, wet, scav, burden, tau, rc=rc
  tau_bF_v8 = reform(tau[im,*])

  expid = 'bF_F25b9-base-v10.tavg2d_carma_x'
  read_budget_table, expid, 'DU', years, emis, sed, dep, wet, scav, burden, tau, rc=rc
  tau_bF_v10 = reform(tau[im,*])

  expid = 'bF_F25b9-base-v11.tavg2d_carma_x'
  years_ = strpad(findgen(17)+2011,1000)
  read_budget_table, expid, 'DU', years, emis, sed, dep, wet, scav, burden, tau, rc=rc
  tau_bF_v11 = reform(tau[im,*])

  expid = 'bF_F25b9-kok-v1.tavg2d_carma_x'
  years_ = strpad(findgen(17)+2011,1000)
  read_budget_table, expid, 'DU', years, emis, sed, dep, wet, scav, burden, tau, rc=rc
  tau_bF_kok = reform(tau[im,*])


; Plot the different instances
  set_plot, 'ps'
  device, file='annual_aot_carma.ps', /color, /helvetica, $
          font_size=10, xoff=.5, yoff=.5, xsize=12, ysize=8
  !p.font=0
  plot, years, /nodata, $
        title='Annual Mean Dust AOT', $
        xtitle='Year', xrange=[2010,2050], xstyle=9, $
        ytitle='AOT', yrange=[0,.04], ystyle=9, $
        thick=3
  oplot, years, tau_b_v1, thick=6                    ; no forcing
  loadct, 39
  oplot, years, tau_bF_v1, thick=6, color=254        ; opac mie
  oplot, years, tau_bF_v6, thick=6, color=84         ; levoni mie
  oplot, years, tau_bF_v5, thick=6, color=84, lin=2  ; levoni ellipse
  oplot, years, tau_bF_v8, thick=6, color=208        ; colarco mie
  oplot, years, tau_bF_v10, thick=6, color=208, lin=1; colarco spheroid
  oplot, years, tau_bF_v11, thick=6, color=254, lin=1; opac spheroid
  oplot, years, tau_bF_v7, thick=6, color=254, lin=2; opac ellipsoid
  oplot, years, tau_bF_kok, thick=6, color=176      ; kok sphere, v1 optics

  plots, [2012,2015], 0.015, thick=6, color=254
  plots, [2012,2015], 0.010, thick=6, color=254, lin=2
  plots, [2012,2015], 0.005, thick=6, color=254, lin=1
  plots, [2024,2027], 0.015, thick=6, color=84
  plots, [2024,2027], 0.010, thick=6, color=84, lin=2
  plots, [2024,2027], 0.005, thick=6
  plots, [2037,2040], 0.015, thick=6, color=208
  plots, [2037,2040], 0.010, thick=6, color=208, lin=1
  plots, [2037,2040], 0.005, thick=6, color=176
  
  xyouts, 2016, 0.014, 'OPAC', charsize=.8
  xyouts, 2016, 0.009, 'OPAC!C(Ellipsoid)', charsize=.8
  xyouts, 2016, 0.004, 'OPAC!C(Spheroid)', charsize=.8
  xyouts, 2028, 0.014, 'Shettle/Fenn', charsize=.8
  xyouts, 2028, 0.009, 'Shettle/Fenn!C(Ellipsoid)', charsize=.8
  xyouts, 2028, 0.004, 'No Forcing', charsize=.8
  xyouts, 2041, 0.014, 'Colarco/Kim', charsize=.8
  xyouts, 2041, 0.009, 'Colarco/Kim!C(Spheroid)', charsize=.8
  xyouts, 2041, 0.004, 'Kok w/OPAC Mie', charsize=.8

  device, /close



; Plot the box-whisker plot
  device, file='annual_aot_carma.stat.ps', /color, /helvetica, $
          font_size=8, xoff=.5, yoff=.5, xsize=14, ysize=9
  !p.font=0
  plot, findgen(10), /nodata, $
        title='Variability in Dust AOT', $
        xrange=[0,9], xstyle=9, $
        ytitle='AOT', yrange=[0.015,0.033], ystyle=9, $
        thick=3, xticks=9, $
        xtickname=make_array(12,val=' '), position=[.15,.2,.95,.95]

  xtickv = findgen(11)
  xtickname=[' ','No!CForcing','OPAC','OPAC!C(Ellipsoid)','OPAC!C(Spheroid)',$
                 'Shettle/Fenn','Shettle/Fenn!C(Ellipsoid)', $
                 'Colarco/Kim','Colarco/Kim!C(Spheroid)','Kok!Cw/OPAC Mie',' ']
  for i = 0, 8 do begin
   xyouts, i, .0145, /data, xtickname[i], orient=-60
  endfor

  boxwhisker, tau_b_v1 , 1, .5, 255, medval, qtr_25th, qtr_75th, minval, maxval, meanval, stddv
  boxwhisker, tau_bF_v1, 2, .5, 254, medval, qtr_25th, qtr_75th, minval, maxval, meanval, stddv
  boxwhisker, tau_bF_v7, 3, .5, 254, medval, qtr_25th, qtr_75th, minval, maxval, meanval, stddv
  boxwhisker, tau_bF_v11, 4, .5, 254, medval, qtr_25th, qtr_75th, minval, maxval, meanval, stddv
  boxwhisker, tau_bF_v6, 5, .5, 84, medval, qtr_25th, qtr_75th, minval, maxval, meanval, stddv
  boxwhisker, tau_bF_v5, 6, .5, 84, medval, qtr_25th, qtr_75th, minval, maxval, meanval, stddv
  boxwhisker, tau_bF_v8, 7, .5, 208, medval, qtr_25th, qtr_75th, minval, maxval, meanval, stddv
  boxwhisker, tau_bF_v10, 8, .5, 208, medval, qtr_25th, qtr_75th, minval, maxval, meanval, stddv
;  boxwhisker, tau_bF_kok, 9, .5, 176, medval, qtr_25th, qtr_75th, minval, maxval, meanval, stddv

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
