; From model calculations, grab AI and plot
  modeldir = '/misc/prc15/colarco/dR_MERRA-AA-r2/aerosol_index/'
  nc4readvar, modeldir+'omia/ai.monthly.200707.nc4', 'ana', aia, lon=lon, lat=lat
  nc4readvar, modeldir+'omib/ai.monthly.200707.nc4', 'ana', aib, lon=lon, lat=lat
  nc4readvar, modeldir+'omic/ai.monthly.200707.nc4', 'ana', aic, lon=lon, lat=lat
  nc4readvar, modeldir+'omid/ai.monthly.200707.nc4', 'ana', aid, lon=lon, lat=lat
  nc4readvar, modeldir+'omie/ai.monthly.200707.nc4', 'ana', aie, lon=lon, lat=lat
  nc4readvar, modeldir+'omif/ai.monthly.200707.nc4', 'ana', aif, lon=lon, lat=lat
  nc4readvar, modeldir+'omig/ai.monthly.200707.nc4', 'ana', aig, lon=lon, lat=lat
; AOT
  nc4readvar, modeldir+'omia/aot.monthly.200707.nc4', 'ana', aota, lon=lon, lat=lat
  nc4readvar, modeldir+'omib/aot.monthly.200707.nc4', 'ana', aotb, lon=lon, lat=lat
  nc4readvar, modeldir+'omic/aot.monthly.200707.nc4', 'ana', aotc, lon=lon, lat=lat
  nc4readvar, modeldir+'omid/aot.monthly.200707.nc4', 'ana', aotd, lon=lon, lat=lat
  nc4readvar, modeldir+'omie/aot.monthly.200707.nc4', 'ana', aote, lon=lon, lat=lat
  nc4readvar, modeldir+'omif/aot.monthly.200707.nc4', 'ana', aotf, lon=lon, lat=lat
  nc4readvar, modeldir+'omig/aot.monthly.200707.nc4', 'ana', aotg, lon=lon, lat=lat

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

; Select
  a = where(lon2 gt -65 and lon2 le -20 and lat2 gt 12 and lat2 le 30)

; plot
  plot, indgen(10), xrange=[0,1.5], yrange=[0,4], /nodata
  loadct, 39
 ; plots, aota[a], aia[a], psym=3
  ;plots, aotb[a], aib[a], psym=3, color=48
  ;plots, aotc[a], aic[a], psym=3, color=74
  ;plots, aotd[a], aid[a], psym=3, color=100
  ;plots, aote[a], aie[a], psym=3, color=176
  ;plots, aotf[a], aif[a], psym=3, color=208
  plots, aotg[a], aig[a], psym=3, color=254

  a = where(lon2 gt -20 and lon2 le 30 and lat2 gt 12 and lat2 le 30)
  plots, aotg[a], aig[a], psym=3, color=80


end
