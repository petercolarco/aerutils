  expid = 'c360R_v10p22p2_aura_loss_bb4_gaas'

; Get the aeronet points
;  getaeronetloc, plon, plat

; Get a model field
  filen1 = expid+'.inst2d_hwl_x.misr.monthly.201609.nc4'
  nc4readvar, filen1, 'totexttau', aim, lon=lon, lat=lat

; Get the MISR field
  filen2 = 'misr_L3_F13_0023.tavg3d_aero_w1.x1440_y721.monthly.201609.nc4'
  nc4readvar, filen2, 'aod', ai, lon=lon, lat=lat

  a = where(ai lt -1000.)
  ai[a] = !values.f_nan
  aim[a] = !values.f_nan

  colors=[16,64,230,128,112,254]
  levels=[0,0.2,0.4,0.6,0.8,1]
  labels=['0','0.2','0.4','0.6','0.8','1']
  dlevels=[-1,-.5,-.2,-.1,-0.05,0.05,.1,0.2,.5]
  dcolors=[255,224,192,176,128,100,80,60,16]

  set_plot, 'ps'
  device, file='aod.misr.'+expid+'.ps', /color, /helvetica, font_size=16, $
   xsize=20, ysize=36
  !p.font=0

  comp, aim, ai, lon, lat, ct=43, levels=levels, colors=colors, $
        labels=labels, dlevels=dlevels, dcolors=dcolors;, plon=plon, plat=plat

  device, /close

end
