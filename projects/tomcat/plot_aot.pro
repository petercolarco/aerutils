; Colarco, April 2016
; Get vertical extinction profile

  filetemplate = 'H43F2010gocart2.tavg2d_carma_x.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  a = where(nymd lt 20120602L)
  nymd = nymd[a]
  nhms = nhms[a]
  filename=strtemplate(template,nymd,nhms)
  nf = n_elements(filename)
  nc4readvar, filename, 'suexttau', su, lon=lon, lat=lat

  nx = n_elements(lon)
  ny = n_elements(lat)

  su = su*1000.

; Make a plot of the global AOD difference
  set_plot, 'ps'
  device, file='plot_aot_diff.ps', /helvetica, font_size=14, /color, $
   xsize=24, ysize=12, xoff=.5, yoff=.5
  !p.font=0
  loadct, 0
  plot, findgen(nf), ts_smooth(aod[*,0]-aod[*,3],7), /nodata, $
   yrange=[-.15,.15], ytitle='Fractional Uncertainty in Global AOD', $
   xrange=[-1,nf], xticks=xticks-1, xtickv=xtickv, $
   xtickn=make_array(xticks,val=' '), $
   xstyle=1, ystyle=9, yticks=6, yminor=5, $
   position=[.1,.25,.9,.95]
  loadct, 39
;  oplot, findgen(nf), ts_smooth((aod[*,3]-aod[*,0])/aod[*,0],30), thick=6, color=254
;  oplot, findgen(nf), ts_smooth((aod[*,2]-aod[*,0])/aod[*,0],30), thick=6, color=144
;  oplot, findgen(nf), ts_smooth((aod[*,1]-aod[*,0])/aod[*,0],30), thick=6, color=84
  oplot, findgen(nf), (aod[*,3]-aod[*,0])/aod[*,0], thick=6, color=254
  oplot, findgen(nf), (aod[*,2]-aod[*,0])/aod[*,0], thick=6, color=144
  oplot, findgen(nf), (aod[*,1]-aod[*,0])/aod[*,0], thick=6, color=84
  plots, [30,50], .115, thick=6, color=254
  plots, [30,50], .1, thick=6, color=144
  plots, [30,50], .085, thick=6, color=84
  xyouts, 53, .11, 'OMPS-like sampling (22.5!Eo!N)', charsize=.75
  xyouts, 53, .095, 'Sampling 15!Eo!N', charsize=.75
  xyouts, 53, .08, 'Sampling 7.5!Eo!N', charsize=.75
  xyouts, xtickv, -.16, nymd[xtickv], align=0, charsize=.5
  loadct, 0
  plots, [30,50], .13, thick=6, color=120
  xyouts, 53, .125, 'Global Mean AOD (Full Sampling, right axis)', charsize=.75
  axis, yaxis=1, yrange=[0,0.05], yticks=5, yminor=2, $
        ytitle='Global Mean AOD (Full Sampling)', /save
  oplot, findgen(nf), aod[*,0]/1000., thick=6, color=120
  
  device, /close

; Make a plot of the global AOD difference
  set_plot, 'ps'
  device, file='plot_aot.ps', /helvetica, font_size=14, /color, $
   xsize=24, ysize=12, xoff=.5, yoff=.5
  !p.font=0
  loadct, 0
  plot, findgen(nf), ts_smooth(aod[*,0]-aod[*,3],7), /nodata, $
   yrange=[0.02,.05], ytitle='Global AOD', $
   xrange=[-1,nf], xticks=xticks-1, xtickv=xtickv, $
   xtickn=make_array(xticks,val=' '), $
   xstyle=1, ystyle=1, yticks=3, yminor=5, $
   position=[.1,.25,.9,.95]
  loadct, 39
  oplot, findgen(nf), aod[*,3]/1000., thick=6, color=254
  oplot, findgen(nf), aod[*,2]/1000., thick=6, color=144
  oplot, findgen(nf), aod[*,1]/1000., thick=6, color=84
  plots, [30,50], .046, thick=6, color=254
  plots, [30,50], .044, thick=6, color=144
  plots, [30,50], .042, thick=6, color=84
  xyouts, 53, .0455, 'OMPS-like sampling (22.5!Eo!N)', charsize=.75
  xyouts, 53, .0435, 'Sampling 15!Eo!N', charsize=.75
  xyouts, 53, .0415, 'Sampling 7.5!Eo!N', charsize=.75
  xyouts, xtickv, .018, nymd[xtickv], align=0, charsize=.5
  loadct, 0
  plots, [30,50], .048, thick=6, color=120
  xyouts, 53, .0475, 'Global Mean AOD (Full Sampling, right axis)', charsize=.75
  oplot, findgen(nf), aod[*,0]/1000., thick=6, color=120
  
  device, /close

end
