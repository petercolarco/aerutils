; Colarco, January 2016
; Read my gridded retrievals files

  pro read_retrieval, filen, lon, lat, $
                      ler388, ref388, aod, ssa, $
                      aerh, aert, residue, ai, prs

  cdfid = ncdf_open(filen)

  id = ncdf_varid(cdfid,'lon')
  ncdf_varget, cdfid, id, lon

  id = ncdf_varid(cdfid,'lat')
  ncdf_varget, cdfid, id, lat

  id = ncdf_varid(cdfid,'ler388')
  ncdf_varget, cdfid, id, ler388

;  id = ncdf_varid(cdfid,'ler354')
;  ncdf_varget, cdfid, id, ler354

  id = ncdf_varid(cdfid,'ref388')
  ncdf_varget, cdfid, id, ref388

;  id = ncdf_varid(cdfid,'ref354')
;  ncdf_varget, cdfid, id, ref354

  id = ncdf_varid(cdfid,'aerh')
  ncdf_varget, cdfid, id, aerh

  id = ncdf_varid(cdfid,'aod388')
  ncdf_varget, cdfid, id, aod

  id = ncdf_varid(cdfid,'ssa388')
  ncdf_varget, cdfid, id, ssa

  id = ncdf_varid(cdfid,'aert')
  ncdf_varget, cdfid, id, aert

  id = ncdf_varid(cdfid,'residue')
  ncdf_varget, cdfid, id, residue

  id = ncdf_varid(cdfid,'ai')
  ncdf_varget, cdfid, id, ai

  id = ncdf_varid(cdfid,'pressure')
  ncdf_varget, cdfid, id, prs

  ncdf_close, cdfid

; Mask out aerh and aert where aod not present
  a = where(aod lt -1.e30)
  aert[a] = min(aod)
  aerh[a] = min(aod)


end
