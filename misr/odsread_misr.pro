; Colarco
; Read an ODS file and look for MISR relevant values
  pro odsread_misr, filename, fail, $
                    levOcn, latOcn, lonOcn, timeOcn, aotOcn

  kxo = 313

  fail = 0

; if filename not exist, try to gunzip in place
  iunzip = 0
  files = file_search(filename)
  if(files[0] eq '') then begin
   files = file_search(filename+'.gz')
   if(files[0] eq '') then begin
    print, 'Cannot find filename: '+filename
    fail = 32
    return
   endif else begin
    spawn, '/usr/bin/gunzip '+filename+'.gz'
    iunzip = 1
   endelse
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

; MODIS Ocean AOT
  ikt = where(strcompress(kt_names,/rem) eq 'AerosolOpticalDepth')
  ikt = ikt + 1
  nkt = where(kt eq ikt[0] and kx eq kxo)
  if(nkt[0] eq -1) then begin
   fail = 1
   goto, getout
  endif
  levOcn = lev[nkt]
  latOcn = lat[nkt]
  lonOcn = lon[nkt]
  timeOcn = time[nkt]
  aotOcn = obs[nkt]

; Do a quick check on elements
  nptsa  = n_elements(levOcn)
  olevOcn = levOcn[uniq(levOcn,sort(levOcn))]
  nlamOcn = n_elements(olevOcn)

  if(not(do_netcdf)) then hdf_sd_end, sdid else ncdf_close, sdid
  return

getout:
  if(fail) then begin
   if(not(do_netcdf)) then hdf_sd_end, sdid else ncdf_close, sdid
   return
  endif

; only executed on a failed read
leave_odsread:
  fail = 16

end
