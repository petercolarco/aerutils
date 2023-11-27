  function average_land_ocean, aoto, aotl, lon, lat

  nx = n_elements(lon)
  ny = n_elements(lat)

  a = where(aoto gt 1.e14)
  aoto[a] = !values.f_nan
  a = where(aotl gt 1.e14)
  aotl[a] = !values.f_nan

;  aot = fltarr(nx*ny*1L)
;  aoto = reform(aoto,nx*ny*1L)
;  aotl = reform(aotl,nx*ny*1L)
;  for i = 0L, nx*ny-1 do begin
;    aot[i] = mean([aoto[i],aotl[i]],/nan)
;  endfor

aot = aoto
a = where(finite(aotl) eq 1)
aot[a] = aotl[a]

  aot = reform(aot,nx,ny)

  return, aot

end
