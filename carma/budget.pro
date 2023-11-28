; Get the GOCART volcanic sulfate budget

; Production of SO4
  filename = 'bF_F25b26-pin_carma.tavg2d_aer_x.ddf'
  nc4readvar, filename, 'so4cmassvolc', cmass, lon=lon, lat=lat, time=time
  nc4readvar, filename, 'susd003volc', susd, lon=lon, lat=lat, time=time
  nc4readvar, filename, 'sudp003volc', sudp, lon=lon, lat=lat, time=time
  nc4readvar, filename, 'suwt003volc', suwt, lon=lon, lat=lat, time=time
  nc4readvar, filename, 'susv003volc', susv, lon=lon, lat=lat, time=time

; Get area average of quantities
  area, lon, lat, nx, ny, dx, dy, area, grid='b'
  cmassa = aave(cmass,area)*total(area)/1e9   ; Tg SO4
  susda  = aave(susd,area)*total(area)/1e9*30.*86400.   ; Tg SO4
  sudpa  = aave(sudp,area)*total(area)/1e9*30.*86400.   ; Tg SO4
  suwta  = aave(suwt,area)*total(area)/1e9*30.*86400.   ; Tg SO4
  susva  = aave(susv,area)*total(area)/1e9*30.*86400.   ; Tg SO4

; Actual days per month
  dfac = [31.,28.,31.,30.,31.,30.,31.,31.,30.,31.,30.,31.]
  dfac = [dfac,dfac,dfac,dfac,dfac]
  dfac[13] = 29.
  dfac = dfac/30.

; Total deposition
  sulsa = susda+sudpa+suwta+susva

; Correct for actual days
  sulsa = sulsa*dfac

  sulsat = fltarr(60)
  sulsat[0] = sulsa[0]
  for i = 1, 59 do begin
   sulsat[i] = sulsat[i-1]+sulsa[i]
  endfor

  plot, sulsat+cmassa

end
