; Colarco, January 2007
; ga_getvar_read
; netcdf/hdf file dumper that returns all variables
; contained in the pointed to file

  pro ga_getvar_read, file, vars, lon, lat, lev, time, time0, varval, sum=sum

  kkk = 0
  on_ioerror, try_hdf
  cdfid = ncdf_open(file)

;  Get the longitudes on the file
   id = ncdf_varid(cdfid,'longitude')
   ncdf_varget, cdfid, id, lon

;  Get the latitudes on the file
   id = ncdf_varid(cdfid,'latitude')
   ncdf_varget, cdfid, id, lat

;  Get the levels on the file
   lev = 1000.   ; default psfc for a 2d file (in case levels not present)
   id = ncdf_varid(cdfid,'levels')
   if(id ne -1) then begin
    ncdf_varget, cdfid, id, lev
   endif

;  Get the time on the file
   id = ncdf_varid(cdfid,'time')
   ncdf_varget, cdfid, id, time
   ncdf_attget, cdfid, id, 'units', time0

;  Now get the variables on the file
;  We discount the possibility of simulataneously requesting
;  2D and 3D variables; probably breaks
   nvars = n_elements(vars)
   nx = n_elements(lon)
   ny = n_elements(lat)
   nz = n_elements(lev)
   nt = n_elements(time)
   varval = fltarr(nx,ny,nz,nt,nvars)
   for ivar = 0, nvars-1 do begin
    id = ncdf_varid(cdfid,vars[ivar])
    ncdf_varget, cdfid, id, varval_
    varval_ = reform(varval_,nx,ny,nz,nt)
    varval[*,*,*,*,ivar] = varval_
   endfor
   ncdf_close, cdfid

  kkk =1
  if(kkk eq 0) then begin
try_hdf:
   cdfid = hdf_sd_start(file)

;  Get the longitudes on the file
   idx = hdf_sd_nametoindex(cdfid,'longitude')
   id  = hdf_sd_select(cdfid,idx)
   hdf_sd_getdata, id, lon

;  Get the latitudes on the file
   idx = hdf_sd_nametoindex(cdfid,'latitude')
   id  = hdf_sd_select(cdfid,idx)
   hdf_sd_getdata, id, lat

;  Get the levels on the file
   lev = 1000.   ; default psfc for a 2d file (in case levels not present)
   idx = hdf_sd_nametoindex(cdfid,'levels')
   if(idx ne -1) then begin
    id  = hdf_sd_select(cdfid,idx)
    hdf_sd_getdata, id, lev
   endif

;  Get the time on the file
   idx = hdf_sd_nametoindex(cdfid,'time')
   id  = hdf_sd_select(cdfid,idx)
   hdf_sd_getdata, id, time
   ida = hdf_sd_attrfind(id,'units')
   hdf_sd_attrinfo, id, ida, data=time0

;  Now get the variables on the file
;  We discount the possibility of simulataneously requesting
;  2D and 3D variables; probably breaks
   nvars = n_elements(vars)
   nx = n_elements(lon)
   ny = n_elements(lat)
   nz = n_elements(lev)
   nt = n_elements(time)
   varval = fltarr(nx,ny,nz,nt,nvars)
   for ivar = 0, nvars-1 do begin
    idx = hdf_sd_nametoindex(cdfid,vars[ivar])
    id  = hdf_sd_select(cdfid,idx)
    hdf_sd_getdata, id, varval_
    varval_ = reform(varval_,nx,ny,nz,nt)
    varval[*,*,*,*,ivar] = varval_
   endfor
   hdf_sd_end, cdfid
  endif

; Handle request to integrate the variables
; Only works for multiple variables
  sum_ = 0
  if(keyword_set(sum)) then sum_ = sum
  if(sum_ and nvars gt 1) then begin
   varval = total(varval,5)
  endif

; Get rid of extra dimensions
  varval = reform(varval)

end
