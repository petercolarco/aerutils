; Clear-sky aerosol forcing (new 2041-2050 results)
; Subtract SS aerosol forcing from total to yield simply dust.  This
; is done by removing (linearly) the SS forcing from the offline
; calculation. 

; First, read in from the offline calculation the SS aerosol forcing
   filen = '/Volumes/bender/prc14/colarco/bF_F25b9-base-v11/inst2d_surf_x_v1_ss'+$
           '/bF_F25b9-base-v11.inst2d_surf_x_v1_ss.monthly.clim.JJA.nc4'
   nc4readvar, filen, 'swtnet', swtnet_ss, lon=lon, lat=lat
   nc4readvar, filen, 'swtnetna', swtnetna_ss, lon=lon, lat=lat
   nc4readvar, filen, 'swgnet', swgnet_ss, lon=lon, lat=lat
   nc4readvar, filen, 'swgnetna', swgnetna_ss, lon=lon, lat=lat
   nc4readvar, filen, 'ttauss', aot_ss, lon=lon, lat=lat
   nc4readvar, filen, 'olr', lwtnet_ss, lon=lon, lat=lat
   nc4readvar, filen, 'olrna', lwtnetna_ss, lon=lon, lat=lat
   nc4readvar, filen, 'lws', lwgnet_ss, lon=lon, lat=lat
   nc4readvar, filen, 'lwsna', lwgnetna_ss, lon=lon, lat=lat

  expid = ['bF_F25b9-base-v1', 'bF_F25b9-base-v11', 'bF_F25b9-base-v7', $
           'bF_F25b9-base-v6', 'bF_F25b9-base-v5', 'bF_F25b9-base-v8', 'bF_F25b9-base-v10']

  nexpid = 7

  area, lon, lat, nx, ny, dx, dy, area, grid='b'

  print, 'Model', 'SWTOA', 'SWATM', 'SWSFC', 'LWTOA', 'LWATM', 'LWSFC', 'TOTATM', $
         format='(a-20,7(a20))'

  for iexp = 0, nexpid-1 do begin

   filen = '/Volumes/bender/prc14/colarco/'+expid[iexp]+'/geosgcm_surf/'+expid[iexp]+ $
           '.geosgcm_surf.monthly.clim.JJA.nc4'
   nc4readvar, filen, 'swtnet', swtnet, lon=lon, lat=lat
   nc4readvar, filen, 'swtnetna', swtnetna, lon=lon, lat=lat
   nc4readvar, filen, 'swgnet', swgnet, lon=lon, lat=lat
   nc4readvar, filen, 'swgnetna', swgnetna, lon=lon, lat=lat
   nc4readvar, filen, 'ttaudu', aot, lon=lon, lat=lat
   nc4readvar, filen, 'olr', lwtnet, lon=lon, lat=lat
   nc4readvar, filen, 'olrna', lwtnetna, lon=lon, lat=lat
   nc4readvar, filen, 'lws', lwgnet, lon=lon, lat=lat
   nc4readvar, filen, 'lwsna', lwgnetna, lon=lon, lat=lat
   nc4readvar, filen, 'frocean', frocean, lon=lon, lat=lat

   lons = fltarr(144,91)
   for i = 0, 90 do begin
    lons[*,i] = lon
   endfor
   lats = fltarr(144,91)
   for i = 0, 143 do begin
    lats[i,*] = lat
   endfor

   o = where(frocean gt .75 and lats ge 10 and lats le 30 and lons ge -100 and lons le 0)
   l = where(frocean le .75 and lats ge 10 and lats le 30 and lons ge -100 and lons le 0)

   swtoa = (swtnet-swtnet_ss)-(swtnetna-swtnetna_ss)
   swsfc = (swgnet-swgnet_ss)-(swgnetna-swgnetna_ss)
;;  as efficiency
;   swtoa = (swtnet-swtnetna)/aot
;   swsfc = (swgnet-swgnetna)/aot
;   a = where(aot le 0.01)
;   swtoa[a] = !values.f_nan
;   swsfc[a] = !values.f_nan

   swatm = swtoa-swsfc

   lwtoa = -( (lwtnet-lwtnet_ss)-(lwtnetna-lwtnetna_ss) )
   lwsfc =  ( (lwgnet-lwgnet_ss)-(lwgnetna-lwgnetna_ss) )
;;  as efficiency
;   lwtoa = -(lwtnet-lwtnetna)/aot
;   lwsfc = -(lwgnet-lwgnetna)/aot
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
