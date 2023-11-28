; ANNUAL All-sky dust aerosol forcing (from offline 2041-2050)
; Subtract SS aerosol forcing from total to yield simply dust.  This
; is done by removing (linearly) the SS forcing from the offline
; calculation. 

; First, read in from the offline calculation the SS aerosol forcing
   filen = '/misc/prc14/colarco/bF_F25b9-base-v11/inst2d_surf_x_v1_ss'+$
           '/bF_F25b9-base-v11.inst2d_surf_x_v1_ss.monthly.clim.JJA.nc4'
   nc4readvar, filen, 'swtnet', swtnetc_ss, lon=lon, lat=lat
   nc4readvar, filen, 'swtnetna', swtnetcna_ss, lon=lon, lat=lat
   nc4readvar, filen, 'swgnet', swgnetc_ss, lon=lon, lat=lat
   nc4readvar, filen, 'swgnetna', swgnetcna_ss, lon=lon, lat=lat
   nc4readvar, filen, 'ttauss', aot_ss, lon=lon, lat=lat
   nc4readvar, filen, 'olr', lwtnetc_ss, lon=lon, lat=lat
   nc4readvar, filen, 'olrna', lwtnetcna_ss, lon=lon, lat=lat
   nc4readvar, filen, 'lws', lwgnetc_ss, lon=lon, lat=lat
   nc4readvar, filen, 'lwsna', lwgnetcna_ss, lon=lon, lat=lat

  expid = ['v1','v11','v7','v6','v5','v8','v10']

  nexpid = 7

  area, lon, lat, nx, ny, dx, dy, area, grid='b'

  print, 'Model', 'SWTOA', 'SWATM', 'SWSFC', 'LWTOA', 'LWATM', 'LWSFC', 'TOTATM', $
         format='(a-20,7(a8))'

  for iexp = 0, nexpid-1 do begin

   filen = '/misc/prc14/colarco/bF_F25b9-base-v11/inst2d_surf_x_'+expid[iexp]+$
           '/bF_F25b9-base-v11.inst2d_surf_x_'+expid[iexp]+ '.monthly.clim.ANN.nc4'
   nc4readvar, filen, 'swtnet', swtnetc, lon=lon, lat=lat, rc=rc
   nc4readvar, filen, 'swtnetna', swtnetcna, lon=lon, lat=lat
   nc4readvar, filen, 'swgnet', swgnetc, lon=lon, lat=lat
   nc4readvar, filen, 'swgnetna', swgnetcna, lon=lon, lat=lat
   nc4readvar, filen, 'ttaudu', aot, lon=lon, lat=lat
   nc4readvar, filen, 'olr', lwtnetc, lon=lon, lat=lat
   nc4readvar, filen, 'olrna', lwtnetcna, lon=lon, lat=lat
   nc4readvar, filen, 'lws', lwgnetc, lon=lon, lat=lat
   nc4readvar, filen, 'lwsna', lwgnetcna, lon=lon, lat=lat
   filenocean = '/misc/prc14/colarco/bF_F25b9-base-v11/geosgcm_surf_save/bF_F25b9-base-v11.geosgcm_surf.monthly.clim.ANN.nc4'
   nc4readvar, filenocean, 'frocean', frocean, lon=lon, lat=lat

   o = where(frocean gt -1)

   swtoa = (swtnetc-swtnetc_ss)-(swtnetcna-swtnetcna_ss)
   swsfc = (swgnetc-swgnetc_ss)-(swgnetcna-swgnetcna_ss)

   swatm = swtoa-swsfc

   lwtoa = -( (lwtnetc-lwtnetc_ss)-(lwtnetcna-lwtnetcna_ss) )
   lwsfc =  ( (lwgnetc-lwgnetc_ss)-(lwgnetcna-lwgnetcna_ss) )

   lwatm = lwtoa-lwsfc

   print, 'bF_F25b9-base-'+expid[iexp], $
          aave(swtoa[o],area[o],/nan), $; ' (', aave(swtoa[l],area[l],/nan), ');', $    ; SW TOA
          aave(swatm[o],area[o],/nan), $; ' (', aave(swatm[l],area[l],/nan), ');', $    ; SW ATM
          aave(swsfc[o],area[o],/nan), $; ' (', aave(swsfc[l],area[l],/nan), ');', $    ; SW SFC
          aave(lwtoa[o],area[o],/nan), $; ' (', aave(lwtoa[l],area[l],/nan), ');', $    ; LW TOA
          aave(lwatm[o],area[o],/nan), $; ' (', aave(lwatm[l],area[l],/nan), ');', $    ; LW ATM
          aave(lwsfc[o],area[o],/nan), $; ' (', aave(lwsfc[l],area[l],/nan), ');', $    ; LW SFC
          aave(swatm[o],area[o],/nan)+aave(lwatm[o],area[o],/nan), $ ;' (', $           ; SW+LW ATM
;          aave(swatm[l],area[l],/nan)+aave(lwatm[l],area[l],/nan), ')', $
          format='(a-20,7(f8.2))'

  endfor

end
