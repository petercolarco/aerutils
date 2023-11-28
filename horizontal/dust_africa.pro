; Colarco, February 2011
; Plot the AOT in the dust belt for some period of time

; Get the climatology of MODIS observations
  yyyy = strpad(findgen(10)+2000,1000)
  mm   = '07'
; TERRA
  nyr = n_elements(yyyy)
  for iyr = 0, nyr-1 do begin
   read_modis, aot_, lon, lat, yyyy[iyr], mm, res='b'
   if(iyr eq 0) then begin
    nx = n_elements(lon)
    ny = n_elements(lat)
    aot = make_array(nx,ny,nyr*2,val=!values.f_nan)
   endif
   aot[*,*,iyr] = aot_
  endfor

; AQUA
  for iyr = 0, nyr-1 do begin
   read_modis, aot_, lon, lat, yyyy[iyr], mm, res='b', satid='MYD04'
   aot[*,*,nyr+iyr] = aot_
  endfor

end
