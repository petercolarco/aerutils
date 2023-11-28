  reff    = fltarr(ny,nt,72)
  for iy = 0, ny-1 do begin
   for it = 0, nt-1 do begin
    for iz = 0, 71 do begin
     dndr = su[iy,iz,it,*]/dr / (4./3.*rhop*r^3.)*rhoa[iy,iz,it]
     reff[iy,it,iz] = total(r^3.*dndr*dr) / total(r^2.*dndr*dr)
    endfor
   endfor
  endfor

end
