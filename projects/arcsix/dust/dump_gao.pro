  cdfid = ncdf_open('/home/colarco/sandbox/Emissions/Dust/input/GAO_source_288x181_3cl.nc')
   id = ncdf_varid(cdfid,'EROD')
   ncdf_varget, cdfid, id, erodold
   id = ncdf_varid(cdfid,'area')
   ncdf_varget, cdfid, id, areaold
   id = ncdf_varid(cdfid,'lon')
   ncdf_varget, cdfid, id, lonold
   id = ncdf_varid(cdfid,'lat')
   ncdf_varget, cdfid, id, latold
  ncdf_close, cdfid
  erodold = erodold[*,*,2]/areaold

  cdfid = ncdf_create('gao.nc',/clobber)
  idlon = ncdf_dimdef(cdfid,'lon',n_elements(lonold))
  idlat = ncdf_dimdef(cdfid,'lat',n_elements(latold))
  idlongitude = ncdf_vardef(cdfid,'lon',[idLon],/float)
  idlatitude  = ncdf_vardef(cdfid,'lat',[idLat],/float)
  idsource    = ncdf_vardef(cdfid,'source',[idLon,idLat],/float)
  ncdf_control, cdfid, /endef
  ncdf_varput, cdfid, idlongitude, lonold
  ncdf_varput, cdfid, idlatitude, latold
  ncdf_varput, cdfid, idsource, erodold
  ncdf_close, cdfid

end
