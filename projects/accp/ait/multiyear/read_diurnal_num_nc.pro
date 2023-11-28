  pro read_diurnal_num_nc, head, lon, lat, nx, ny, nt, nn

  mm = ['01','02','03','04','05','06','07','08','09','10','11','12']
  nd = [ 31,  28,  31,  30,  31,  30,  31,  31,  30,  31,  30,  31 ]


; Get the precomputed preccon
  for im = 0, 11 do begin
   filen = head+'.2014'+mm[im]+'.nc'
print, filen
   cdfid = ncdf_open(filen)
   id = ncdf_varid(cdfid,'lon')
   ncdf_varget, cdfid, id, lon_
   id = ncdf_varid(cdfid,'lat')
   ncdf_varget, cdfid, id, lat_
   id = ncdf_varid(cdfid,'num')
   ncdf_varget, cdfid, id, nn_
   ncdf_close, cdfid
   if(im eq 0) then begin
    nn  = nn_
   endif else begin
    nn  = nn+nn_
   endelse
  endfor

  nx = n_elements(lon_)
  ny = n_elements(lat_)
  lon = fltarr(nx,ny)
  lat = fltarr(nx,ny)
  for ix = 0, nx-1 do begin
   lat[ix,*] = lat_
  endfor
  for iy = 0, ny-1 do begin
   lon[*,iy] = lon_
  endfor
  nt = 24
  nn  = reform(nn,nx*ny*1L,nt)

end
