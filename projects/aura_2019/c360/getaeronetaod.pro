  pro getaeronetaod, stnWant, varWant, time, aod

  toff = 5856 ; Sep 1, 0z
  tmax = 6573 ; Sep 30, 21z

  cdfid = ncdf_open('aeronet-2016.aod.nc4')
  id = ncdf_varid(cdfid,'stnName')
  ncdf_varget, cdfid, id, stnName
  stnName = string(stnName)

  id = ncdf_varid(cdfid,'time')
  ncdf_varget, cdfid, id, time, offset=[toff], count=[(tmax-toff)/3+1], stride=[3]

  i = where(strcompress(stnName,/rem) eq stnWant)
  id = ncdf_varid(cdfid,varWant)
  ncdf_varget, cdfid, id, aod, offset=[toff,i], count=[(tmax-toff)/3+1,1], stride=[3,1]
  aod[where(aod gt 100)] = !values.f_nan

  ncdf_close, cdfid

end
