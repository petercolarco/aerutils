  pro read_icapmme, yyyymmdd, varn, index, $
                    lon, lat, varo, rc=rc

  rc = 0
; file path for the BSC products
  filedir = '/misc/prc19/colarco/dust_2020/icap_mme/'
  filen   = filedir + 'icap_'+yyyymmdd+'00_MME_totaldustaod550.nc'

  cdfid = -1
  on_ioerror, getout
  cdfid = ncdf_open(filen)
  getout:
   if(cdfid eq -1) then begin
    print, filen+' not exist; return'
    rc = 1
    return
   endif

  id = ncdf_varid(cdfid,'lon')
  ncdf_varget, cdfid, id, lon

  id = ncdf_varid(cdfid,'lat')
  ncdf_varget, cdfid, id, lat

  nx = n_elements(lon)
  ny = n_elements(lat)

; Find a global variable
  id = ncdf_varid(cdfid,varn)
  if(id eq -1) then begin
   print, varn+' not exist on file; stop'
   ncdf_close, cdfid
   stop
  endif

  res = ncdf_varinq(cdfid,id)
  ndims = res.ndims
  case ndims of
   3: begin
      count = [nx,ny,1]
      offset = [0,0,index]
      end
   else: begin
      print, string(ndims)+' dimension read not support; stop'
      ncdf_close, cdfid
      stop
      end
  endcase
  ncdf_varget, cdfid, id, count=count, offset=offset, varo

  ncdf_close, cdfid

end
