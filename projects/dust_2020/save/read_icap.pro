  pro read_icap, yyyymmdd, varn, index, imem, $
                    lon, lat, varo, rc=rc

; individual ICAP member models
; 0 - CAMS
; 1 - GEOS
; 2 - NAAPS
; 3 - MASINGAR
; 4 - NGAC
; 5 - MONARCH
; 6 - UKMO

  rc = 0
; file path for the BSC products
  yyyymm = strmid(yyyymmdd,0,6)
  filedir = '/misc/prc19/colarco/dust_2020/icap/'
  filen   = filedir + yyyymm + '/icap_'+yyyymmdd+'00_aod.nc'

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
   4: begin
      count = [nx,ny,1,1]
      offset = [0,0,imem,index]
      end
   else: begin
      print, string(ndims)+' dimension read not support; stop'
      ncdf_close, cdfid
      stop
      end
  endcase
  ncdf_varget, cdfid, id, count=count, offset=offset, varo

; if missing, go back one day and get the 24 hour forecast
  a = where(varo lt -9990.)
  if(a[0] ne -1) then begin
   yyyymmddhh_ = incstrdate(yyyymmdd+'00',-24)
   yyyymmdd_   = strmid(yyyymmddhh_,0,8)
   print, 'rewind for forecast to ', yyyymmdd_, imem
   read_icap, yyyymmdd_, varn, 4, imem, lon, lat, varo, rc=rc_
  endif

  a = where(varo lt -9990.)
  if(a[0] ne -1) then varo[a] = !values.f_nan

  ncdf_close, cdfid

end
