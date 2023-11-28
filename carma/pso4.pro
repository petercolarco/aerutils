; Plot the production of SO4 from oxidation of SO2
; Baseline
  nc4readvar, 'bF_F25b27-pin_carma.tavg3d_carma_v.ddf', 'pso4', pso4, /template
  nc4readvar, 'bF_F25b27-pin_carma.tavg3d_carma_v.ddf', 'delp', delp, time=time

  pso4_carma = fltarr(5)
  tmp = total(total(pso4,5)*delp,3)/9.8*30*86400.
  area, lon, lat, nx, ny, dx, dy, area, grid='b'
  for it = 0, 4 do begin
   pso4_carma[it] = aave(tmp[*,*,it], area)*5.1e5  ; Tg mon-1
  endfor

; Alt 16 - 25 km
  nc4readvar, 'bF_F25b27-pin_alt16_25.tavg3d_carma_v.ddf', 'pso4', pso4, /template
  nc4readvar, 'bF_F25b27-pin_alt16_25.tavg3d_carma_v.ddf', 'delp', delp, time=time

  pso4_alt16_25 = fltarr(5)
  tmp = total(total(pso4,5)*delp,3)/9.8*30*86400.
  area, lon, lat, nx, ny, dx, dy, area, grid='b'
  for it = 0, 4 do begin
   pso4_alt16_25[it] = aave(tmp[*,*,it], area)*5.1e5  ; Tg mon-1
  endfor

; Alt 16 - 25 km
  nc4readvar, 'bFc_F25b27-pin_alt16_25.tavg3d_carma_v.ddf', 'pso4', pso4, /template
  nc4readvar, 'bFc_F25b27-pin_alt16_25.tavg3d_carma_v.ddf', 'delp', delp, time=time

  pso4_alt16_25c = fltarr(5)
  tmp = total(total(pso4,5)*delp,3)/9.8*30*86400.
  area, lon, lat, nx, ny, dx, dy, area, grid='b'
  for it = 0, 4 do begin
   pso4_alt16_25c[it] = aave(tmp[*,*,it], area)*5.1e5  ; Tg mon-1
  endfor


  x = findgen(5)
  loadct, 39
  set_plot, 'ps'
  device, file='pso4.ps', /color
  !p.font=0

  plot, x, pso4_carma, thick=4, /nodata, $
        xtitle='Months since eruption', $
        ytitle='Production of H2SO4 [Tg mon!E-1!N]'
  oplot, x, pso4_carma, thick=8, color=254
  oplot, x, pso4_alt16_25, thick=8, color=254, lin=2
  oplot, x, pso4_alt16_25c, thick=8, color=58, lin=2

  device, /close

end
