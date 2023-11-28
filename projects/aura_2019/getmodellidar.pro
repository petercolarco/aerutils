  pro getmodellidar, expid, stnWant, lamWant, ext2back, rh, ext, h

; Get the RH and H
  str = strsplit(expid,'.',/extract)
  filename = str[0]+'.inst3d_aer_v.aeronet.2016.nc'
  cdfid = ncdf_open(filename)
  id = ncdf_varid(cdfid,'stnName')
  ncdf_varget, cdfid, id, stnName
  stnName = string(stnName)

  i = where(strcompress(stnName,/rem) eq stnWant)
  id = ncdf_varid(cdfid,'RH')
  ncdf_varget, cdfid, id, rh
  rh = rh[*,*,i]
  id = ncdf_varid(cdfid,'H')
  ncdf_varget, cdfid, id, h
  h = h[*,*,i]
  ncdf_close, cdfid

; Get the BRC extinction
  filename = expid+'.inst3d_aer_v.aeronet.ext-'+lamwant+'nm.2016.brc.nc'
  cdfid = ncdf_open(filename)
  id = ncdf_varid(cdfid,'stnName')
  ncdf_varget, cdfid, id, stnName
  stnName = string(stnName)

  i = where(strcompress(stnName,/rem) eq stnWant)
  id = ncdf_varid(cdfid,'ext')
  ncdf_varget, cdfid, id, ext
  ext = ext[*,*,i]

  ncdf_close, cdfid

; Get the integrated lidar ratio
  filename = expid+'.inst3d_aer_v.aeronet.ext-'+lamwant+'nm.2016.nc'
  cdfid = ncdf_open(filename)
  id = ncdf_varid(cdfid,'stnName')
  ncdf_varget, cdfid, id, stnName
  stnName = string(stnName)

  i = where(strcompress(stnName,/rem) eq stnWant)
  id = ncdf_varid(cdfid,'ext2back')
  ncdf_varget, cdfid, id, ext2back
  ext2back = ext2back[*,*,i]

  ncdf_close, cdfid

end
