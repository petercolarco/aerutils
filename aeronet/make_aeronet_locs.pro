; Colarco, February 2006
; Read from the AERONET data files I have assembled the site names, lat, lon,
; and elevation.  These are used by GRADS/LATS4D to pull out the AERONET
; site extractions from the model runs.

; Choose sites that are common to both the AOT and INVERSIONS dataset

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

  londeg = fix(lon)
  lonmin = fix( (lon-londeg) / (1./60.))
  lonsec = fix( (lon - (londeg+lonmin/60.)) / (1./3600.))
  lonmin = abs(lonmin)
  lonsec = abs(lonsec)

  latdeg = fix(lat)
  latmin = fix( (lat-latdeg) / (1./60.))
  latsec = fix( (lat - (latdeg+latmin/60.)) / (1./3600.))
  latmin = abs(latmin)
  latsec = abs(latsec)

  elevation = fix(elevation)

; Get the inversions dataset
  aerPath = headDir+'LEV30/inversions_monthly.nc'
  cdfid = ncdf_open(aerPath)
   id = ncdf_varid(cdfid,'location')
   ncdf_varget, cdfid, id, locationInv
   locationInv = string(locationInv)
  ncdf_close, cdfid

  openw, lun, 'aeronet_locs.dat', /get_lun
  printf, lun, '# AERONET Locations'
  printf, lun, '# Location Lat (deg,min,sec) Lon (deg,min,sec) Elevation(m)'
  n_sites = n_elements(location)
  for i = 0, n_sites-1 do begin
   a = where(location[i] eq locationInv)
   if(a[0] eq -1) then continue
   locstr = string('# '+location[i], format='(a30)')
;   printf, lun, '# '+location[i], latdeg[i], latmin[i], latsec[i], $
   printf, lun, location[i], latdeg[i], latmin[i], latsec[i], $
                                  londeg[i], lonmin[i], lonsec[i], $
                                  elevation[i], $
                format='(a-30,6(1x,i4),1x,i5)'
  endfor
  free_lun, lun

end

