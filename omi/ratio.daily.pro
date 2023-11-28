; From model calculations, grab the model AOT and plot
  nc4readvar, 'omia.aot.ddf', 'ana', aota, lon=lon, lat=lat
  nc4readvar, 'omib.aot.ddf', 'ana', aotb, lon=lon, lat=lat
  nc4readvar, 'omic.aot.ddf', 'ana', aotc, lon=lon, lat=lat
  nc4readvar, 'omid.aot.ddf', 'ana', aotd, lon=lon, lat=lat
  nc4readvar, 'omie.aot.ddf', 'ana', aote, lon=lon, lat=lat
  nc4readvar, 'omif.aot.ddf', 'ana', aotf, lon=lon, lat=lat
  nc4readvar, 'omig.aot.ddf', 'ana', aotg, lon=lon, lat=lat

  nc4readvar, 'omia.ai.ddf', 'ana', aia, lon=lon, lat=lat
  nc4readvar, 'omib.ai.ddf', 'ana', aib, lon=lon, lat=lat
  nc4readvar, 'omic.ai.ddf', 'ana', aic, lon=lon, lat=lat
  nc4readvar, 'omid.ai.ddf', 'ana', aid, lon=lon, lat=lat
  nc4readvar, 'omie.ai.ddf', 'ana', aie, lon=lon, lat=lat
  nc4readvar, 'omif.ai.ddf', 'ana', aif, lon=lon, lat=lat
  nc4readvar, 'omig.ai.ddf', 'ana', aig, lon=lon, lat=lat

  a = where(aia ge 1e14) & aia[a] = !values.f_nan & aota[a] = !values.f_nan
  a = where(aib ge 1e14) & aib[a] = !values.f_nan & aotb[a] = !values.f_nan
  a = where(aic ge 1e14) & aic[a] = !values.f_nan & aotc[a] = !values.f_nan
  a = where(aid ge 1e14) & aid[a] = !values.f_nan & aotd[a] = !values.f_nan
  a = where(aie ge 1e14) & aie[a] = !values.f_nan & aote[a] = !values.f_nan
  a = where(aif ge 1e14) & aif[a] = !values.f_nan & aotf[a] = !values.f_nan
  a = where(aig ge 1e14) & aig[a] = !values.f_nan & aotg[a] = !values.f_nan

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
  aia = reform(aia,nx*ny*1L,31)
  aib = reform(aib,nx*ny*1L,31)
  aic = reform(aic,nx*ny*1L,31)
  aid = reform(aid,nx*ny*1L,31)
  aie = reform(aie,nx*ny*1L,31)
  aif = reform(aif,nx*ny*1L,31)
  aig = reform(aig,nx*ny*1L,31)


; get the histograms
  binsize=.05
  nbins=20
  minv = 0.
  x = minv+.5*binsize+findgen(nbins)*binsize

; Make a histogram plot
  set_plot, 'ps'
  device, file='ratio.daily.ps', /color, /helvetica, font_size=10, $
   xsize=12, ysize=20, xoff=.5, yoff=.5
  !p.multi=[0,1,2]
  !p.font=0
  linthick=6

  loadct, 39
  plot, indgen(10), /nodata, $
   xrange=[0,2], yrange=[0,2], $
   xtitle='AOT [354 nm]', ytitle='AOT/AI ratio', $
   title='AOT [354 nm] / AI (tropical Atlantic)'

