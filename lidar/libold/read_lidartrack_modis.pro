; Colarco, October 2006
; Specify a species (du, su, ss, oc, bc, total) and return the
; GLAS-track extracted profiles of the following variables:
;  mmr   = mass mixing ratio [kg species/kg air]
;  ssa   = single-scatter albedo
;  tau   = extinction optical thickness of layer
;  backscat = backscattering of layer
; Read the ancillary met data (read_glastrack_met.pro) to get
; atmospheric state variables.
; To go from mmr => concentration:
  pro read_lidartrack_modis, time, date, lon, lat, lev, tau, $
                             filename = filename

  if(not(keyword_set(filename))) then filename = 'lidartrack_modis.ncdf'

  cdfid = ncdf_open(filename)
   id = ncdf_varid(cdfid, 'time')
   ncdf_varget, cdfid, id, time
   id = ncdf_varid(cdfid, 'date')
   ncdf_varget, cdfid, id, date
   id = ncdf_varid(cdfid, 'lon')
   ncdf_varget, cdfid, id, lon
   id = ncdf_varid(cdfid, 'lat')
   ncdf_varget, cdfid, id, lat
   id = ncdf_varid(cdfid, 'lev')
   ncdf_varget, cdfid, id, lev
   id = ncdf_varid(cdfid, 'tau')
   ncdf_varget, cdfid, id, tau

  ncdf_close, cdfid

; discard fill values (large numbers)
  a = where(tau gt 10)
  if(a[0] ne -1) then tau[a] = !values.f_nan

end

