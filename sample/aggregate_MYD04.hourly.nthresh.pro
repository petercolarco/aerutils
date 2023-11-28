; Generate the aggregated MODIS files

  satid = 'MYD04'
  method = ['ocean','land']
  nmethod = n_elements(method)
  outdir = '/misc/prc15/colarco/modis/data/Level3/'+satid+'/hourly/'
  odsdir = '/science/modis/data/Level3/'+satid+'/ODS_03/'

; Header information
  startdate = '20080101'
  stopdate  = '20090101'

  for imeth = 0, nmethod-1 do begin
    ods2grid_hourly, satid, startdate, stopdate, $
              odsdir = odsdir, $
              nthresh = 3, $
              odsver = 'aero_tc8', collection='006', $
              outdir = outdir, $
              ntday = 24, resolution=['d'], $
              /shave, method=method[imeth]

  endfor

end
