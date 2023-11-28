; Generate the aggregated MODIS files

; Resolutions
  resolution = ['b','d']
  nres = n_elements(resolution)
  satid = 'MOD04'
  method = ['ocean','land']
  nres = n_elements(resolution)
  nmethod = n_elements(method)
  outdir = './'+satid+'/'+resolution+'/GRITAS/'

; QAWT styles
  qatype  = ['qawt','qawt3']
  nqatype = n_elements(qatype)

; Header information
  startdate = '20081231'
  stopdate  = '20100101'


  for ires = 0, nres-1 do begin
   for imeth = 0, nmethod-1 do begin

    deepblue = 0
    ods2grid, satid, startdate, stopdate, $
              odsdir = '/misc/prc10/MODIS/Level3/'+satid+'/ODS_03/', $
              odsver = 'aero_tc8', $
              outdir = outdir[ires], $
              synopticoffset=540, ntday = 1, resolution = resolution[ires], $
              qatype = qatype[imeth], /shave, method=method[imeth]
   endfor
  endfor

end
