; Colarco
; June 2012

; Plot the time series of CARMA annual dust and sea salt
; emissions
  years = strpad(findgen(40)+2011,1000)

; Choose im = 0 - 11 for a particular month, 12 for annual mean
  im = 12

; Experiment
  expid = 'bF_F25b9-base-v1.tavg2d_carma_x.asia'
  read_budget_table, expid, 'DU', years, emis, sed, dep, wet, scav, burden, tau, rc=rc
  duem_bF_v1 = reform(emis[im,*])

  expid = 'bF_F25b9-base-v5.tavg2d_carma_x.asia'
  read_budget_table, expid, 'DU', years, emis, sed, dep, wet, scav, burden, tau, rc=rc
  duem_bF_v5 = reform(emis[im,*])

  expid = 'bF_F25b9-base-v6.tavg2d_carma_x.asia'
  read_budget_table, expid, 'DU', years, emis, sed, dep, wet, scav, burden, tau, rc=rc
  duem_bF_v6 = reform(emis[im,*])

  expid = 'bF_F25b9-base-v7.tavg2d_carma_x.asia'
  read_budget_table, expid, 'DU', years, emis, sed, dep, wet, scav, burden, tau, rc=rc
  duem_bF_v7 = reform(emis[im,*])

  expid = 'b_F25b9-base-v1.tavg2d_carma_x.asia'
  read_budget_table, expid, 'DU', years, emis, sed, dep, wet, scav, burden, tau, rc=rc
  duem_b_v1 = reform(emis[im,*])

  expid = 'bF_F25b9-base-v8.tavg2d_carma_x.asia'
  read_budget_table, expid, 'DU', years, emis, sed, dep, wet, scav, burden, tau, rc=rc
  duem_bF_v8 = reform(emis[im,*])

  expid = 'bF_F25b9-base-v10.tavg2d_carma_x.asia'
  read_budget_table, expid, 'DU', years, emis, sed, dep, wet, scav, burden, tau, rc=rc
  duem_bF_v10 = reform(emis[im,*])

  expid = 'bF_F25b9-base-v11.tavg2d_carma_x.asia'
  years_ = strpad(findgen(17)+2011,1000)
  read_budget_table, expid, 'DU', years, emis, sed, dep, wet, scav, burden, tau, rc=rc
  duem_bF_v11 = reform(emis[im,*])

  expid = 'bF_F25b9-kok-v11.tavg2d_carma_x.asia'
  years_ = strpad(findgen(17)+2011,1000)
  read_budget_table, expid, 'DU', years, emis, sed, dep, wet, scav, burden, tau, rc=rc
  duem_bF_kok = reform(emis[im,*])


; Plot the different instances
  set_plot, 'ps'
  device, file='annual_emissions_carma.asia.ps', /color, /helvetica, $
          font_size=10, xoff=.5, yoff=.5, xsize=12, ysize=8
  !p.font=0
  plot, years, /nodata, $
        title='Annual Mean Dust Emissions [Tg]', $
        xtitle='Year', xrange=[2010,2050], xstyle=9, $
        ytitle='Emissions [Tg]', yrange=[1200,2000], ystyle=9, $
        thick=3
  oplot, years, duem_b_v1, thick=6                    ; no forcing
  loadct, 39
  oplot, years, duem_bF_v1, thick=6, color=254        ; opac mie
  oplot, years, duem_bF_v6, thick=6, color=84         ; levoni mie
  oplot, years, duem_bF_v5, thick=6, color=84, lin=2  ; levoni ellipse
  oplot, years, duem_bF_v8, thick=6, color=208        ; colarco mie
  oplot, years, duem_bF_v10, thick=6, color=208, lin=1; colarco spheroid
  oplot, years, duem_bF_v11, thick=6, color=254, lin=1; opac spheroid
  oplot, years, duem_bF_v7, thick=6, color=254, lin=2; opac ellipsoid
;  oplot, years, duem_bF_kok, thick=6, color=176      ; kok sphere, v1 optics

  plots, [2012,2016], 1900, thick=6
  xyouts, 2017, 1887, 'No Forcing', charsize=.8

  plots, [2012,2016], 1850, thick=6, color=254
  xyouts, 2017, 1837, 'OPAC-Spheres', charsize=.8

  plots, [2012,2016], 1800, thick=6, color=254, lin=2
  xyouts, 2017, 1787, 'OPAC-Ellipsoids', charsize=.8

  plots, [2012,2016], 1750, thick=6, color=254, lin=1
  xyouts, 2017, 1737, 'OPAC-Spheroids', charsize=.8

  plots, [2032,2036], 1900, thick=6, color=84
  xyouts, 2037, 1887, 'SF-Spheres', charsize=.8

  plots, [2032,2036], 1850, thick=6, color=84, lin=2
  xyouts, 2037, 1837, 'SF-Ellipsoids', charsize=.8

  plots, [2032,2036], 1800, thick=6, color=208
  xyouts, 2037, 1787, 'OBS-Spheres', charsize=.8

  plots, [2032,2036], 1750, thick=6, color=208, lin=1
  xyouts, 2037, 1737, 'OBS-Spheroids', charsize=.8

