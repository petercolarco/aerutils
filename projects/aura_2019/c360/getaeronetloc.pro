  pro getaeronetloc, plon, plat

  cdfid = ncdf_open('c180R_v202_aura_gsfun.omaeruv.aeronet.2016.nc')
  id = ncdf_varid(cdfid,'stnName')
  ncdf_varget, cdfid, id, stnname
  stnname = strcompress(string(stnname),/rem)
  id = ncdf_varid(cdfid,'stnLon')
  ncdf_varget, cdfid, id, lon
  id = ncdf_varid(cdfid,'stnLat')
  ncdf_varget, cdfid, id, lat
  ncdf_close, cdfid

  i = 0
  for j = 0, n_elements(stnname) - 1 do begin
   stnWant = stnname[j]
   getaeronetaod, stnWant, 'AOD_340nm', time, aodo
   a = where(finite(aodo) eq 1)
   if(n_elements(a) lt 4) then continue
   print, stnWant
   if(i eq 0) then begin
    plon = lon[j]
    plat = lat[j]
    i = 1
   endif else begin
    plon = [plon,lon[j]]
    plat = [plat,lat[j]]
   endelse
  endfor

end
