  pro read_diurnal_nc, head, varname, nx, ny, nt, var, nn

  mm = ['01','02','03','04','05','06','07','08','09','10','11','12']
  nd = [ 31,  28,  31,  30,  31,  30,  31,  31,  30,  31,  30,  31 ]


; Get the precomputed preccon
  j = 0
  for im = 0, 11 do begin
   filen = head+'.2014'+mm[im]+'.nc4'
print, filen
   cdfid = ncdf_open(filen)
   id = ncdf_varid(cdfid,'longitude')
   ncdf_varget, cdfid, id, lon
   id = ncdf_varid(cdfid,'latitude')
   ncdf_varget, cdfid, id, lat
   id = ncdf_varid(cdfid,varname)
   ncdf_varget, cdfid, id, var_
   id = ncdf_varid(cdfid,'num')
   ncdf_varget, cdfid, id, nn_
   ncdf_close, cdfid
   a = where(nn_ eq 0.)
   if(a[0] ne -1) then var_[a] = 0.
   a = where(finite(var_) ne 1)
   if(a[0] ne -1) then var_[a] = 0.
   if(a[0] ne -1) then nn_[a] = 0.
   if(j eq 0) then begin
    var = var_*nn_
    nn  = nn_
    j = 1
   endif else begin
    var = var+var_*nn_
    nn  = nn+nn_
   endelse
  endfor

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

  a = where(nn gt 0)
  if(a[0] ne -1) then var[a] = var[a]/nn[a]

  var = reform(var,nx*ny*1L,nt)
  nn  = reform(nn,nx*ny*1L,nt)


end
