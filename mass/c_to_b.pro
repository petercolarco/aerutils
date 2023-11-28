; Colarco, May 17, 2007
; c_to_b
; stupid simple procedure to do an area weighted mapping from a
; c-resolution grid to b-resolution

; for now the functionality is only on the latitude portio

  function c_to_b, varval

  if(n_elements(varval) eq 91) then return, varval

; find the area of the c_grid
  lon = findgen(288)*1.25
  lat = -90. + findgen(181)
  area, lon, lat, nx_c, ny_c, dxx_c, dyy_c, area_c

; find the area of the b_grid
  lon = findgen(144)*2.5
  lat = -90. + findgen(91)*2.
  area, lon, lat, nx_b, ny_b, dxx_b, dyy_b, area_b

; assume for the moment a latitude array
  varout = fltarr(ny_b)
  varout[0] = varval[0]
  varout[ny_b-1] = varval[ny_c-1]

; This isn't entirely careful, and note that I divide by area_b/2 because
; the area of the b cell is larger because of the twice as wide in lon space.

  for iy = 1, ny_b-2 do begin
   varout[iy] = ( .5*varval[iy*2-1]*area_c[0,iy*2-1] + $
                     varval[iy*2]  *area_c[0,iy*2]   + $
                  .5*varval[iy*2+1]*area_c[0,iy*2+1] ) / (area_b[0,iy]/2.)
  endfor

  return, varout

end

