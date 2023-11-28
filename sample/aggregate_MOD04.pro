; Generate the aggregated MODIS files

  satid = 'MOD04'
  method = ['ocean','land']
  nmethod = n_elements(method)
  outdir = '/misc/prc10/MODIS/Level3/'+satid+'/'
;  odsdir = '/misc/prc10/MODIS/Level3/'+satid+'/ODS_03/'
  odsdir = '/fvol/calculon2/MODIS/Level2/MOD04/ODS/'

; Header information
  startdate = '20000224'
  stopdate  = '20111231'

  for imeth = 0, nmethod-1 do begin
    ods2grid, satid, startdate, stopdate, $
              odsdir = odsdir, $
              odsver = 'aero_tc8', $
              outdir = outdir, $
              ntday = 1, $
              synopticoffset=720, $
              /shave, method=method[imeth], /inverse
  endfor

end
