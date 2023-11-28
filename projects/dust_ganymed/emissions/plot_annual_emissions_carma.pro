; Colarco
; June 2012

; Plot the time series of CARMA annual dust and sea salt
; emissions
  years = strpad(findgen(9)+2011,1000)

; Choose im = 0 - 11 for a particular month, 12 for annual mean
  im = 12

; Experiment
  expid = 'bF_F25b9-base-v1.tavg2d_carma_x'
  read_budget_table, expid, 'DU', years, emis, sed, dep, wet, scav, burden, tau, rc=rc
  duem_bF_v1 = reform(emis[im,*])

  expid = 'b_F25b9-base-v1.tavg2d_carma_x'
  read_budget_table, expid, 'DU', years, emis, sed, dep, wet, scav, burden, tau, rc=rc
  duem_b_v1 = reform(emis[im,*])

  expid = 'bF_F25b9-base-v11.tavg2d_carma_x'
  read_budget_table, expid, 'DU', years, emis, sed, dep, wet, scav, burden, tau, rc=rc
  duem_bF_v11 = reform(emis[im,*])

  expid = 'bF_F25b9-base-v10.tavg2d_carma_x'
  read_budget_table, expid, 'DU', years, emis, sed, dep, wet, scav, burden, tau, rc=rc
  duem_bF_v10 = reform(emis[im,*])

  expid = 'c48_aG40-base-v1.tavg2d_carma_x'
  read_budget_table, expid, 'DU', years, emis, sed, dep, wet, scav, burden, tau, rc=rc
  duem_c_v1 = reform(emis[im,*])

  expid = 'c48F_aG40-base-v1.tavg2d_carma_x'
  read_budget_table, expid, 'DU', years, emis, sed, dep, wet, scav, burden, tau, rc=rc
  duem_cF_v1 = reform(emis[im,*])

  expid = 'c48F_aG40-base-v11.tavg2d_carma_x'
  read_budget_table, expid, 'DU', years, emis, sed, dep, wet, scav, burden, tau, rc=rc
  duem_cF_v11 = reform(emis[im,*])

  expid = 'c48F_aG40-base-v15.tavg2d_carma_x'
  read_budget_table, expid, 'DU', years, emis, sed, dep, wet, scav, burden, tau, rc=rc
  duem_cF_v15 = reform(emis[im,*])

  expid = 'c48F_aG40-kok-v15.tavg2d_carma_x'
  read_budget_table, expid, 'DU', years, emis, sed, dep, wet, scav, burden, tau, rc=rc
  duem_cFk_v15 = reform(emis[im,*])


; Plot the different instances
  set_plot, 'ps'
  device, file='annual_emissions_carma.eps', /color, /helvetica, $
          font_size=10, xoff=.5, yoff=.5, xsize=12, ysize=8, /encap
  !p.font=0
  plot, years, /nodata, $
        title='Annual Mean Dust Emissions [Tg]', $
        xtitle='Year', xrange=[2007,2020], xstyle=9, $
        ytitle='Emissions [Tg]', yrange=[1600,2500], ystyle=9, $
        thick=3
  loadct, 39
  oplot, years, duem_b_v1, thick=6             ; no forcing
  oplot, years, duem_bF_v1, thick=6, color=254 ; opac mie
  oplot, years, duem_bF_v11, thick=6, color=208; opac spheroid
  oplot, years, duem_bF_v10, thick=6, color=84; colarco spheroid

  plots, [2008,2009], 1850, thick=6
  xyouts, 2009.5, 1837, 'No Forcing', charsize=.8

  plots, [2008,2009], 1800, thick=6, color=254
  xyouts, 2009.5, 1787, 'OPAC Spheres', charsize=.8

  plots, [2008,2009], 1750, thick=6, color=208
  xyouts, 2009.5, 1737, 'OPAC Spheroids', charsize=.8

  plots, [2008,2009], 1700, thick=6, color=84
  xyouts, 2009.5, 1687, 'OBS Spheroids', charsize=.8


  oplot, years, duem_c_v1, thick=6, lin=2             ; no forcing
  oplot, years, duem_cF_v1, thick=6, color=254, lin=2 ; opac mie
  oplot, years, duem_cF_v11, thick=6, color=208, lin=2; opac spheroid
  oplot, years, duem_cF_v15, thick=6, color=84, lin=2 ; colarco spheroid
  oplot, years, duem_cFk_v15/1.5, thick=6, color=176, lin=2 ; colarco spheroid, kok

  plots, [2014,2015], 1850, thick=6, color=0, lin=2
  xyouts, 2015.5, 1837, 'No Forcing', charsize=.8

  plots, [2014,2015], 1800, thick=6, color=254, lin=2
  xyouts, 2015.5, 1787, 'OPAC Spheres', charsize=.8

  plots, [2014,2015], 1750, thick=6, color=208, lin=2
  xyouts, 2015.5, 1737, 'OPAC Spheroids', charsize=.8

  plots, [2014,2015], 1700, thick=6, color=84, lin=2
  xyouts, 2015.5, 1687, 'OBS Spheroids', charsize=.8

  plots, [2014,2015], 1650, thick=6, color=176, lin=2
  xyouts, 2015.5, 1637, 'OBS Spheroids (Kok) / 1.5', charsize=.8

  device, /close


