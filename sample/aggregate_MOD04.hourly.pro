; Generate the aggregated MODIS files

  satid = 'MOD04'
  method = ['ocean','land','deep']
  nmethod = n_elements(method)
  outdir = '/science/modis/data/Level3/'+satid+'/hourly/'
  odsdir = '/science/modis/data/Level3/'+satid+'/ODS_03/'

; Header information
  startdate = '20160101'
  stopdate  = '20171201'

  for imeth = 0, nmethod-1 do begin
    ods2grid_hourly, satid, startdate, stopdate, $
              odsdir = odsdir, $
              odsver = 'aero_tc8', collection='006', $
              outdir = outdir, $
              ntday = 24, resolution=['b','c','d'], $
              /shave, method=method[imeth]

  endfor

end
