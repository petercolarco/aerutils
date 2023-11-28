; Get a 2d trajectory output file for some time period and grid the
; results to a GEOS model grid

  wantdates = '2016'+string(indgen(12)+1,format='(i02)')
  satid = 'iss'

; Get a model grid
  area, lon, lat, nx, ny, dx, dy, area, grid='d'

; Loop over times
  for k = 0, 11 do begin

  print, wantdates[k]

; Open a file
  cdfid = ncdf_open('c180R_pI33p7.'+satid+'.'+wantdates[k]+'.nc')
   id = ncdf_varid(cdfid,'trjLon')
   ncdf_varget, cdfid, id, lon_
   id = ncdf_varid(cdfid,'trjLat')
   ncdf_varget, cdfid, id, lat_
   id = ncdf_varid(cdfid,'TOTEXTTAU')
   ncdf_varget, cdfid, id, tau
  ncdf_close, cdfid

; Create the model interpolate points
  ix = fix(interpol(indgen(nx),lon,lon_)+.5)
  ix[where(ix gt nx-1, /null)] = 0
  iy = fix(interpol(indgen(ny),lat,lat_)+.5)
  iy[where(iy gt ny-1, /null)] = ny-1
  ixy = iy*nx+ix
  ixyuniq = ixy[uniq(ixy)]
  n = n_elements(ixyuniq)

; Make output arrays
  num = intarr(nx,ny)
  val = make_array(nx,ny,val=!values.f_nan)
  for j = 0, n-1 do begin
   a = where(ixy eq ixyuniq(j), count)
;   print, j, n, count
   if(count gt 0) then begin
    val[ixyuniq(j)] = mean(tau[a])
    num[ixyuniq(j)] = count
   endif
  endfor

; Write to a file
  write_var, './', 'c180R_pI33p7.'+satid+'.totexttau.monthly', $
             nx, ny, dx, dy, wantdates[k]+'1512', $
             lon, lat, val, 'totexttau', resolution = 'd'
  write_var, './', 'c180R_pI33p7.'+satid+'.num.monthly', $
             nx, ny, dx, dy, wantdates[k]+'1512', $
             lon, lat, num, 'num', resolution = 'd'

  endfor

end
