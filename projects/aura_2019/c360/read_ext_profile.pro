; ----
  pro read_ext_profile, expid, date, ext, ssa, rc, bc=bc, rh20=rh20, rh80=rh80

  if(keyword_set(bc)) then begin
    file = expid+'.'+date+'.ext.rh40.bc.nc'
   endif else begin
    file = expid+'.'+date+'.ext.rh40.nc'
   endelse
   if(keyword_set(rh20)) then file = expid+'.'+date+'.ext.rh20.nc'
   if(keyword_set(rh80)) then file = expid+'.'+date+'.ext.rh80.nc'

  rc = file_test(file)
  if(rc) then begin
   cdfid = ncdf_open(file)
   id = ncdf_varid(cdfid,'ssa')
   ncdf_varget, cdfid, id, ssa
   id = ncdf_varid(cdfid,'ext')
   ncdf_varget, cdfid, id, ext
   ncdf_close, cdfid
  endif else begin
   ssa = 0
   ext = 0
  endelse

  end

