; ----
  pro read_ext_profile, filename, ext, ssa

  cdfid = ncdf_open(filename)
  id = ncdf_varid(cdfid,'ssa')
  ncdf_varget, cdfid, id, ssa
  id = ncdf_varid(cdfid,'ext')
  ncdf_varget, cdfid, id, ext
  ncdf_close, cdfid

  end

