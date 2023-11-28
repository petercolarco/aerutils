; Plot the production of SO4 from oxidation of SO2
; Alt 16 - 25 km
  nc4readvar, 'bF_F25b27-pin_carma.tavg3d_carma_v.ddf', 'sunuc', sunuc
  nc4readvar, 'bF_F25b27-pin_carma.tavg3d_carma_v.ddf', 'delp', delp, time=time
  nc4readvar, 'bF_F25b27-pin_carma.tavg3d_carma_v.ddf', 'airdens', rhoa, time=time

  sunuc_carma = fltarr(5)
  tmp = total(sunuc*delp/rhoa,3)/9.8*30*86400.
  area, lon, lat, nx, ny, dx, dy, area, grid='b'
  for it = 0, 4 do begin
   sunuc_carma[it] = aave(tmp[*,*,it], area)*5.1e5  ; Tg mon-1
  endfor

; Plot the production of SO4 from oxidation of SO2
; Alt 16 - 25 km
  nc4readvar, 'bF_F25b27-pin_alt16_25.tavg3d_carma_v.ddf', 'sunuc', sunuc
  nc4readvar, 'bF_F25b27-pin_alt16_25.tavg3d_carma_v.ddf', 'delp', delp, time=time
  nc4readvar, 'bF_F25b27-pin_alt16_25.tavg3d_carma_v.ddf', 'airdens', rhoa, time=time

  sunuc_alt16_25 = fltarr(5)
  tmp = total(sunuc*delp/rhoa,3)/9.8*30*86400.
  area, lon, lat, nx, ny, dx, dy, area, grid='b'
  for it = 0, 4 do begin
   sunuc_alt16_25[it] = aave(tmp[*,*,it], area)*5.1e5  ; Tg mon-1
  endfor

; Alt 16 - 25 km (CARMA active)
  nc4readvar, 'bFc_F25b27-pin_alt16_25.tavg3d_carma_v.ddf', 'sunuc', sunuc
  nc4readvar, 'bFc_F25b27-pin_alt16_25.tavg3d_carma_v.ddf', 'delp', delp, time=time
  nc4readvar, 'bFc_F25b27-pin_alt16_25.tavg3d_carma_v.ddf', 'airdens', rhoa, time=time

  sunuc_alt16_25c = fltarr(5)
  tmp = total(sunuc*delp/rhoa,3)/9.8*30*86400.
  area, lon, lat, nx, ny, dx, dy, area, grid='b'
  for it = 0, 4 do begin
   sunuc_alt16_25c[it] = aave(tmp[*,*,it], area)*5.1e5  ; Tg mon-1
  endfor


  x = findgen(5)
  loadct, 39
  set_plot, 'ps'
  device, file='sunuc.ps', /color
  !p.font=0

  plot, x, sunuc_alt16_25, thick=4, /nodata, /ylog, $
        xtitle='Months since eruption', $
        ytitle='Nucleation Rate [m!E-2!N mon!E-1!N]'
  oplot, x, sunuc_carma, thick=8, color=254
  oplot, x, sunuc_alt16_25, thick=8, color=254, lin=2
  oplot, x, sunuc_alt16_25c, thick=8, color=58, lin=2

  device, /close


end
