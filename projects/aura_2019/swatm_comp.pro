  dir = '/misc/prc18/colarco/'
  expid1 = 'c360R_era5_v10p22p2_aura_loss_bb3_low3'
  expid2 = 'c360R_era5_v10p22p2_aura_baseline'

; Get a model field
  filen1 = dir+expid1+'/'+expid1+'.geosgcm_surf.monthly.201609.nc4'
  nc4readvar, filen1, 'swtnet', swtnet, lon=lon, lat=lat
  nc4readvar, filen1, 'swtnetna', swtnetna, lon=lon, lat=lat
  nc4readvar, filen1, 'swgnet', swgnet, lon=lon, lat=lat
  nc4readvar, filen1, 'swgnetna', swgnetna, lon=lon, lat=lat
  low = (swtnet-swtnetna)-(swgnet-swgnetna)

; Get a model field
  filen2 = dir+expid2+'/'+expid2+'.geosgcm_surf.monthly.201609.nc4'
  nc4readvar, filen2, 'swtnet', swtnet, lon=lon, lat=lat
  nc4readvar, filen2, 'swtnetna', swtnetna, lon=lon, lat=lat
  nc4readvar, filen2, 'swgnet', swgnet, lon=lon, lat=lat
  nc4readvar, filen2, 'swgnetna', swgnetna, lon=lon, lat=lat
  base = (swtnet-swtnetna)-(swgnet-swgnetna)

  colors=[208,200,16,64,230,128,112,254]
  levels=[-100,5,10,15,20,25,30,35]
  labels=[' ','5','10','15','20','25','30','35']
  dlevels=[-2.5,-2,-1.5,-1,-.5,-.1,.1,.5]
  dcolors=[255,224,192,176,160,128,80,16]
  dlevels=[-10,-1.5,-.5,-.1,.1,.5,1.,1.5,2.]
  dcolors=[255,224,180,160,128,100,60,30,0]
;  dcolors=[16,60,100,128,160,176,192,224,255]

  set_plot, 'ps'
  device, file='swatm_comp.ps', /color, /helvetica, font_size=12, $
   xsize=20, ysize=36
  !p.font=0

  comp, base, low, lon, lat, ct=43, levels=levels, colors=colors, $
        labels=labels, dlevels=dlevels, dcolors=dcolors, experimentstr1='GEOS Baseline', experimentstr2='GEOS+OA_loss+updated_optics', diffstr='Baseline - Updated', titlestr = '(c) Atmosphere All-sky SW Aerosol Forcing [W m!E-2!N]'

  device, /close

end
