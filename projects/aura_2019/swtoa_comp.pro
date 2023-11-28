  dir = '/misc/prc18/colarco/'
  expid1 = 'c360R_era5_v10p22p2_aura_loss_bb3_low3'
  expid2 = 'c360R_era5_v10p22p2_aura_baseline'

; Get a model field
  filen1 = dir+expid1+'/'+expid1+'.geosgcm_surf.monthly.201609.nc4'
  nc4readvar, filen1, 'swtnet', swtnet, lon=lon, lat=lat
  nc4readvar, filen1, 'swtnetna', swtnetna, lon=lon, lat=lat
;  nc4readvar, filen1, 'swgnet', swgnet, lon=lon, lat=lat
;  nc4readvar, filen1, 'swgnetna', swgnetna, lon=lon, lat=lat
  low = (swtnet-swtnetna);-(swgnet-swgnetna)

; Get a model field
  filen2 = dir+expid2+'/'+expid2+'.geosgcm_surf.monthly.201609.nc4'
  nc4readvar, filen2, 'swtnet', swtnet, lon=lon, lat=lat
  nc4readvar, filen2, 'swtnetna', swtnetna, lon=lon, lat=lat
;  nc4readvar, filen2, 'swgnet', swgnet, lon=lon, lat=lat
;  nc4readvar, filen2, 'swgnetna', swgnetna, lon=lon, lat=lat
  base = (swtnet-swtnetna);-(swgnet-swgnetna)

  colors=[208,200,16,64,230,128,112,254]
  levels=[-100,-10,-5,-3,-1,1,3,5]
  labels=[' ','-10','-5','-3','-1','1','3','5']
  dlevels=[-2.5,-1.5,-1,-.5,-.1,.1,.5,1,1.5]
  dcolors=[255,224,200,176,128,100,80,40,16]

  set_plot, 'ps'
  device, file='swtoa_comp.ps', /color, /helvetica, font_size=12, $
   xsize=20, ysize=36
  !p.font=0

  comp, base, low, lon, lat, ct=43, levels=levels, colors=colors, $
        labels=labels, dlevels=dlevels, dcolors=dcolors, experimentstr1='GEOS Baseline', experimentstr2='GEOS+OA_loss+updated_optics', diffstr='Baseline - Updated', titlestr = '(b) TOA All-sky SW Aerosol Forcing [W m!E-2!N]'

  device, /close

end
