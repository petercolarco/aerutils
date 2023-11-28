; From model calculations, grab the model AOT and plot
  modeldir = '/misc/prc15/colarco/dR_MERRA-AA-r2/aerosol_index/'
  nc4readvar, modeldir+'omia/ai.monthly.200707.nc4', 'ana', aia, lon=lon, lat=lat
  nc4readvar, modeldir+'omib/ai.monthly.200707.nc4', 'ana', aib, lon=lon, lat=lat
  nc4readvar, modeldir+'omic/ai.monthly.200707.nc4', 'ana', aic, lon=lon, lat=lat
  nc4readvar, modeldir+'omid/ai.monthly.200707.nc4', 'ana', aid, lon=lon, lat=lat
  nc4readvar, modeldir+'omie/ai.monthly.200707.nc4', 'ana', aie, lon=lon, lat=lat
  nc4readvar, modeldir+'omif/ai.monthly.200707.nc4', 'ana', aif, lon=lon, lat=lat
  nc4readvar, modeldir+'omig/ai.monthly.200707.nc4', 'ana', aig, lon=lon, lat=lat

  a = where(aia ge 1e14) & aia[a] = !values.f_nan
  a = where(aib ge 1e14) & aib[a] = !values.f_nan
  a = where(aic ge 1e14) & aic[a] = !values.f_nan
  a = where(aid ge 1e14) & aid[a] = !values.f_nan
  a = where(aie ge 1e14) & aie[a] = !values.f_nan
  a = where(aif ge 1e14) & aif[a] = !values.f_nan
  a = where(aig ge 1e14) & aig[a] = !values.f_nan

; get the area
  lon2=1
  lat2=1
  area, lon, lat, nx, ny, dx, dy, area, grid='d', lon2=lon2, lat2=lat2

; get the histograms
  binsize=.2
  nbins=20
  minv = 0.
  x = minv+.5*binsize+findgen(nbins)*binsize

; Make a histogram plot
  set_plot, 'ps'
  device, file='ai_histogram.ps', /color, /helvetica, font_size=10, $
   xsize=12, ysize=20, xoff=.5, yoff=.5
  !p.multi=[0,1,2]
  !p.font=0
  linthick=6

  loadct, 39
  plot, indgen(10), /nodata, $
   xrange=[0,4], yrange=[0,1], $
   xtitle='AI', ytitle='frequency', $
   title='AI histogram (tropical Atlantic)'

  plots, [.1,.4], .960, thick=linthick
  plots, [.1,.4], .920, thick=linthick, color=48
  plots, [.1,.4], .880, thick=linthick, color=80
  plots, [.1,.4], .840, thick=linthick, color=120
  plots, [.1,.4], .800, thick=linthick, color=176
  plots, [.1,.4], .760, thick=linthick, color=208
  plots, [.1,.4], .720, thick=linthick, color=254
  xyouts, .5, .940, 'k!D354!N = 0'
  xyouts, .5, .900, 'k!D354!N = 0.0013'
  xyouts, .5, .860, 'k!D354!N = 0.0026'
  xyouts, .5, .820, 'k!D354!N = 0.0056'
  xyouts, .5, .780, 'k!D354!N = 0.0083'
  xyouts, .5, .740, 'k!D354!N = 0.0130'
  xyouts, .5, .700, 'k!D354!N = 0.0230'

; Select -- region downwind of Africa
  a = where(lon2 gt -65 and lon2 le -20 and lat2 gt 12 and lat2 le 30)

  hist = histogram(aia[a],binsize=binsize,min=minv,nbins=nbins)
  oplot, x, hist/total(hist), thick=linthick
  print, total(hist)

  hist = histogram(aib[a],binsize=binsize,min=minv,nbins=nbins)
  oplot, x, hist/total(hist), color=48, thick=linthick
  print, total(hist)

  hist = histogram(aic[a],binsize=binsize,min=minv,nbins=nbins)
  oplot, x, hist/total(hist), color=80, thick=linthick
  print, total(hist)

  hist = histogram(aid[a],binsize=binsize,min=minv,nbins=nbins)
  oplot, x, hist/total(hist), color=120, thick=linthick
  print, total(hist)

  hist = histogram(aie[a],binsize=binsize,min=minv,nbins=nbins)
  oplot, x, hist/total(hist), color=176, thick=linthick
  print, total(hist)

  hist = histogram(aif[a],binsize=binsize,min=minv,nbins=nbins)
  oplot, x, hist/total(hist), color=208, thick=linthick
  print, total(hist)

  hist = histogram(aig[a],binsize=binsize,min=minv,nbins=nbins)
  oplot, x, hist/total(hist), color=254, thick=linthick
  print, total(hist)

; Select -- source region
  plot, indgen(10), /nodata, $
   xrange=[0,4], yrange=[0,1], $
   xtitle='AI', ytitle='frequency', $
   title='AI histogram (source region)'
  a = where(lon2 gt -20 and lon2 le 30 and lat2 gt 12 and lat2 le 30)

  hist = histogram(aia[a],binsize=binsize,min=minv,nbins=nbins)
  oplot, x, hist/total(hist), thick=linthick
  print, total(hist)

  hist = histogram(aib[a],binsize=binsize,min=minv,nbins=nbins)
  oplot, x, hist/total(hist), color=48, thick=linthick
  print, total(hist)

  hist = histogram(aic[a],binsize=binsize,min=minv,nbins=nbins)
  oplot, x, hist/total(hist), color=80, thick=linthick
  print, total(hist)

  hist = histogram(aid[a],binsize=binsize,min=minv,nbins=nbins)
  oplot, x, hist/total(hist), color=120, thick=linthick
  print, total(hist)

  hist = histogram(aie[a],binsize=binsize,min=minv,nbins=nbins)
  oplot, x, hist/total(hist), color=176, thick=linthick
  print, total(hist)

  hist = histogram(aif[a],binsize=binsize,min=minv,nbins=nbins)
  oplot, x, hist/total(hist), color=208, thick=linthick
  print, total(hist)

  hist = histogram(aig[a],binsize=binsize,min=minv,nbins=nbins)
  oplot, x, hist/total(hist), color=254, thick=linthick
  print, total(hist)

  device, /close
end
