  dir = '/misc/prc18/colarco/'
  expid1 = 'c360R_era5_v10p22p2_aura_loss_bb3_low3'
  expid2 = 'c360R_era5_v10p22p2_aura_baseline'

; Get a model field
  filen1 = dir+expid1+'/'+expid1+'.inst2d_hwl_x.monthly.201609.nc4'
  nc4readvar, filen1, 'totexttau', low, lon=lon, lat=lat
  filen1c = dir+expid1+'/'+expid1+'.geosgcm_surf.monthly.201609.nc4'
  nc4readvar, filen1c, 'CLDLO', clow, lon=lon, lat=lat

; Get a model field
  filen2 = dir+expid2+'/'+expid2+'.inst2d_hwl_x.monthly.201609.nc4'
  nc4readvar, filen2, 'totexttau', base, lon=lon, lat=lat
  filen2c = dir+expid2+'/'+expid2+'.geosgcm_surf.monthly.201609.nc4'
  nc4readvar, filen2c, 'CLDLO', cbase, lon=lon, lat=lat

  colors=[208,200,16,64,230,128,112,254]
  levels=[0,.05,.1,.15,.2,.3,.4,.5]
  labels=['0','0.05','0.1','0.15','0.2','0.3','0.4','0.5']
  dlevels=[-2.5,-1.5,-1,-.5,-.1,.1,.5,1]/10
  dcolors=[255,224,200,176,128,80,40,16]

  set_plot, 'ps'
  device, file='model_aod_comp.ps', /color, /helvetica, font_size=12, $
   xsize=20, ysize=36
  !p.font=0

  comp, base, low, lon, lat, ct=43, levels=levels, colors=colors, $
        labels=labels, dlevels=dlevels, dcolors=dcolors, experimentstr1='GEOS Baseline', experimentstr2='GEOS+OA_loss+updated_optics', diffstr='Baseline - Updated', titlestr = '(a) September 2016 AOD', $
        conta=cbase, contb=clow

  device, /close

end
