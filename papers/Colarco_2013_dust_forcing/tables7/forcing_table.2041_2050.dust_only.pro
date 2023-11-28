; Clear-sky aerosol forcing (new 2041-2050 results)
; Subtract SS aerosol forcing from total to yield simply dust.  This
; is done by removing (linearly) the SS forcing from the offline
; calculation. 

; First, read in from the offline calculation the SS aerosol forcing
   filen = '/Volumes/bender/prc14/colarco/bF_F25b9-base-v11/inst2d_surf_x_v1_ss'+$
           '/bF_F25b9-base-v11.inst2d_surf_x_v1_ss.monthly.clim.ANN.nc4'
   nc4readvar, filen, 'swtnetc', swtnetc_ss, lon=lon, lat=lat
   nc4readvar, filen, 'swtnetcna', swtnetcna_ss, lon=lon, lat=lat
   nc4readvar, filen, 'swgnetc', swgnetc_ss, lon=lon, lat=lat
   nc4readvar, filen, 'swgnetcna', swgnetcna_ss, lon=lon, lat=lat
   nc4readvar, filen, 'ttauss', aot_ss, lon=lon, lat=lat
   nc4readvar, filen, 'olrc', lwtnetc_ss, lon=lon, lat=lat
   nc4readvar, filen, 'olrcna', lwtnetcna_ss, lon=lon, lat=lat
   nc4readvar, filen, 'lwsc', lwgnetc_ss, lon=lon, lat=lat
   nc4readvar, filen, 'lwscna', lwgnetcna_ss, lon=lon, lat=lat

  expid = ['bF_F25b9-base-v1', 'bF_F25b9-base-v11', 'bF_F25b9-base-v7', $
           'bF_F25b9-base-v6', 'bF_F25b9-base-v5', 'bF_F25b9-base-v8', 'bF_F25b9-base-v10']

  nexpid = 7

  area, lon, lat, nx, ny, dx, dy, area, grid='b'

  print, 'Model', 'SWTOA', 'SWATM', 'SWSFC', 'LWTOA', 'LWATM', 'LWSFC', 'TOTATM', $
         format='(a-20,7(a20))'

  for iexp = 0, nexpid-1 do begin

   filen = '/Volumes/bender/prc14/colarco/'+expid[iexp]+'/geosgcm_surf/'+expid[iexp]+ $
           '.geosgcm_surf.monthly.clim.ANN.nc4'
   nc4readvar, filen, 'swtnetc', swtnetc, lon=lon, lat=lat
   nc4readvar, filen, 'swtnetcna', swtnetcna, lon=lon, lat=lat
   nc4readvar, filen, 'swgnetc', swgnetc, lon=lon, lat=lat
   nc4readvar, filen, 'swgnetcna', swgnetcna, lon=lon, lat=lat
   nc4readvar, filen, 'ttaudu', aot, lon=lon, lat=lat
   nc4readvar, filen, 'olrc', lwtnetc, lon=lon, lat=lat
   nc4readvar, filen, 'olrcna', lwtnetcna, lon=lon, lat=lat
   nc4readvar, filen, 'lwsc', lwgnetc, lon=lon, lat=lat
   nc4readvar, filen, 'lwscna', lwgnetcna, lon=lon, lat=lat
   nc4readvar, filen, 'frocean', frocean, lon=lon, lat=lat

   o = where(frocean gt .75)
   l = where(frocean le .75)

   swtoa = (swtnetc-swtnetc_ss)-(swtnetcna-swtnetcna_ss)
   swsfc = (swgnetc-swgnetc_ss)-(swgnetcna-swgnetcna_ss)
;;  as efficiency
;   swtoa = (swtnetc-swtnetcna)/aot
;   swsfc = (swgnetc-swgnetcna)/aot
;   a = where(aot le 0.01)
;   swtoa[a] = !values.f_nan
;   swsfc[a] = !values.f_nan

   swatm = swtoa-swsfc

   lwtoa = -( (lwtnetc-lwtnetc_ss)-(lwtnetcna-lwtnetcna_ss) )
   lwsfc =  ( (lwgnetc-lwgnetc_ss)-(lwgnetcna-lwgnetcna_ss) )
;;  as efficiency
;   lwtoa = -(lwtnetc-lwtnetcna)/aot
;   lwsfc = -(lwgnetc-lwgnetcna)/aot
;   a = where(aot le 0.01)
;   lwtoa[a] = !values.f_nan
;   lwsfc[a] = !values.f_nan

   lwatm = lwtoa-lwsfc

   print, expid[iexp], $
          aave(swtoa[o],area[o],/nan), ' (', aave(swtoa[l],area[l],/nan), ');', $    ; SW TOA
          aave(swatm[o],area[o],/nan), ' (', aave(swatm[l],area[l],/nan), ');', $    ; SW ATM
          aave(swsfc[o],area[o],/nan), ' (', aave(swsfc[l],area[l],/nan), ');', $    ; SW SFC
          aave(lwtoa[o],area[o],/nan), ' (', aave(lwtoa[l],area[l],/nan), ');', $    ; LW TOA
          aave(lwatm[o],area[o],/nan), ' (', aave(lwatm[l],area[l],/nan), ');', $    ; LW ATM
          aave(lwsfc[o],area[o],/nan), ' (', aave(lwsfc[l],area[l],/nan), ');', $    ; LW SFC
          aave(swatm[o],area[o],/nan)+aave(lwatm[o],area[o],/nan), ' (', $           ; SW+LW ATM
          aave(swatm[l],area[l],/nan)+aave(lwatm[l],area[l],/nan), ')', $
          format='(a-20,7(f8.2,a2,f8.2,a2))'

  endfor

end
