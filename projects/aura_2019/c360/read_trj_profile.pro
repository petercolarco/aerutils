  pro read_trj_profile, expid, date, time, h, rhoa, bc, brc, oc


  cdfid = ncdf_open(expid+'.'+date+'.trj.nc')
  id = ncdf_varid(cdfid,'time')
  ncdf_varget, cdfid, id, time
  id = ncdf_varid(cdfid,'H')
  ncdf_varget, cdfid, id, h
  id = ncdf_varid(cdfid,'AIRDENS')
  ncdf_varget, cdfid, id, rhoa
  id = ncdf_varid(cdfid,'BCPHOBIC')
  ncdf_varget, cdfid, id, bcphobic
  id = ncdf_varid(cdfid,'BCPHILIC')
  ncdf_varget, cdfid, id, bcphilic
  id = ncdf_varid(cdfid,'BRCPHOBIC')
  ncdf_varget, cdfid, id, brcphobic
  id = ncdf_varid(cdfid,'BRCPHILIC')
  ncdf_varget, cdfid, id, brcphilic
  id = ncdf_varid(cdfid,'OCPHOBIC')
  ncdf_varget, cdfid, id, ocphobic
  id = ncdf_varid(cdfid,'OCPHILIC')
  ncdf_varget, cdfid, id, ocphilic
  ncdf_close, cdfid
  bc  = bcphilic+bcphobic
  brc = brcphilic+brcphobic
  oc  = ocphilic+ocphobic

  end

