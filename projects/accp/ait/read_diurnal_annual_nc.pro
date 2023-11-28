  pro read_diurnal_annual_nc, filen, varname, nx, ny, nt, lon, lat, var, nn

  mm = ['01','02','03','04','05','06','07','08','09','10','11','12']
  nd = [ 31,  28,  31,  30,  31,  30,  31,  31,  30,  31,  30,  31 ]


; Get the precomputed preccon
   cdfid = ncdf_open(filen)
   id = ncdf_varid(cdfid,'longitude')
   ncdf_varget, cdfid, id, lon
   id = ncdf_varid(cdfid,'latitude')
   ncdf_varget, cdfid, id, lat
   id = ncdf_varid(cdfid,varname)
   ncdf_varget, cdfid, id, var
   id = ncdf_varid(cdfid,'num')
   ncdf_varget, cdfid, id, nn
   ncdf_close, cdfid

  nx = n_elements(lon)
  ny = n_elements(lat)
  nt = 24

; Shift on the local hour
; @ GSFC is 77 W, s/b hours off from UTC: 10 UTC = 5 local
  for ix = 0, nx-1 do begin
   ihr = fix((lon[ix]-7.5)/15.)
   var[ix,*,*]  = shift(reform(var[ix,*,*]),0,ihr)
   nn[ix,*,*]   = shift(reform(nn[ix,*,*]),0,ihr)
  endfor

  a = where(var gt 1e12)
  if(a[0] ne -1) then begin
   var[a] = 0.
   nn[a] = 0
  endif

end
