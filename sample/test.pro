; Generate the aggregated MODIS files

  satid = 'MYD04'
  method = ['deep']
  nmethod = n_elements(method)
  outdir = './'
  odsdir = '/home/colarco/'

; Header information
  startdate = '20070626'
  stopdate  = '20070626'

  for imeth = 0, nmethod-1 do begin
    ods2grid_hourly, satid, startdate, stopdate, $
              odsdir = odsdir, $
              odsver = 'aero_tc8', collection='006', $
              outdir = outdir, $
              ntday = 24, resolution=['b','c','d'], $
              /shave, method=method[imeth]

  endfor

end
