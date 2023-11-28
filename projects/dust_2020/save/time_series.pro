; Make a time series at Puerto Rico spanning June 15 - July 15
; At Puerto Rico; do this for the three models I have...

; Target lat lon (Cape San Juna Puerto Rico)
  latwant = 18.4
  lonwant = -65.6

; Read the BSC files
  i = 0
  yyyymmddhh = '2020061500'
  yyyymmdd = strmid(yyyymmddhh,0,8)

  while(long(yyyymmdd) le 20200715L) do begin
   print, yyyymmdd
   index = 4
   read_bsc, yyyymmdd, 'aod_dust', index, lon, lat, aod
   if(i eq 0) then begin
    ix = interpol(indgen(n_elements(lon)),lon,lonwant)
    iy = interpol(indgen(n_elements(lat)),lat,latwant)
    bsc_aod = interpolate(aod,ix,iy)
    i = 1
   endif else begin
    bsc_aod = [bsc_aod,interpolate(aod,ix,iy)]
   endelse
   yyyymmddhh = incstrdate(yyyymmddhh,24)
   yyyymmdd = strmid(yyyymmddhh,0,8)
  endwhile

; Read the FP files
  i = 0
  yyyymmddhh = '2020061500'
  yyyymmdd = strmid(yyyymmddhh,0,8)

  while(long(yyyymmdd) le 20200715L) do begin
   print, yyyymmdd
   index = 24
   read_fp, yyyymmdd, 'duexttau', index, lon, lat, aod
   if(i eq 0) then begin
    ix = interpol(indgen(n_elements(lon)),lon,lonwant)
    iy = interpol(indgen(n_elements(lat)),lat,latwant)
    fp_aod = interpolate(aod,ix,iy)
    i = 1
   endif else begin
    fp_aod = [fp_aod,interpolate(aod,ix,iy)]
   endelse
   yyyymmddhh = incstrdate(yyyymmddhh,24)
   yyyymmdd = strmid(yyyymmddhh,0,8)
  endwhile

; Read the ICAP files
  i = 0
  yyyymmddhh = '2020061500'
  yyyymmdd = strmid(yyyymmddhh,0,8)

  while(long(yyyymmdd) le 20200715L) do begin
   print, yyyymmdd
   index = 4
   rc = 0
   read_icapmme, yyyymmdd, 'dust_aod_mean', index, lon, lat, aod, rc=rc
   if(i eq 0) then begin
    if(rc eq 1) then stop
    ix = interpol(indgen(n_elements(lon)),lon,lonwant)
    iy = interpol(indgen(n_elements(lat)),lat,latwant)
    icap_aod = interpolate(aod,ix,iy)
    i = 1
   endif else begin
    if(rc eq 0) then icap_aod = [icap_aod,interpolate(aod,ix,iy)]
    if(rc eq 1) then icap_aod = [icap_aod,!values.f_nan]
   endelse
   yyyymmddhh = incstrdate(yyyymmddhh,24)
   yyyymmdd = strmid(yyyymmddhh,0,8)
  endwhile

end

