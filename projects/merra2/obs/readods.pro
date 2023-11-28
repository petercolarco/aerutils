; Colarco, April 2011
; Generalized ODS reader.
; User provides kx (sensor) and kt (variable)
; and is returned lat, lon, lev, time, and obs.
; Results are screened for undef, and an error
; message is returned if kx or kt are unmatched.

  pro readods, filename, $
               kxwant, ktwant, $
               lata, lona, leva, timea, obsa, $
               list = list, rc = rc, ks=ksa, $
               ktqa = ktqa, qathresh = qathresh, obsq = obsq

  rc = 0

; if filename does not exist, fail with return code
  files = file_search(filename[0])
  if(files[0] eq '') then begin
   rc = 1
   return
  endif

; If filesize is 0 bytes, fail with return code
  spawn, '\ls -sh1 '+filename[0], result
  result = strsplit(result,/extract)
  if(result[0] eq '0') then begin
   rc = 1
   return
  endif

  do_netcdf = 0
  on_ioerror, try_netcdf
  sdid = hdf_sd_start(filename[0])

; get the kt list from the file
  idx = hdf_sd_nametoindex(sdid,'kt_names')
  id = hdf_sd_select(sdid,idx)
  hdf_sd_getdata, id, kt_names

; get the kx list from the file
  idx = hdf_sd_nametoindex(sdid,'kx_names')
  id = hdf_sd_select(sdid,idx)
  hdf_sd_getdata, id, kx_names

; Try netcdf
  if(do_netcdf) then begin
try_netcdf:
   do_netcdf = 1
   on_ioerror, leave_readods
   sdid = ncdf_open(filename[0])

;  get the kt list from the file
   id = ncdf_varid(sdid,'kt_names')
   ncdf_varget, sdid, id, kt_names
   kt_names = string(kt_names)

;  get the kx list from the file
   id = ncdf_varid(sdid,'kx_names')
   ncdf_varget, sdid, id, kx_names
   kx_names = string(kx_names)

  endif

  odsvarread, sdid, 'kt', kt, netcdf=do_netcdf
  odsvarread, sdid, 'kx', kx, netcdf=do_netcdf
  odsvarread, sdid, 'ks', ks, netcdf=do_netcdf

; If a "listing" is requested, then print
; kx and kt and quit
  if(keyword_set(list)) then begin
;  Possibly 200 kts
   nkt = min([200,n_elements(kt_names)])
   for ikt = 1, nkt do begin
    a = where(kt eq ikt and kt_names[ikt-1] ne '')
    if(a[0] ne -1) then print, ikt, ' ', strcompress(kt_names[ikt-1])
   endfor

;  Possibly 600 kxs
   nkx = min([600,n_elements(kx_names)])
   for ikx = 1, nkx do begin
    a = where(kx eq ikx and kx_names[ikx-1] ne '')
    if(a[0] ne -1) then print, ikx, ' ', strcompress(kx_names[ikx-1])
   endfor

   goto, getout
  endif

  odsvarread, sdid, 'lat', lat, netcdf=do_netcdf
  odsvarread, sdid, 'lon', lon, netcdf=do_netcdf
  odsvarread, sdid, 'lev', lev, netcdf=do_netcdf
  odsvarread, sdid, 'time', time, netcdf=do_netcdf
  undef = 1.e15
  odsvarread, sdid, 'obs', obs, netcdf=do_netcdf, undef=undef
  a = where(kx eq kxwant and kt eq ktwant)
  if(a[0] eq -1) then begin
   rc = 4
   goto, getout
  endif

; Filter results for wanted kx/kt (aerosol)
  lata  = lat[a]
  lona  = lon[a]
  leva  = lev[a]
  timea = time[a]
  obsa  = obs[a]
  ksa   = ks[a]

; If you requested QA filtering, then retain only those points
  if(keyword_set(ktqa)) then begin
   a = where(kx eq kxwant and kt eq ktqa)
   latq  = lat[a]
   lonq  = lon[a]
   levq  = lev[a]
   timeq = time[a]
   obsq  = obs[a]
   ksq   = ks[a]
;  For QA filtering we only bother to retain values on 550 nm channel
   a = where(leva eq 550.)
   lata  = lata[a]
   lona  = lona[a]
   leva  = leva[a]
   timea = timea[a]
   obsa  = obsa[a]
   ksa   = ksa[a]
;  If number of obs left ne number in qa then error
   if(n_elements(obsa) ne n_elements(obsq)) then begin
    rc = 8
    goto, getout
   endif
   if(keyword_set(qathresh)) then begin
    a = where(obsq ge qathresh)
    if(a[0] eq -1) then begin
     rc = 16
     goto, getout
    endif
    lata  = lata[a]
    lona  = lona[a]
    leva  = leva[a]
    timea = timea[a]
    obsa  = obsa[a]
    obsq  = obsq[a]
    ksa   = ksa[a]
   endif
  endif   

; Filter any remaining undef
  a = where(obsa ne undef[0])
  if(a[0] ne -1) then begin
   lata  = lata[a]
   lona  = lona[a]
   leva  = leva[a]
   timea = timea[a]
   obsa  = obsa[a]
;   obsq  = obsq[a]
   ksa   = ksa[a]
endif

; Check that finally all the variables are the same length
  if(n_elements(lata) ne (n_elements(lona) or $
                          n_elements(leva) or $
                          n_elements(timea) or $
                          n_elements(obsa) or $
;                          n_elements(obsq) or $
                          n_elements(ksa) ) ) then rc = 8

  goto, getout

leave_readods:
  rc = 2

getout:
  if(not(do_netcdf)) then hdf_sd_end, sdid else ncdf_close, sdid
  return


end
