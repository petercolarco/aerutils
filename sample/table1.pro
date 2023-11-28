; Colarco
; Print annual mean AOT values using either the qa-weighted or the
; number weighted AOT files

yyyy = '2010'

; Number weight
  nums = '.num'
  numvar = 'num'
; QA-weighted
;  nums = ''
;  numvar = 'qasum'

  res = 'b'

  satid = 'MYD04'

  nan  = 1.e14
  area, lon, lat, nx, ny, dx, dy, area, grid=res

spawn, 'echo $MODISDIR', MODISDIR

  globaot = fltarr(8,2)
  sample  = strarr(8)

  for ioro = 0, 1 do begin

   if(ioro eq 0) then oro = 'ocn'
   if(ioro eq 1) then oro = 'lnd'
   qast = 'qast'
   if(oro eq 'lnd') then qast = 'qast3'

; Full AOT
  nc4readvar, MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y'+yyyy+'/'+satid+'_L2_'+oro+'.aero_tc8_051.'+qast+'_qawt'+nums+'.'+yyyy+'.nc4', 'aot', aot
  nc4readvar, MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y'+yyyy+'/'+satid+'_L2_'+oro+'.aero_tc8_051.'+qast+'_qafl.'+yyyy+'.nc4', numvar, num
  sample[0]       = 'Full Swath'
  globaot[0,ioro] = aave(aot*num,area,nan=nan)/aave(num,area,nan=nan)

; Supermisr
  nc4readvar, MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y'+yyyy+'/'+satid+'_L2_'+oro+'.supermisr.aero_tc8_051.'+qast+'_qawt'+nums+'.'+yyyy+'.nc4', 'aot', aot
  nc4readvar, MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y'+yyyy+'/'+satid+'_L2_'+oro+'.supermisr.aero_tc8_051.'+qast+'_qafl.'+yyyy+'.nc4', numvar, num
  sample[1]       = 'Super-MISR'
  globaot[1,ioro] = aave(aot*num,area,nan=nan)/aave(num,area,nan=nan)

; MISR1
  nc4readvar, MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y'+yyyy+'/'+satid+'_L2_'+oro+'.misr1.aero_tc8_051.'+qast+'_qawt'+nums+'.'+yyyy+'.nc4', 'aot', aot
  nc4readvar, MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y'+yyyy+'/'+satid+'_L2_'+oro+'.misr1.aero_tc8_051.'+qast+'_qafl.'+yyyy+'.nc4', numvar, num
  sample[2]       = 'MISR1'
  globaot[2,ioro] = aave(aot*num,area,nan=nan)/aave(num,area,nan=nan)

; MISR2
  nc4readvar, MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y'+yyyy+'/'+satid+'_L2_'+oro+'.misr2.aero_tc8_051.'+qast+'_qawt'+nums+'.'+yyyy+'.nc4', 'aot', aot
  nc4readvar, MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y'+yyyy+'/'+satid+'_L2_'+oro+'.misr2.aero_tc8_051.'+qast+'_qafl.'+yyyy+'.nc4', numvar, num
  sample[3]       = 'MISR2'
  globaot[3,ioro] = aave(aot*num,area,nan=nan)/aave(num,area,nan=nan)

; MISR3
  nc4readvar, MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y'+yyyy+'/'+satid+'_L2_'+oro+'.misr3.aero_tc8_051.'+qast+'_qawt'+nums+'.'+yyyy+'.nc4', 'aot', aot
  nc4readvar, MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y'+yyyy+'/'+satid+'_L2_'+oro+'.misr3.aero_tc8_051.'+qast+'_qafl.'+yyyy+'.nc4', numvar, num
  sample[4]       = 'MISR3'
  globaot[4,ioro] = aave(aot*num,area,nan=nan)/aave(num,area,nan=nan)

; CALIOP1
  nc4readvar, MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y'+yyyy+'/'+satid+'_L2_'+oro+'.caliop1.aero_tc8_051.'+qast+'_qawt'+nums+'.'+yyyy+'.nc4', 'aot', aot
  nc4readvar, MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y'+yyyy+'/'+satid+'_L2_'+oro+'.caliop1.aero_tc8_051.'+qast+'_qafl.'+yyyy+'.nc4', numvar, num
  sample[5]       = 'CALIOP1'
  globaot[5,ioro] = aave(aot*num,area,nan=nan)/aave(num,area,nan=nan)

; CALIOP2
  nc4readvar, MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y'+yyyy+'/'+satid+'_L2_'+oro+'.caliop2.aero_tc8_051.'+qast+'_qawt'+nums+'.'+yyyy+'.nc4', 'aot', aot
  nc4readvar, MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y'+yyyy+'/'+satid+'_L2_'+oro+'.caliop2.aero_tc8_051.'+qast+'_qafl.'+yyyy+'.nc4', numvar, num
  sample[6]       = 'CALIOP2'
  globaot[6,ioro] = aave(aot*num,area,nan=nan)/aave(num,area,nan=nan)

; CALIOP3
  nc4readvar, MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y'+yyyy+'/'+satid+'_L2_'+oro+'.caliop3.aero_tc8_051.'+qast+'_qawt'+nums+'.'+yyyy+'.nc4', 'aot', aot
  nc4readvar, MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y'+yyyy+'/'+satid+'_L2_'+oro+'.caliop3.aero_tc8_051.'+qast+'_qafl.'+yyyy+'.nc4', numvar, num
  sample[7]       = 'CALIOP3'
  globaot[7,ioro] = aave(aot*num,area,nan=nan)/aave(num,area,nan=nan)

  endfor

  for isam = 0, 7 do begin
   print, sample[isam], globaot[isam,0], globaot[isam,1], format='(a12,2(2x,f5.3))'
  endfor

end
