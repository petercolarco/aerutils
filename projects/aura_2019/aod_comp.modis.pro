  expid = 'c180R_v202_aura'

; Get the aeronet points
  getaeronetloc, plon, plat

; Get a model field
  filen1 = expid+'.inst2d_hwl_x.MYD04.land.monthly.201609.nc4'
  nc4readvar, filen1, 'totexttau002', aim_, lon=lon, lat=lat
  filen1 = expid+'.inst2d_hwl_x.MYD04.ocean.monthly.201609.nc4'
  nc4readvar, filen1, 'totexttau002', aim, lon=lon, lat=lat
  a = where(aim_ lt 900.)
  aim[a] = aim_[a]

; Get the MISR field
  filen2 = 'nnr_003.MYD04_L3a.land.monthly.201609.nc4'
  nc4readvar, filen2, 'tau_', ai_, lon=lon, lat=lat
  filen2 = 'nnr_003.MYD04_L3a.ocean.monthly.201609.nc4'
  nc4readvar, filen2, 'tau_', ai, lon=lon, lat=lat
  a = where(ai_ lt 900.)
  ai[a] = ai_[a]

  a = where(ai gt 100)
  ai[a] = !values.f_nan
  aim[a] = !values.f_nan

  colors=[16,64,230,128,112,254]
  levels=[0,0.2,0.4,0.6,0.8,1]
  labels=['0','0.2','0.4','0.6','0.8','1']
  dlevels=[-1,-.5,-.2,-.1,-0.05,0.05,.1,0.2,.5]
  dcolors=[255,224,192,176,128,100,80,60,16]

  set_plot, 'ps'
  device, file='aod.modis.'+expid+'.ps', /color, /helvetica, font_size=16, $
   xsize=20, ysize=36
  !p.font=0

  comp, aim, ai, lon, lat, ct=43, levels=levels, colors=colors, $
        labels=labels, dlevels=dlevels, dcolors=dcolors, plon=plon, plat=plat

  device, /close

end
