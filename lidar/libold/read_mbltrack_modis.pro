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
  pro read_mbltrack_modis, time, date, lon, lat, lev, tau, res=res

  if(not keyword_set(res)) then res = 'e'

; Get dimensions from first file
  cdfid = ncdf_open('./MYD04_'+res+'/MYD04_L2_ocn.aero_005.noqawt.'+res+'.lidartrack_offset.nadir.txt.ncdf')
;  cdfid = ncdf_open('./MYD04_L2_ocn.aero_005.noqawt.'+res+'.lidartrack_offset.nadir.txt.ncdf')
   id = ncdf_varid(cdfid, 'time')
   ncdf_varget, cdfid, id, time
   id = ncdf_varid(cdfid, 'date')
   ncdf_varget, cdfid, id, date
   id = ncdf_varid(cdfid, 'lon')
   ncdf_varget, cdfid, id, lon_
   id = ncdf_varid(cdfid, 'lat')
   ncdf_varget, cdfid, id, lat_
   id = ncdf_varid(cdfid, 'lev')
   ncdf_varget, cdfid, id, lev
   id = ncdf_varid(cdfid, 'tau')
   ncdf_varget, cdfid, id, tau_
  ncdf_close, cdfid

; Now setup the output arrays and fill
  nt = n_elements(time)
  lon = fltarr(nt,7)
  lat = fltarr(nt,7)
  tau = fltarr(nt,7)

; Now read in all the fields
  track = ['neg15deg','neg10deg','neg5deg','nadir','pos5deg','pos10deg','pos15deg']
  for i = 0, 6 do begin
  cdfid = ncdf_open('./MYD04_'+res+'/MYD04_L2_ocn.aero_005.noqawt.'+res+'.lidartrack_offset.'+track[i]+'.txt.ncdf')
;  cdfid = ncdf_open('./MYD04_L2_ocn.aero_005.noqawt.'+res+'.lidartrack_offset.'+track[i]+'.txt.ncdf')
   id = ncdf_varid(cdfid, 'lon')
   ncdf_varget, cdfid, id, lon_
   id = ncdf_varid(cdfid, 'lat')
   ncdf_varget, cdfid, id, lat_
   id = ncdf_varid(cdfid, 'lev')
   ncdf_varget, cdfid, id, lev
   id = ncdf_varid(cdfid, 'tau')
   ncdf_varget, cdfid, id, tau_
  ncdf_close, cdfid
  lon[*,i] = lon_
  lat[*,i] = lat_
  tau[*,i] = tau_
  endfor


; discard fill values (large numbers)
  a = where(tau gt 10)
  if(a[0] ne -1) then tau[a] = !values.f_nan

end

