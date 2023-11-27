; Colarco, June 2010
; Read a variable (varname) from an already opened
; ODS file (sdid); return the value (varval) manipulated
; by attributes.

; Default behavior is use hdf interface for older
; ODS files; if switch netcdf is on use netcdf interface

  pro odsvarread, sdid, varname, varval, netcdf=netcdf, undef=undef
  !quiet=1L

   if(not(keyword_set(undef)))  then undef = -1.
   if(not(keyword_set(netcdf))) then netcdf = 0

;  Use HDF interface
   if(not(netcdf)) then begin

;   read variable
    idx = hdf_sd_nametoindex(sdid,varname)
    id  = hdf_sd_select(sdid,idx)
    hdf_sd_getdata, id, varval
    varval = float(varval)

;   add offset
    add_offset = 0.
    offsetId = hdf_sd_attrfind(id,'add_offset')
    if(offsetId ne -1) then begin
     hdf_sd_attrinfo, id, offsetId, data=add_offset
    endif
    varval = varval + add_offset[0]

;   scale variable
    scale_factor = 1.
    scaleId = hdf_sd_attrfind(id,'scale_factor')
    if(scaleId ne -1) then begin
     hdf_sd_attrinfo, id, scaleId, data=scale_factor
    endif
    varval = varval*scale_factor[0]

    valid_range = [-1e15, 1e15]
    rangeId = hdf_sd_attrfind(id,'valid_range')
    if(rangeId ne -1) then begin
     hdf_sd_attrinfo, id, rangeId, data=valid_range
    endif
    a = where(varval lt valid_range[0] or varval gt valid_range[1])
    if(a[0] ne -1) then varval[a] = 1e15

    undefId = hdf_sd_attrfind(id,'missing_value')
    if(undefId ne -1) then begin
     hdf_sd_attrinfo, id, undefId, data=undef
    endif

;  Or else use netcdf interface
   endif else begin

;   read variable
    id = ncdf_varid(sdid,varname)
    ncdf_varget, sdid, id, varval
    varval = float(varval)

;   handle attributes
    add_offset = 0.
    scale_factor = 1.
    valid_range = [-1e15,1e15]
    varinq = ncdf_varinq(sdid,id)
    natts = varinq.natts
    nadd_offset = 'add_offset'
    nscale_factor = 'scale_factor'
    nvalid_range = 'valid_range'
    nmissing_value = 'missing_value'
    if(natts gt 0) then begin
     for iatt = 0, natts-1 do begin
      attname = ncdf_attname(sdid,id,iatt)
      if(attname eq nadd_offset) then ncdf_attget, sdid, id, attname, add_offset
      if(attname eq nscale_factor) then ncdf_attget, sdid, id, attname, scale_factor
      if(attname eq nvalid_range) then ncdf_attget, sdid, id, attname, valid_range
      if(attname eq nmissing_value) then ncdf_attget, sdid, id, attname, undef
     endfor
    endif
    varval = varval + add_offset[0]
    varval = varval*scale_factor[0]
    a = where(varval lt valid_range[0] or varval gt valid_range[1])
    if(a[0] ne -1) then varval[a] = 1e15

   endelse

end

