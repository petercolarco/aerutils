; Generate the aggregated MODIS files

; Resolutions
  resolution = ['b','c','d']
  satid = 'MOD04'
  method = ['ocean','land']
  outdir = '/science/modis/data/Level3/'+satid+'/'+resolution+'/GRITAS/'

; QAWT styles
  qatype  = ['qawt','qawt3']

  nres = n_elements(resolution)
  nmethod = n_elements(method)
  nqatype = n_elements(qatype)

; Header information
  startdate = '20130101'
  stopdate  = '20131231'


  for ires = 0, nres-1 do begin
   for iqa = 0, nqatype-1 do begin
    for imeth = 0, nmethod-1 do begin
;   Don't do deepblue for MOD04 after 2005
    ods2grid, satid, startdate, stopdate, $
              odsdir = '/science/modis/data/Level3/'+satid+'/ODS_03/', $
              odsver = 'aero_tc8', $
              outdir = outdir[ires], $
              synopticoffset=90, ntday = 8, resolution = resolution[ires], $
              qatype = qatype[iqa], /shave, method=method[imeth]
    endfor
   endfor
  endfor

end
