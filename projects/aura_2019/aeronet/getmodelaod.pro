  pro getmodelaod, expid, stnWant, lamWant, aod, species=species

  if(not(keyword_set(species))) then begin
   tag = 'nc'
  endif else begin
   tag = species+'.nc'
  endelse

  filename = expid+'.inst3d_aer_v.aeronet.ext-'+lamwant+'nm.2016.'+tag
  cdfid = ncdf_open(filename)
  id = ncdf_varid(cdfid,'stnName')
  ncdf_varget, cdfid, id, stnName
  stnName = string(stnName)

  i = where(strcompress(stnName,/rem) eq stnWant)
  id = ncdf_varid(cdfid,'tau')
  ncdf_varget, cdfid, id, aod
  aod = total(aod[*,*,i],1)

  ncdf_close, cdfid

end