; Plot the box-whisker plot
  device, file='annual_emissions_carma.stat.eps', /color, /helvetica, $
          font_size=8, xoff=.5, yoff=.5, xsize=14, ysize=9, /encap
  !p.font=0
  plot, findgen(10), /nodata, $
        title='Variability in Dust Emissions', $
        xrange=[0,9], xstyle=9, $
        ytitle='Emissions [Tg]', yrange=[1800,2500], ystyle=9, $
        thick=3, xticks=9, $
        xtickname=make_array(12,val=' '), position=[.15,.2,.95,.95]

  xtickv = findgen(11)
  xtickname=[' ','No!CForcing','(G) No!CForcing',$
                 'OPAC!CSpheres','(G) OPAC!CSpheres', $
                 'OPAC!CSpheroids','(G) OPAC!CSpheroids', $
                 'OBS!CSpheroids','(G) New OBS!CSpheroids', $
                 '(G) New OBS!CSpheroids!C(kok/1.5)']
  for i = 0, 9 do begin
   xyouts, i, 1780, /data, xtickname[i], orient=-60
  endfor

  boxwhisker, duem_b_v1 , 1, .5, 255, medval, qtr_25th, qtr_75th, minval, maxval, meanval, stddv
  boxwhisker, duem_c_v1, 2, .5, 255, medval, qtr_25th, qtr_75th, minval, maxval, meanval, stddv
  boxwhisker, duem_bF_v1, 3, .5, 254, medval, qtr_25th, qtr_75th, minval, maxval, meanval, stddv
  boxwhisker, duem_cF_v1, 4, .5, 254, medval, qtr_25th, qtr_75th, minval, maxval, meanval, stddv
  boxwhisker, duem_bF_v11, 5, .5, 208, medval, qtr_25th, qtr_75th, minval, maxval, meanval, stddv
  boxwhisker, duem_cF_v11, 6, .5, 208, medval, qtr_25th, qtr_75th, minval, maxval, meanval, stddv
  boxwhisker, duem_bF_v10, 7, .5, 84, medval, qtr_25th, qtr_75th, minval, maxval, meanval, stddv
  boxwhisker, duem_cF_v15, 8, .5, 84, medval, qtr_25th, qtr_75th, minval, maxval, meanval, stddv
  boxwhisker, duem_cFk_v15/1.5, 9, .5, 176, medval, qtr_25th, qtr_75th, minval, maxval, meanval, stddv

  device, /close




; Compute the t-statistic -- this result is equivalent to first number
;                            returned by tm_test(x,y)
; I think what is going on here is I'm assuming two series drawn from
; the same population (so, same population variance) and so degrees
; of freedom (df) are nx+ny-2.  This version is from 6.16-6.17 of von
; Storch
  x  = duem_bF_v1
  y  = duem_bF_v1
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
  y  = duem_bF_v1
  tt = tm_test(x,y)
  print, 'no_force/levoni_mie: ', 1.d0-tt[1], correlate(x,y)^2
  y  = duem_bF_v1
  tt = tm_test(x,y)
  print, 'no_force/levoni_ell: ', 1.d0-tt[1], correlate(x,y)^2

  x  = duem_bF_v1
  y  = duem_bF_v1
  tt = tm_test(x,y)
  print, 'opac_mie/levoni_mie: ', 1.d0-tt[1], correlate(x,y)^2

  x  = duem_bF_v1
  y  = duem_bF_v1
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
