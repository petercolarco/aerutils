;goto, jump
  expid = 'c48F_G41-spin'
  filetemplate = expid+'.tavg2d_aer_x.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'suexttau', suexttau_spin, lon=lon, lat=lat

  expid = 'c48F_G41-nopin'
  filetemplate = expid+'.tavg2d_aer_x.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'suexttau', suexttau_nopin, lon=lon, lat=lat

  expid = 'c48F_G41-pin'
  filetemplate = expid+'.tavg2d_carma_x.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'suexttau', suexttau_c, lon=lon, lat=lat

  expid = 'c48F_G41-pintc'
  filetemplate = expid+'.p.tavg2d_aer_x.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'suexttau', suexttau_t_pin, lon=lon, lat=lat
  nc4readvar, filename, 'suexttauvolc', suexttau_v_pin, lon=lon, lat=lat

  expid = 'c48F_G41-pintc'
  filetemplate = expid+'.tavg2d_carma_x.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'suexttau', suexttau_v_c, lon=lon, lat=lat


; Global area average
  area, lon, lat, nx, ny, dx, dy, area, grid='b'
  suext_spin  = aave(suexttau_spin,area)
  suext_nopin = aave(suexttau_nopin,area)
  suext_t_pin = aave(suexttau_t_pin,area)
  suext_v_pin = aave(suexttau_v_pin,area)
  suext_c     = aave(suexttau_c,area)
  suext_v_c   = aave(suexttau_v_c,area)
; Add on the baseline
  suext_t_pin = [suext_spin[0:71],suext_t_pin]
  suext_v_pin = [make_array(72,val=0.),suext_v_pin]
jump:
  set_plot, 'ps'
  device, file='plot_global_total.'+expid+'.ps', /helvetica, font_size=12, /color, $
    xsize=18, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  x = indgen(n_elements(nymd))
  xmax = max(x)
  xyrs = n_elements(x)/12
  xtickname = string(nymd[0:xmax:12]/10000L,format='(i4)')
  xtickname[1:xyrs-1:2] = ' '
  plot, x, suext_spin, /nodata, $
   position=[.15,.2,.85,.9], $
   xstyle=1, xminor=2, xticks=xyrs, xrange=[0,xmax+1], $
   xtickname=[xtickname,' '], $
   ystyle=1, yrange=[0,0.3], $
   yticks=6, ytitle = 'AOT'

  red   = [228,55,77,152]
  green = [26,126,175,78]
  blue  = [28,184,74,163]
  tvlct, red, green, blue
  dcolors=indgen(n_elements(red))

  oplot, x, suext_spin, thick=6, color=0
  oplot, x, suext_t_pin+suext_v_pin, thick=6, color=1
  oplot, x, suext_v_pin, thick=6, color=1, lin=2
  oplot, x, suext_nopin, thick=6, color=2
  oplot, x, suext_c, thick=6, color=3
  oplot, x, suext_v_c, thick=6, color=3, lin=2

  xyouts, 113, .27, 'Pinatubo as tropopheric', color=0
  xyouts, 113, .25, 'Pinatubo as volcanic', color=1
  xyouts, 113, .23, 'No Pinatubo', color=2
  plots, [113,130], .215, color=1, lin=2, thick=6
  xyouts, 133, .21, 'Pinatubo (only)!Cas volcanic', color=1
  xyouts, 113, .17, 'CARMA OCS produced', color=3
  plots, [113,130], .155, color=3, lin=2, thick=6
;  xyouts, 133, .15, 'CARMA Pinatubo+!COCS produced', color=3
  xyouts, 133, .15, 'CARMA All Sources', color=3

  device, /close

end
