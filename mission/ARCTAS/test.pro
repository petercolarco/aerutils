  filename = './output/d5_arctas_02.dc8.20080401.nc'
  cdfid = ncdf_open(filename)
  id = ncdf_varid(cdfid,'longitude')
  ncdf_varget, cdfid, id, lon0
  id = ncdf_varid(cdfid,'latitude')
  ncdf_varget, cdfid, id, lat0
  id = ncdf_varid(cdfid,'time')
  ncdf_varget, cdfid, id, time0
  id = ncdf_varid(cdfid,'ps')
  ncdf_varget, cdfid, id, ps0
  id = ncdf_varid(cdfid,'airdens')
  ncdf_varget, cdfid, id, airdens0
  id = ncdf_varid(cdfid,'du')
  ncdf_varget, cdfid, id, du0
  id = ncdf_varid(cdfid,'bc')
  ncdf_varget, cdfid, id, bc0
  id = ncdf_varid(cdfid,'CO')
  ncdf_varget, cdfid, id, co0
  ncdf_close, cdfid

  filename = './output/data/GEOS5_dc8_curtain.20080401.nc'
  cdfid = ncdf_open(filename)
  id = ncdf_varid(cdfid,'longitude')
  ncdf_varget, cdfid, id, lon1
  id = ncdf_varid(cdfid,'latitude')
  ncdf_varget, cdfid, id, lat1
  id = ncdf_varid(cdfid,'time')
  ncdf_varget, cdfid, id, time1
  id = ncdf_varid(cdfid,'ps')
  ncdf_varget, cdfid, id, ps1
  id = ncdf_varid(cdfid,'AIRDENS')
  ncdf_varget, cdfid, id, airdens1
  id = ncdf_varid(cdfid,'du')
  ncdf_varget, cdfid, id, du1
  id = ncdf_varid(cdfid,'bc')
  ncdf_varget, cdfid, id, bc1
  id = ncdf_varid(cdfid,'CO')
  ncdf_varget, cdfid, id, co1
  ncdf_close, cdfid

end


