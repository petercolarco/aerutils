; Colarco
; Print annual mean AOT values using either the qa-weighted or the
; number weighted AOT files

; Number weight
  nums = '.num'
  numvar = 'num'
; QA-weighted
;  nums = ''
;  numvar = 'qasum'

  oro = 'ocn'
;  oro = 'lnd'
  qast = 'qast'
  if(oro eq 'lnd') then qast = 'qast3'

  res = 'd'
;  res = 'ten'

;  satid = 'MYD04'
  satid = 'MOD04'

  nan  = 1.e14
  area, lon, lat, nx, ny, dx, dy, area, grid=res

spawn, 'echo $MODISDIR', MODISDIR

; Full AOT
  nc4readvar, MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y2009/'+satid+'_L2_'+oro+'.aero_tc8_051.'+qast+'_qawt'+nums+'.2009.nc4', 'aot', aot
  nc4readvar, MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y2009/'+satid+'_L2_'+oro+'.aero_tc8_051.'+qast+'_qafl'+nums+'.2009.nc4', numvar, num
  print, aave(aot*num,area,nan=nan)/aave(num,area,nan=nan)

; Supermisr
  nc4readvar, MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y2009/'+satid+'_L2_'+oro+'.supermisr.aero_tc8_051.'+qast+'_qawt'+nums+'.2009.nc4', 'aot', aot
  nc4readvar, MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y2009/'+satid+'_L2_'+oro+'.supermisr.aero_tc8_051.'+qast+'_qafl'+nums+'.2009.nc4', numvar, num
  print, aave(aot*num,area,nan=nan)/aave(num,area,nan=nan)

; MISR1
  nc4readvar, MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y2009/'+satid+'_L2_'+oro+'.misr1.aero_tc8_051.'+qast+'_qawt'+nums+'.2009.nc4', 'aot', aot
  nc4readvar, MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y2009/'+satid+'_L2_'+oro+'.misr1.aero_tc8_051.'+qast+'_qafl'+nums+'.2009.nc4', numvar, num
  print, aave(aot*num,area,nan=nan)/aave(num,area,nan=nan)

; MISR2
  nc4readvar, MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y2009/'+satid+'_L2_'+oro+'.misr2.aero_tc8_051.'+qast+'_qawt'+nums+'.2009.nc4', 'aot', aot
  nc4readvar, MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y2009/'+satid+'_L2_'+oro+'.misr2.aero_tc8_051.'+qast+'_qafl'+nums+'.2009.nc4', numvar, num
  print, aave(aot*num,area,nan=nan)/aave(num,area,nan=nan)

; CALIOP1
  nc4readvar, MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y2009/'+satid+'_L2_'+oro+'.caliop1.aero_tc8_051.'+qast+'_qawt'+nums+'.2009.nc4', 'aot', aot
  nc4readvar, MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y2009/'+satid+'_L2_'+oro+'.caliop1.aero_tc8_051.'+qast+'_qafl'+nums+'.2009.nc4', numvar, num
  print, aave(aot*num,area,nan=nan)/aave(num,area,nan=nan)

; CALIOP2
  nc4readvar, MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y2009/'+satid+'_L2_'+oro+'.caliop2.aero_tc8_051.'+qast+'_qawt'+nums+'.2009.nc4', 'aot', aot
  nc4readvar, MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y2009/'+satid+'_L2_'+oro+'.caliop2.aero_tc8_051.'+qast+'_qafl'+nums+'.2009.nc4', numvar, num
  print, aave(aot*num,area,nan=nan)/aave(num,area,nan=nan)

end
