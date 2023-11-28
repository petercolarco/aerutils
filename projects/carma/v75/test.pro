  temp = 212.
  rh = findgen(1000)*.001
  rcm = 1.e-5
  rwet = fltarr(1000)
  for i = 0, 999 do begin
   rwet[i] = grow_v75(rh[i],rcm,t=temp)*rcm
  endfor

 end
