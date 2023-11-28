  expid = 'c180R_v202_aura_gsfun'

; Get a model field
  filen1 = expid+'.monthly.201609.nc4'
  nc4readvar, filen1, 'maot388', maot388, lon=lon, lat=lat
  nc4readvar, filen1, 'maot354', maot, lon=lon, lat=lat
  nc4readvar, filen1, 'mssa388', mssa388, lon=lon, lat=lat
  nc4readvar, filen1, 'mssa354', mssa, lon=lon, lat=lat
  aim = -alog((1.-mssa)*maot / ((1.-mssa388)*maot388)) / alog(354./388.)

; Get the OMAERUV field
  filen2 = 'omaeruv.monthly.201609.nc4'
  nc4readvar, filen2, 'aot388', aot388, lon=lon, lat=lat
  nc4readvar, filen1, 'aot354', aot, lon=lon, lat=lat
  nc4readvar, filen1, 'ssa388', ssa388, lon=lon, lat=lat
  nc4readvar, filen1, 'ssa354', ssa, lon=lon, lat=lat
  ai = -alog((1.-ssa)*aot / ((1.-ssa388)*aot388)) / alog(354./388.)

  a = where(aot gt 100)
  ai[a] = !values.f_nan
  aim[a] = !values.f_nan

  colors=[16,64,230,128,112,254]
  levels=[1,1.5,2,2.5,3,3.5]
  labels=['1','1.5','2','2.5','3','3.5']
  dlevels=[-2.5,-2,-1.5,-1,-.5,-.1,.1,.5]
  dcolors=[255,224,192,176,160,128,80,16]

  set_plot, 'ps'
  device, file='aae354.'+expid+'.ps', /color, /helvetica, font_size=12, $
   xsize=20, ysize=36
  !p.font=0

  comp, aim, ai, lon, lat, ct=43, levels=levels, colors=colors, $
        labels=labels, dlevels=dlevels, dcolors=dcolors

  device, /close

end
