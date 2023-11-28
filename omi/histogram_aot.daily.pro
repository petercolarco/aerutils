; From model calculations, grab the model AOT and plot
  nc4readvar, 'omia.aot.ddf', 'ana', aota, lon=lon, lat=lat
  nc4readvar, 'omib.aot.ddf', 'ana', aotb, lon=lon, lat=lat
  nc4readvar, 'omic.aot.ddf', 'ana', aotc, lon=lon, lat=lat
  nc4readvar, 'omid.aot.ddf', 'ana', aotd, lon=lon, lat=lat
  nc4readvar, 'omie.aot.ddf', 'ana', aote, lon=lon, lat=lat
  nc4readvar, 'omif.aot.ddf', 'ana', aotf, lon=lon, lat=lat
  nc4readvar, 'omig.aot.ddf', 'ana', aotg, lon=lon, lat=lat

  a = where(aota ge 1e14) & aota[a] = !values.f_nan
  a = where(aotb ge 1e14) & aotb[a] = !values.f_nan
  a = where(aotc ge 1e14) & aotc[a] = !values.f_nan
  a = where(aotd ge 1e14) & aotd[a] = !values.f_nan
  a = where(aote ge 1e14) & aote[a] = !values.f_nan
  a = where(aotf ge 1e14) & aotf[a] = !values.f_nan
  a = where(aotg ge 1e14) & aotg[a] = !values.f_nan

; get the area
  lon2=1
  lat2=1
  area, lon, lat, nx, ny, dx, dy, area, grid='d', lon2=lon2, lat2=lat2

; rearrange
  aota = reform(aota,nx*ny*1L,31)
  aotb = reform(aotb,nx*ny*1L,31)
  aotc = reform(aotc,nx*ny*1L,31)
  aotd = reform(aotd,nx*ny*1L,31)
  aote = reform(aote,nx*ny*1L,31)
  aotf = reform(aotf,nx*ny*1L,31)
  aotg = reform(aotg,nx*ny*1L,31)


; get the histograms
  binsize=.05
  nbins=20
  minv = 0.
  x = minv+.5*binsize+findgen(nbins)*binsize

; Make a histogram plot
  set_plot, 'ps'
  device, file='aot_histogram.daily.ps', /color, /helvetica, font_size=10, $
   xsize=12, ysize=20, xoff=.5, yoff=.5
  !p.multi=[0,1,2]
  !p.font=0
  linthick=6

  loadct, 39
  plot, indgen(10), /nodata, $
   xrange=[0,1], yrange=[0,.5], $
   xtitle='AOT [354 nm]', ytitle='frequency', $
   title='AOT [354 nm] histogram (tropical Atlantic)'

  plots, [.05,.15], .480, thick=linthick
  plots, [.05,.15], .460, thick=linthick, color=48
  plots, [.05,.15], .440, thick=linthick, color=80
  plots, [.05,.15], .420, thick=linthick, color=120
  plots, [.05,.15], .400, thick=linthick, color=176
  plots, [.05,.15], .380, thick=linthick, color=208
  plots, [.05,.15], .360, thick=linthick, color=254
  xyouts, .17, .470, 'k!D354!N = 0'
  xyouts, .17, .450, 'k!D354!N = 0.0013'
  xyouts, .17, .430, 'k!D354!N = 0.0026'
  xyouts, .17, .410, 'k!D354!N = 0.0056'
  xyouts, .17, .390, 'k!D354!N = 0.0083'
  xyouts, .17, .370, 'k!D354!N = 0.0130'
  xyouts, .17, .350, 'k!D354!N = 0.0230'

; Select -- region downwind of Africa
  a = where(lon2 gt -65 and lon2 le -16 and lat2 gt 12 and lat2 le 30)

  hist = histogram(aota[a,*],binsize=binsize,min=minv,nbins=nbins)
  oplot, x, hist/total(hist), thick=linthick
  print, total(hist)

  hist = histogram(aotb[a,*],binsize=binsize,min=minv,nbins=nbins)
  oplot, x, hist/total(hist), color=48, thick=linthick
  print, total(hist)

  hist = histogram(aotc[a,*],binsize=binsize,min=minv,nbins=nbins)
  oplot, x, hist/total(hist), color=80, thick=linthick
  print, total(hist)

  hist = histogram(aotd[a,*],binsize=binsize,min=minv,nbins=nbins)
  oplot, x, hist/total(hist), color=120, thick=linthick
  print, total(hist)

  hist = histogram(aote[a,*],binsize=binsize,min=minv,nbins=nbins)
  oplot, x, hist/total(hist), color=176, thick=linthick
  print, total(hist)

  hist = histogram(aotf[a,*],binsize=binsize,min=minv,nbins=nbins)
  oplot, x, hist/total(hist), color=208, thick=linthick
  print, total(hist)

  hist = histogram(aotg[a,*],binsize=binsize,min=minv,nbins=nbins)
  oplot, x, hist/total(hist), color=254, thick=linthick
  print, total(hist)

; Select -- source region
  plot, indgen(10), /nodata, $
   xrange=[0,1], yrange=[0,.500], $
   xtitle='AOT [354 nm]', ytitle='frequency', $
   title='AOT [354 nm] histogram (source region)'
  a = where(lon2 gt -16 and lon2 le 30 and lat2 gt 12 and lat2 le 30)

  hist = histogram(aota[a,*],binsize=binsize,min=minv,nbins=nbins)
  oplot, x, hist/total(hist), thick=linthick
  print, total(hist)

  hist = histogram(aotb[a,*],binsize=binsize,min=minv,nbins=nbins)
  oplot, x, hist/total(hist), color=48, thick=linthick
  print, total(hist)

  hist = histogram(aotc[a,*],binsize=binsize,min=minv,nbins=nbins)
  oplot, x, hist/total(hist), color=80, thick=linthick
  print, total(hist)

  hist = histogram(aotd[a,*],binsize=binsize,min=minv,nbins=nbins)
  oplot, x, hist/total(hist), color=120, thick=linthick
  print, total(hist)

  hist = histogram(aote[a,*],binsize=binsize,min=minv,nbins=nbins)
  oplot, x, hist/total(hist), color=176, thick=linthick
  print, total(hist)

  hist = histogram(aotf[a,*],binsize=binsize,min=minv,nbins=nbins)
  oplot, x, hist/total(hist), color=208, thick=linthick
  print, total(hist)

  hist = histogram(aotg[a,*],binsize=binsize,min=minv,nbins=nbins)
  oplot, x, hist/total(hist), color=254, thick=linthick
  print, total(hist)

  device, /close
end
