  files = file_search('./raw/','htap*elev*nc4')

  nf = n_elements(files)
  for i = 0, nf-1 do begin
   cdfid = ncdf_open(files[i])
   id = ncdf_varid(cdfid,'lon')
   ncdf_varget, cdfid, id, lon
   id = ncdf_varid(cdfid,'lat')
   ncdf_varget, cdfid, id, lat
   id = ncdf_varid(cdfid,'time')
   ncdf_varget, cdfid, id, time
   id = ncdf_varid(cdfid,'sanl2')
   ncdf_varget, cdfid, id, sanl
   ncdf_close, cdfid
;  Fix fill
   a = where(finite(sanl) ne 1)
   if(a[0] ne -1) then sanl[a] = 0.0

;  Create a new file
   outFile = './tmp/'+strmid(files[i],4,100)
   print, outFile
   cdfid = NCDF_CREATE(outFile, /clobber)
    nx = n_elements(lon)
    ny = n_elements(lat)
    nt = n_elements(time)
    idLon = NCDF_DIMDEF(cdfid,'lon',nx)
    idLat = NCDF_DIMDEF(cdfid,'lat',ny)
    idTime = NCDF_DIMDEF(cdfid,'time',/unlimited)
    idLongitude = NCDF_VARDEF(cdfid,'lon',[idLon], /float)
    idLatitude  = NCDF_VARDEF(cdfid,'lat',[idLat], /float)
    idDate      = NCDF_VARDEF(cdfid,'time', [idTime], /long)
    idSanl      = NCDF_VARDEF(cdfid,'sanl2',[idLon,idLat,idTime], /float)
    ncdf_control, cdfid, /endef
    ncdf_varput, cdfid, idLongitude, lon
    ncdf_varput, cdfid, idLatitude, lat
    ncdf_varput, cdfid, idDate, time
    ncdf_varput, cdfid, idSanl, sanl
   ncdf_close, cdfid

  endfor

end
