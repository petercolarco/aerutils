  expid = 'c48_aG40-gcocs-spin'
  filetemplate = expid+'.tavg2d_aer_x.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'suexttau', suexttau_g, lon=lon, lat=lat
  nc4readvar, filename, 'so4cmass', sucmass_g, lon=lon, lat=lat

  filetemplate = expid+'.tavg2d_carma_x.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'suexttau', suexttau_c, lon=lon, lat=lat
  nc4readvar, filename, 'sucmass', sucmass_c, lon=lon, lat=lat

;################
; I'm fixing a bug in the optical tables used to generate carma
; suexttau: scale up by factor 2.8 based on comparison to correct
; tables prior to 2010 (volc)
;################
  suexttau_c[*,*,0:102] = suexttau_c[*,*,0:102]*2.8

; Global area average
  area, lon, lat, nx, ny, dx, dy, area, grid='b'
  suext_g = aave(suexttau_g,area)
  sucm_g  = aave(sucmass_g,area)
  suext_c = aave(suexttau_c,area)
  sucm_c  = aave(sucmass_c,area)

  set_plot, 'ps'
  device, file='plot_global.'+expid+'.ps', /helvetica, font_size=12, /color, $
    xsize=18, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  x = indgen(n_elements(nymd))
  plot, x, suext_g, /nodata, $
   position=[.15,.2,.85,.9], $
   xstyle=1, xticks=11, $
   xtickname=[string(nymd[0:131:12]/10000L,format='(i4)'),' '], $
   ystyle=9, yrange=[0,0.004], $
   yticks=8, ytitle = 'AOT'

  red   = [246,208,166,103,54,2,1]
  blue  = [239,209,189,169,144,129]
  green = [247,230,219,207,192,138,80]
  tvlct, red, green, blue
  dcolors=indgen(n_elements(red))

  plots, [5,12], .0037, thick=3, color=5
  plots, [5,12], .0034, thick=3, color=6
  xyouts, 13, .00365, 'GOCART', color=5
  xyouts, 13, .00335, 'CARMA', color=6

  plots, [45,52], .0037, thick=3, color=6
  plots, [45,52], .0034, thick=3, color=6, lin=2
  xyouts, 53, .00365, 'AOT', color=6
  xyouts, 53, .00335, 'Sulfate Mass', color=6

  oplot, x, suext_g, thick=3, color=5
  oplot, x, suext_c, thick=3, color=6

  axis, yaxis=1, yrange=[0,0.4], yticks=8, $
        ytitle='Sulfate Mass [Tg]', /save, color=6, ymin=1
  oplot, x, sucm_g*5.1e5, thick=3, color=5, lin=2
  oplot, x, sucm_c*5.1e5, thick=3, color=6, lin=2

  device, /close



end
