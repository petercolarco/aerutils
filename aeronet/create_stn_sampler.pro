; Colarco
; Create a "stn_sampler.csv" file based on aeronet_locs.dat file

  aerPath =  '/misc/prc10/AERONET/V3/LEV30/aot_monthly.nc'

  cdfid = ncdf_open(aerPath)
   id = ncdf_varid(cdfid,'location')
   ncdf_varget, cdfid, id, location
   location = string(location)
   id = ncdf_varid(cdfid,'lon')
   ncdf_varget, cdfid, id, lon
   id = ncdf_varid(cdfid,'lat')
   ncdf_varget, cdfid, id, lat
   id = ncdf_varid(cdfid,'elevation')
   ncdf_varget, cdfid, id, elevation
  ncdf_close, cdfid

  openw, lun, 'stn_sampler.csv', /get
  printf, lun, 'name,lon,lat'
  n = n_elements(location)
  for i = 0, n-1 do begin
   printf, lun, location[i],',',$
           strcompress(string(lon[i],format='(f8.3)'),/rem),',', $
           strcompress(string(lat[i],format='(f7.3)'),/rem)
  endfor

  free_lun, lun

end
