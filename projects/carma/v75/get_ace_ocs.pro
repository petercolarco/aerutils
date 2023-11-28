; Colarco, Nove,ber 2018
; Get the annual, zonal mean ACE OCS in pptv

  pro get_ace_ocs, ocs, lat, lev

  filename = '/misc/prc10/ACE_OCS/ACE_3monthly_zm_OCS_hpa_lat_DJF_all.nc'
  cdfid = ncdf_open(filename)
  id = ncdf_varid(cdfid,'lat')
  ncdf_varget, cdfid, id, lat
  id = ncdf_varid(cdfid,'plev')
  ncdf_varget, cdfid, id, lev
  id = ncdf_varid(cdfid,'OCS')
  ncdf_varget, cdfid, id, ocs_djf
  ocs_djf = transpose(ocs_djf)*1e12  ; pptv
  ncdf_close, cdfid

  filename = '/misc/prc10/ACE_OCS/ACE_3monthly_zm_OCS_hpa_lat_JJA_all.nc'
  cdfid = ncdf_open(filename)
  id = ncdf_varid(cdfid,'OCS')
  ncdf_varget, cdfid, id, ocs_jja
  ocs_jja = transpose(ocs_jja)*1e12  ; pptv
  ncdf_close, cdfid

  filename = '/misc/prc10/ACE_OCS/ACE_3monthly_zm_OCS_hpa_lat_MAM_all.nc'
  cdfid = ncdf_open(filename)
  id = ncdf_varid(cdfid,'OCS')
  ncdf_varget, cdfid, id, ocs_mam
  ocs_mam = transpose(ocs_mam)*1e12  ; pptv
  ncdf_close, cdfid

  filename = '/misc/prc10/ACE_OCS/ACE_3monthly_zm_OCS_hpa_lat_SON_all.nc'
  cdfid = ncdf_open(filename)
  id = ncdf_varid(cdfid,'OCS')
  ncdf_varget, cdfid, id, ocs_son
  ocs_son = transpose(ocs_son)*1e12  ; pptv
  ncdf_close, cdfid

  ocs = [ocs_jja,ocs_djf,ocs_son,ocs_mam]
  ocs = reform(ocs,36,4,48)
  ocs = transpose(ocs,[0,2,1])
  ocs = mean(ocs,dim=3,/nan)
  ocs = reverse(ocs,2)
  lev = reverse(lev)

end
