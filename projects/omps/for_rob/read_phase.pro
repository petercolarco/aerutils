  cdfid = ncdf_open('phase.nc')

  id = ncdf_varid(cdfid,'altitude')
  ncdf_varget, cdfid, id, h

  id = ncdf_varid(cdfid,'lambda')
  ncdf_varget, cdfid, id, lambda

  id = ncdf_varid(cdfid,'angles')
  ncdf_varget, cdfid, id, angles

  id = ncdf_varid(cdfid,'tau')
  ncdf_varget, cdfid, id, tau

  id = ncdf_varid(cdfid,'ssa')
  ncdf_varget, cdfid, id, ssa

  id = ncdf_varid(cdfid,'p11')
  ncdf_varget, cdfid, id, p11

  ncdf_close, cdfid

end

