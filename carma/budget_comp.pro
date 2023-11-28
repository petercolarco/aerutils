; Compare the CARMA and GOCART budgets

; Production of SO4
  filename = 'bF_F25b26-pin_carma.tavg2d_aer_x.ddf'
  nc4readvar, filename, 'so4cmassvolc', cmass, lon=lon, lat=lat, time=time
print, 'got 0'
  nc4readvar, filename, 'susd003volc', susd, lon=lon, lat=lat, time=time
print, 'got 1'
  nc4readvar, filename, 'sudp003volc', sudp, lon=lon, lat=lat, time=time
print, 'got 2'
  nc4readvar, filename, 'suwt003volc', suwt, lon=lon, lat=lat, time=time
print, 'got 3'
  nc4readvar, filename, 'susv003volc', susv, lon=lon, lat=lat, time=time
print, 'got 4'

; Get area average of quantities
  area, lon, lat, nx, ny, dx, dy, area, grid='b'
  cmassa = aave(cmass,area)*total(area)/1e9   ; Tg SO4
  susda  = aave(susd,area)*total(area)/1e9*30.*86400.   ; Tg SO4
  sudpa  = aave(sudp,area)*total(area)/1e9*30.*86400.   ; Tg SO4
  suwta  = aave(suwt,area)*total(area)/1e9*30.*86400.   ; Tg SO4
  susva  = aave(susv,area)*total(area)/1e9*30.*86400.   ; Tg SO4

; CARMA
  filename = 'bF_F25b26-pin_carma.tavg2d_carma_x.ddf'
  nc4readvar, filename, 'sucmass', cmassc, lon=lon, lat=lat, time=time
print, 'got 5'
  nc4readvar, filename, 'susd', susdc, lon=lon, lat=lat, time=time
print, 'got 6'
  nc4readvar, filename, 'sudp', sudpc, lon=lon, lat=lat, time=time
print, 'got 7'
  nc4readvar, filename, 'suwt', suwtc, lon=lon, lat=lat, time=time
print, 'got 8'
  nc4readvar, filename, 'susv', susvc, lon=lon, lat=lat, time=time
print, 'got 9'

; Get area average of quantities
  area, lon, lat, nx, ny, dx, dy, area, grid='b'
  cmassca = aave(cmassc,area)*total(area)/1e9   ; Tg SO4
  susdca  = aave(susdc,area)*total(area)/1e9*30.*86400.   ; Tg SO4
  sudpca  = aave(sudpc,area)*total(area)/1e9*30.*86400.   ; Tg SO4
  suwtca  = aave(suwtc,area)*total(area)/1e9*30.*86400.   ; Tg SO4
  susvca  = aave(susvc,area)*total(area)/1e9*30.*86400.   ; Tg SO4


end
