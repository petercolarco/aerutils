  pro read_bsc, yyyymmdd, varn, index, $
                lon, lat, varo

; file path for the BSC products
  filedir = '/misc/prc19/colarco/dust_2020/bsc/icap_dust_June-July2020/'
  filen   = filedir + 'dust_var_'+yyyymmdd+'00_ncf4.nc'

  lm = 48

  cdfid = ncdf_open(filen)
  if(cdfid eq -1) then begin
    print, filen+' not exist; stop'
    stop
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
   4: begin
      count = [nx,ny,lm,1]
      offset = [0,0,0,index]
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
