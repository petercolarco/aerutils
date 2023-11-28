  cdfid = ncdf_open('c180R_pI33p7.calipso.201601.nc')
   id = ncdf_varid(cdfid,'isotime')
   ncdf_varget, cdfid, id, isotime
   isotime = string(isotime)
   nymd = strmid(isotime,0,4)+strmid(isotime,5,2)+strmid(isotime,8,2)
   hh   = strmid(isotime,11,2)
   id = ncdf_varid(cdfid,'trjLon')
   ncdf_varget, cdfid, id, lon_
   id = ncdf_varid(cdfid,'trjLat')
   ncdf_varget, cdfid, id, lat_
   id = ncdf_varid(cdfid,'TOTEXTTAU')
   ncdf_varget, cdfid, id, tau
  ncdf_close, cdfid

end