; Select -- region downwind of Africa
  a = where(lon2 gt -65 and lon2 le -16 and lat2 gt 12 and lat2 le 30)

  plots, aota[a,*], aota[a,*]/aia[a,*], psym=3, color=0, noclip=0
  plots, aotb[a,*], aotb[a,*]/aib[a,*], psym=3, color=48, noclip=0
  plots, aotc[a,*], aotc[a,*]/aic[a,*], psym=3, color=80, noclip=0
  plots, aotd[a,*], aotd[a,*]/aid[a,*], psym=3, color=120, noclip=0
  plots, aote[a,*], aote[a,*]/aie[a,*], psym=3, color=176, noclip=0
  plots, aotf[a,*], aotf[a,*]/aif[a,*], psym=3, color=208, noclip=0
  plots, aotg[a,*], aotg[a,*]/aig[a,*], psym=3, color=254, noclip=0

  tmp0 = aia[a,*] & tmp1 = aota[a,*]
  tmp0 = tmp0[where(finite(tmp0) eq 1)] & tmp1 = tmp1[where(finite(tmp1) eq 1)]
  res = linfit(tmp0,tmp1)
  plots, [0,2], res[1], thick=6, color=0
  print, res[1]

  tmp0 = aib[a,*] & tmp1 = aotb[a,*]
  tmp0 = tmp0[where(finite(tmp0) eq 1)] & tmp1 = tmp1[where(finite(tmp1) eq 1)]
  res = linfit(tmp0,tmp1)
  plots, [0,2], res[1], thick=6, color=48
  print, res[1]

  tmp0 = aic[a,*] & tmp1 = aotc[a,*]
  tmp0 = tmp0[where(finite(tmp0) eq 1)] & tmp1 = tmp1[where(finite(tmp1) eq 1)]
  res = linfit(tmp0,tmp1)
  plots, [0,2], res[1], thick=6, color=80
  print, res[1]

  tmp0 = aid[a,*] & tmp1 = aotd[a,*]
  tmp0 = tmp0[where(finite(tmp0) eq 1)] & tmp1 = tmp1[where(finite(tmp1) eq 1)]
  res = linfit(tmp0,tmp1)
  plots, [0,2], res[1], thick=6, color=120
  print, res[1]

  tmp0 = aie[a,*] & tmp1 = aote[a,*]
  tmp0 = tmp0[where(finite(tmp0) eq 1)] & tmp1 = tmp1[where(finite(tmp1) eq 1)]
  res = linfit(tmp0,tmp1)
  plots, [0,2], res[1], thick=6, color=176
  print, res[1]

  tmp0 = aif[a,*] & tmp1 = aotf[a,*]
  tmp0 = tmp0[where(finite(tmp0) eq 1)] & tmp1 = tmp1[where(finite(tmp1) eq 1)]
  res = linfit(tmp0,tmp1)
  plots, [0,2], res[1], thick=6, color=208
  print, res[1]

  tmp0 = aig[a,*] & tmp1 = aotg[a,*]
  tmp0 = tmp0[where(finite(tmp0) eq 1)] & tmp1 = tmp1[where(finite(tmp1) eq 1)]
  res = linfit(tmp0,tmp1)
  plots, [0,2], res[1], thick=6, color=254
  print, res[1]



  plot, indgen(10), /nodata, $
   xrange=[0,2], yrange=[0,2], $
   xtitle='AOT [354 nm]', ytitle='AOT/AI ratio', $
   title='AOT [354 nm] / AI (source region)'

; Select -- source region
  a = where(lon2 gt -16 and lon2 le 30 and lat2 gt 12 and lat2 le 30)

  plots, aota[a,*], aota[a,*]/aia[a,*], psym=3, color=0, noclip=0
  plots, aotb[a,*], aotb[a,*]/aib[a,*], psym=3, color=48, noclip=0
  plots, aotc[a,*], aotc[a,*]/aic[a,*], psym=3, color=80, noclip=0
  plots, aotd[a,*], aotd[a,*]/aid[a,*], psym=3, color=120, noclip=0
  plots, aote[a,*], aote[a,*]/aie[a,*], psym=3, color=176, noclip=0
  plots, aotf[a,*], aotf[a,*]/aif[a,*], psym=3, color=208, noclip=0
  plots, aotg[a,*], aotg[a,*]/aig[a,*], psym=3, color=254, noclip=0

  tmp0 = aia[a,*] & tmp1 = aota[a,*]
  tmp0 = tmp0[where(finite(tmp0) eq 1)] & tmp1 = tmp1[where(finite(tmp1) eq 1)]
  res = linfit(tmp0,tmp1)
  plots, [0,2], res[1], thick=6, color=0
  print, res[1]

  tmp0 = aib[a,*] & tmp1 = aotb[a,*]
  tmp0 = tmp0[where(finite(tmp0) eq 1)] & tmp1 = tmp1[where(finite(tmp1) eq 1)]
  res = linfit(tmp0,tmp1)
  plots, [0,2], res[1], thick=6, color=48
  print, res[1]

  tmp0 = aic[a,*] & tmp1 = aotc[a,*]
  tmp0 = tmp0[where(finite(tmp0) eq 1)] & tmp1 = tmp1[where(finite(tmp1) eq 1)]
  res = linfit(tmp0,tmp1)
  plots, [0,2], res[1], thick=6, color=80
  print, res[1]

  tmp0 = aid[a,*] & tmp1 = aotd[a,*]
  tmp0 = tmp0[where(finite(tmp0) eq 1)] & tmp1 = tmp1[where(finite(tmp1) eq 1)]
  res = linfit(tmp0,tmp1)
  plots, [0,2], res[1], thick=6, color=120
  print, res[1]

  tmp0 = aie[a,*] & tmp1 = aote[a,*]
  tmp0 = tmp0[where(finite(tmp0) eq 1)] & tmp1 = tmp1[where(finite(tmp1) eq 1)]
  res = linfit(tmp0,tmp1)
  plots, [0,2], res[1], thick=6, color=176
  print, res[1]

  tmp0 = aif[a,*] & tmp1 = aotf[a,*]
  tmp0 = tmp0[where(finite(tmp0) eq 1)] & tmp1 = tmp1[where(finite(tmp1) eq 1)]
  res = linfit(tmp0,tmp1)
  plots, [0,2], res[1], thick=6, color=208
  print, res[1]

  tmp0 = aig[a,*] & tmp1 = aotg[a,*]
  tmp0 = tmp0[where(finite(tmp0) eq 1)] & tmp1 = tmp1[where(finite(tmp1) eq 1)]
  res = linfit(tmp0,tmp1)
  plots, [0,2], res[1], thick=6, color=254
  print, res[1]


  device, /close
end
