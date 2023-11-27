; Colarco, December 2010
; Attempt to generalize this somewhat more
; This remains specific to MODIS
; Now you would call this method once each
; for land, ocean, or deep blue, specify 
; with the optional argument method.

; This will return values for aot, qa, and fine mode fraction,
; where for method != ocean the fine mode fraction is a fill
; value = 1

  pro odsread, filename, fail, $
               levOcn, latOcn, lonOcn, timeOcn, aotOcn, $      ; AOT
               levfOcn, latfOcn, lonfOcn, timefOcn, aotfOcn, $ ; Fine mode AOT
               levqOcn, latqOcn, lonqOcn, timeqOcn, aotqOcn, $ ; QA flags
               satId = satId, method=method

  satellite = 'MOD04'
  if(keyword_set(satId)) then satellite = satId
  if(not(keyword_set(method))) then method = 'ocean'

; select on kx based on satellite
  case satellite of
   'MOD04' : begin
             kxo = 301
             kxl = 302
             kxb = 310
             end
   'MYD04' : begin
             kxo = 311
             kxl = 312
             kxb = 320
             end
  endcase

; Select kx on method
  case method of
   'ocean' : begin
             kxwant = kxo
             ilam = 5
             end
   'land'  : begin
             kxwant = kxl
             ilam = 1
             end
   'deep'  : begin
             kxwant = kxb
             ilam = 1
             end
  endcase

  fail = 0

; if filename not exist, try to gunzip in place
  iunzip = 0
  files = file_search(filename[0])
  if(files[0] eq '') then begin
   files = file_search(filename[0]+'.gz')
   if(files[0] eq '') then begin
    print, 'Cannot find filename: '+filename
    fail = 32
    return
   endif else begin
    spawn, '/usr/bin/gunzip '+filename[0]+'.gz'
    iunzip = 1
   endelse
  endif

; If the filesize is 0 bytes, fail with return code
  spawn, '\ls -sh1 '+files[0], result
  result = strsplit(result,/extract)
  if(result[0] eq '0') then begin
   fail = 33
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
   on_ioerror, leave_odsread
   sdid = ncdf_open(filename[0])

;  Check if this is a "blank" ODS file
   id = ncdf_dimid(sdid,'nbatches')
   ncdf_diminq, sdid, id, dimname, dimval
   if(dimval eq 0) then begin
    fail = 2
    goto, getout
   endif
   
;  get the kt list from the file
   id = ncdf_varid(sdid,'kt_names')
   ncdf_varget, sdid, id, kt_names
   kt_names = string(kt_names)

;  get the kx list from the file
   id = ncdf_varid(sdid,'kx_names')
   ncdf_varget, sdid, id, kx_names
   kx_names = string(kx_names)
  endif

  odsvarread, sdid, 'lat', lat, netcdf=do_netcdf
  odsvarread, sdid, 'lon', lon, netcdf=do_netcdf
  odsvarread, sdid, 'lev', lev, netcdf=do_netcdf
  odsvarread, sdid, 'time', time, netcdf=do_netcdf
  odsvarread, sdid, 'kt', kt, netcdf=do_netcdf
  odsvarread, sdid, 'kx', kx, netcdf=do_netcdf
  odsvarread, sdid, 'obs', obs, netcdf=do_netcdf

; variables wanted
  fail = 0

; Get variables
; MODIS AOT
  ikt = where(strcompress(kt_names,/rem) eq 'AerosolOpticalDepth')
;  ikt = where(strcompress(kt_names,/rem) eq 'Reflectance')
  ikt = ikt + 1
  nkt = where(kt eq ikt[0] and kx eq kxwant)
  if(nkt[0] eq -1) then begin
   fail = 1
   goto, getout
  endif
  levOcn = lev[nkt]
  latOcn = lat[nkt]
  lonOcn = lon[nkt]
  timeOcn = time[nkt]
  aotOcn = obs[nkt]

; MODIS QA
  ikt = where(strcompress(kt_names,/rem) eq 'QualityAssuranceFlag')
  ikt = ikt + 1
  nkt = where(kt eq ikt[0] and kx eq kxwant)
; Deep Blue writes a defined but 0 value QA for points not retrieved
; in AOT; fix that
  if(method eq 'deep') then nkt = where(kt eq ikt[0] and kx eq kxwant and obs gt 0)
  if(nkt[0] eq -1) then begin
   fail = 2
   goto, getout
  endif
  levqOcn = lev[nkt]
  latqOcn = lat[nkt]
  lonqOcn = lon[nkt]
  timeqOcn = time[nkt]
  aotqOcn = obs[nkt]

; Do some QA checking here
  nptsqa = n_elements(levqOcn)
  nptsa  = n_elements(levOcn)
  olevOcn = levOcn[uniq(levOcn,sort(levOcn))]
  nlamOcn = n_elements(olevOcn)
  if(float(nptsa/nlamocn) ne float(nptsqa)) then fail = 4
  if(fail) then goto, getout

; MODIS Fine Mode Ratio Small (only over Ocean)
  if(method eq 'ocean') then begin
   ikt = where(strcompress(kt_names,/rem) eq 'AerosolOpticalDepthRatio(Small/Total)')
   ikt = ikt + 1
   nkt = where(kt eq ikt[0] and kx eq kxwant)
   levfOcn = lev[nkt]
   latfOcn = lat[nkt]
   lonfOcn = lon[nkt]
   timefOcn = time[nkt]
   aotfOcn = obs[nkt]
  endif else begin
;  else dummy up an array of fine mode ratio
   levfOcn  = levqOcn
   latfOcn  = latqOcn
   lonfOcn  = lonqOcn
   timefOcn = timeqOcn
   aotfOcn  = aotqOcn
   aotfOcn[*] = 1.
  endelse
  nptsfn = n_elements(levfOcn)
  if(nptsqa ne nptsfn) then fail = 8
  if(fail) then goto, getout

; Screen ocean points to throw out (i) negative AOT values
; Could screen here as well for fine mode aot lt 0
  aotOcn = reform(aotOcn,nLamOcn,nptsqa)
  levOcn = reform(levOcn,nLamOcn,nptsqa)
  lonOcn = reform(lonOcn,nLamOcn,nptsqa)
  latOcn = reform(latOcn,nLamOcn,nptsqa)
  timeOcn = reform(timeOcn,nLamOcn,nptsqa)
  a = where(aotOcn[ilam,*] ge 0. and $
            aotOcn[ilam,*] lt 100. and $
            aotqOcn lt 1e14 )
  na = n_elements(a)
  if(a[0] ne -1) then begin
  aotOcn = reform(aotOcn[*,a],na*nlamOcn)
  levOcn = reform(levOcn[*,a],na*nlamOcn)
  latOcn = reform(latOcn[*,a],na*nlamOcn)
  lonOcn = reform(lonOcn[*,a],na*nlamOcn)
  timeOcn = reform(timeOcn[*,a],na*nlamOcn)
  levfOcn = levfOcn[a]
  lonfOcn = lonfOcn[a]
  latfOcn = latfOcn[a]
  aotfOcn = aotfOcn[a]
  timefOcn = timefOcn[a]
  levqOcn = levqOcn[a]
  lonqOcn = lonqOcn[a]
  latqOcn = latqOcn[a]
  aotqOcn = aotqOcn[a]
  timeqOcn = timeqOcn[a]
  end

goto, getout

; only executed on a failed read
leave_odsread:
  fail = 16

getout:
  if(not(do_netcdf)) then hdf_sd_end, sdid else ncdf_close, sdid
  return

end
