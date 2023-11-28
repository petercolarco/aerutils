  expid = 'c180R_v202_aura_gsfun'

; Get the aeronet points
  getaeronetloc, plon, plat

; Get a model field
  filen1 = expid+'.monthly.201609.nc4'
  nc4readvar, filen1, 'maot', aim, lon=lon, lat=lat

; Get the OMAERUV field
  filen2 = 'omaeruv.monthly.201609.nc4'
  nc4readvar, filen2, 'aot', ai, lon=lon, lat=lat

  a = where(ai gt 100)
  ai[a] = !values.f_nan
  aim[a] = !values.f_nan

  colors=[16,64,230,128,112,254]
;  levels=[0,0.5,1,1.5,2,2.5]
;  labels=['0','0.5','1','1.5','2','2.5']
;  dlevels=[-2.5,-2,-1.5,-1,-.5,-.1,.1,.5]
;  dcolors=[255,224,192,176,160,128,80,16]
  levels=[0,0.2,0.4,0.6,0.8,1]
  labels=['0','0.2','0.4','0.6','0.8','1']
  dlevels=[-1,-.5,-.2,-.1,-0.05,0.05,.1,0.2,.5]
  dcolors=[255,224,192,176,128,100,80,60,16]

  set_plot, 'ps'
  device, file='aod.'+expid+'.ps', /color, /helvetica, font_size=16, $
   xsize=20, ysize=36
  !p.font=0

  comp, aim, ai, lon, lat, ct=43, levels=levels, colors=colors, $
        labels=labels, dlevels=dlevels, dcolors=dcolors, plon=plon, plat=plat

  device, /close

end
