; Open CALIPSO file and get lat/lon/time and write CSV file
;  cdfid = ncdf_open('CAL_LID_L2_05kmAPro-Standard-V4-20.2017-08-13T10-46-00ZN.nc')
  cdfid = ncdf_open('CAL_LID_L2_05kmAPro-Standard-V4-20.2017-08-14T18-51-15ZD.nc')
  id = ncdf_varid(cdfid,'Longitude')
  ncdf_varget, cdfid, id, lon
  id = ncdf_varid(cdfid,'Latitude')
  ncdf_varget, cdfid, id, lat
  a = where(lat gt 30)
  lon=lon[a]
  lat=lat[a]
  ncdf_close, cdfid

  npts = n_elements(lon)

; Create a file
  openw, lun, 'calipso.csv', /get
  printf, lun, 'lon,lat,time'
  for i = 0, npts-1 do begin
   str = string(lon[i],format='(f8.3)')+','+$
;         string(lat[i],format='(f6.3)')+','+'2017-08-13T11:00:00'
         string(lat[i],format='(f6.3)')+','+'2017-08-14T20:00:00'
   printf, lun, str
  endfor


end
