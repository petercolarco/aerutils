; Get the daily aeronet obs and find the ones valid in
; August/September 2013 and plot on a map and make a list

  spawn, 'echo $AERONETDIR', headDir
  aerPath = headDir+'LEV30/'
  lambdabase = '500'
  yyyy = 2013

; Get the sites list
  read_aeronet_locs, location_, lat_, lon_, elevation
goto, jump
; Look for sites in US
  icts = 0
  for iloc = 0, n_elements(location_)-1 do begin
print, iloc
   if(lat_[iloc] lt 50 and lat_[iloc] gt 20 and $
      lon_[iloc] gt -125 and lon_[iloc] lt -60) then begin
     angstromaeronetIn = 1.
     angstrommodel = 1.
     read_aeronet2nc, aerPath, location_[iloc], lambdabase, strpad(yyyy,1000), $
                      aotaeronet, dateaeronet, $
                      angpair=1, angstrom=angstromaeronetIn, $
                      naot=naotaeronet, /hourly
     a = where(dateaeronet gt yyyy*1000000L+081800L and dateaeronet lt yyyy*1000000L+082100L)
     b = where(aotaeronet[a] gt 0)
     if(b[0] gt -1) then begin
      if(icts eq 0) then begin
       lat = lat_[iloc]
       lon = lon_[iloc]
       location = location_[iloc] 
      endif else begin
       lat = [lat,lat_[iloc]]
       lon = [lon,lon_[iloc]]
       location = [location,location_[iloc]]
      endelse
      icts = icts+1
     endif
   endif
  endfor

  set_plot, 'x'
  map_set, /cont, /hires, /usa, limit=[20,-130,55,-60]
  plots, lon, lat, psym=4

jump:

; Get a couple of sites
  angTM = 1.
  read_aeronet2nc, aerPath, 'Table_Mountain', lambdabase, strpad(yyyy,1000), $
                   aotTM, dateaeronet, $
                   angpair=1, angstrom=angTM, $
                   naot=naotaeronet, /hourly
  read_aeronet_inversions2nc, aerPath, 'Table_Mountain', lambdabase, strpad(yyyy,1000), $
                                  tauext_, tauabsTM, date_, /hourly
  angGSFC = 1.
  read_aeronet2nc, aerPath, 'GSFC', lambdabase, strpad(yyyy,1000), $
                   aotGSFC, dateaeronet, $
                   angpair=1, angstrom=angGSFC, $
                   naot=naotaeronet, /hourly
  read_aeronet_inversions2nc, aerPath, 'GSFC', lambdabase, strpad(yyyy,1000), $
                                  tauext_, tauabsGSFC, date_, /hourly


  a = where(dateaeronet ge yyyy*1000000L+081400L and dateaeronet le yyyy*1000000L+082200L)
  c = where(aotTM lt 0)
  d = where(aotGSFC lt 0)
  aotTM[c] = !values.f_nan
  angTM[c] = !values.f_nan
  aotGSFC[d] = !values.f_nan
  angGSFC[d] = !values.f_nan

  plot, indgen(2), /nodata, $
   xrange=[0,192], yrange=[0,1.5]
  oplot, aotTM[a], thick=4
  oplot, aotGSFC[a], thick=4, lin=2

; Try to get the MERRA2 aeronet samples
  file = '/misc/prc13/MERRA2/tavg1_2d_aer_Nx/aeronet/merra2_aeronet_aop_ext500nm.201308.nc4'
  cdfid = ncdf_open(file)
  id = ncdf_varid(cdfid,'stnName')
  ncdf_varget, cdfid, id, stnname
  stnName = strcompress(string(stnName),/rem)
  ext = fltarr(72,248,2)
  ssa = fltarr(72,248,2)
  h   = fltarr(72,248,2)
  delp = fltarr(72,248,2)
  rhoa = fltarr(72,248,2)

  id = ncdf_varid(cdfid,'ext')
  ncdf_varget, cdfid, id, ext_
  id = ncdf_varid(cdfid,'ssa')
  ncdf_varget, cdfid, id, ssa_
  id = ncdf_varid(cdfid,'H')
  ncdf_varget, cdfid, id, h_
  id = ncdf_varid(cdfid,'DELP')
  ncdf_varget, cdfid, id, delp_
  id = ncdf_varid(cdfid,'AIRDENS')
  ncdf_varget, cdfid, id, rhoa_
  ncdf_close, cdfid


  i = where(stnname eq 'Table_Mountain')
  k = i[0]
  ext[*,*,0] = ext_[*,*,k]
  ssa[*,*,0] = ssa_[*,*,k]
  h[*,*,0] = h_[*,*,k]
  delp[*,*,0] = delp_[*,*,k]
  rhoa[*,*,0] = rhoa_[*,*,k]

  j = where(stnname eq 'GSFC')
  k = j[0]
  ext[*,*,1] = ext_[*,*,k]
  ssa[*,*,1] = ssa_[*,*,k]
  h[*,*,1] = h_[*,*,k]
  delp[*,*,1] = delp_[*,*,k]
  rhoa[*,*,1] = rhoa_[*,*,k]

; Make a delz
  delz = delp/9.81/rhoa/1000.  ; km
  tauext = total(ext*delz,1)
  tauabs = total(ext*(1-ssa)*delz,1)

  x = findgen(248)*3.-13*24
  oplot, x, tauext[*,0]
  oplot, x, tauext[*,1]


end