;  plots, [2012,2015], 1900, thick=6, color=254
;  plots, [2012,2015], 1850, thick=6, color=254, lin=2
;  plots, [2012,2015], 1775, thick=6, color=254, lin=1
;  plots, [2024,2027], 1900, thick=6, color=84
;  plots, [2024,2027], 1850, thick=6, color=84, lin=2
;  plots, [2024,2027], 1775, thick=6
;  plots, [2037,2040], 1890, thick=6, color=208
;  plots, [2037,2040], 1840, thick=6, color=208, lin=1
;;  plots, [2037,2040], 1765, thick=6, color=176
  
;  xyouts, 2016, 1887, 'OPAC', charsize=.8
;  xyouts, 2016, 1837, 'OPAC!C(Ellipsoid)', charsize=.8
;  xyouts, 2016, 1762, 'OPAC!C(Spheroid)', charsize=.8
;  xyouts, 2028, 1887, 'Shettle/Fenn', charsize=.8
;  xyouts, 2028, 1837, 'Shettle/Fenn!C(Ellipsoid)', charsize=.8
;  xyouts, 2028, 1762, 'No Forcing', charsize=.8
;  xyouts, 2041, 1877, 'Colarco/Kim', charsize=.8
;  xyouts, 2041, 1827, 'Colarco/Kim!C(Spheroid)', charsize=.8
;;  xyouts, 2041, 1752, 'Kok w/OPAC Mie', charsize=.8

  device, /close


; Plot the box-whisker plot
  device, file='annual_emissions_carma.asia.stat.ps', /color, /helvetica, $
          font_size=8, xoff=.5, yoff=.5, xsize=14, ysize=9
  !p.font=0
  plot, findgen(10), /nodata, $
        title='Variability in Dust Emissions', $
        xrange=[0,9], xstyle=9, $
        ytitle='Emissions [Tg]', yrange=[1200,1800], ystyle=9, $
        thick=3, xticks=9, $
        xtickname=make_array(12,val=' '), position=[.15,.2,.95,.95]

  xtickv = findgen(11)
  xtickname=[' ','No!CForcing','OPAC!CSpheres','OPAC!CEllipsoids','OPAC!CSpheroids',$
                 'SF-Spheres','SF-Ellipsoids', $
                 'OBS-Spheres','OBS!CSpheroids','Kok!Cw/OPAC Mie',' ']
  for i = 0, 8 do begin
   xyouts, i, 1180, /data, xtickname[i], orient=-60
  endfor

  boxwhisker, duem_b_v1 , 1, .5, 255, medval, qtr_25th, qtr_75th, minval, maxval, meanval, stddv
print, 'b_v1:  ', meanval, stddv
  boxwhisker, duem_bF_v1, 2, .5, 254, medval, qtr_25th, qtr_75th, minval, maxval, meanval, stddv
print, 'bF_v1:  ', meanval, stddv
  boxwhisker, duem_bF_v7, 3, .5, 254, medval, qtr_25th, qtr_75th, minval, maxval, meanval, stddv
print, 'bF_v7:  ', meanval, stddv
  boxwhisker, duem_bF_v11, 4, .5, 254, medval, qtr_25th, qtr_75th, minval, maxval, meanval, stddv
print, 'bF_v11:  ', meanval, stddv
  boxwhisker, duem_bF_v6, 5, .5, 84, medval, qtr_25th, qtr_75th, minval, maxval, meanval, stddv
print, 'bF_v6:  ', meanval, stddv
  boxwhisker, duem_bF_v5, 6, .5, 84, medval, qtr_25th, qtr_75th, minval, maxval, meanval, stddv
print, 'bF_v5:  ', meanval, stddv
  boxwhisker, duem_bF_v8, 7, .5, 208, medval, qtr_25th, qtr_75th, minval, maxval, meanval, stddv
print, 'bF_v8:  ', meanval, stddv
  boxwhisker, duem_bF_v10, 8, .5, 208, medval, qtr_25th, qtr_75th, minval, maxval, meanval, stddv
print, 'bF_v10:  ', meanval, stddv
;  boxwhisker, duem_bF_kok, 9, .5, 176, medval, qtr_25th, qtr_75th, minval, maxval, meanval, stddv

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
