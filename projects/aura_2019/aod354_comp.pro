  expid = 'c180R_v202_aura_schill'

; Get a model field
  filen1 = expid+'.monthly.201609.nc4'
  nc4readvar, filen1, 'maot354', aim, lon=lon, lat=lat

; Get the OMAERUV field
  filen2 = 'omaeruv.monthly.201609.nc4'
  nc4readvar, filen2, 'aot354', ai, lon=lon, lat=lat

  a = where(ai gt 100)
  ai[a] = !values.f_nan
  aim[a] = !values.f_nan

  colors=[16,64,230,128,112,254]
  levels=[0,0.5,1,1.5,2,2.5]
  labels=['0','0.5','1','1.5','2','2.5']
  dlevels=[-2.5,-2,-1.5,-1,-.5,-.1,.1,.5]
  dcolors=[255,224,192,176,160,128,80,16]

  set_plot, 'ps'
  device, file='aod354.'+expid+'.ps', /color, /helvetica, font_size=12, $
   xsize=20, ysize=36
  !p.font=0

  comp, aim, ai, lon, lat, ct=43, levels=levels, colors=colors, $
        labels=labels, dlevels=dlevels, dcolors=dcolors

  device, /close

end
