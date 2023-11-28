; Generate the aggregated MODIS files

  satid = 'MYD04'
  method = ['ocean','land']
  nmethod = n_elements(method)
  outdir = '/science/modis/data/Level3/'+satid+'/'
  odsdir = '/science/modis/data/Level3/'+satid+'/ODS_03/'

; Header information
  startdate = '20030101'
  stopdate  = '20121231'

  for imeth = 0, nmethod-1 do begin
    ods2grid, satid, startdate, stopdate, $
              odsdir = odsdir, $
              odsver = 'aero_tc8', $
              outdir = outdir, $
              ntday = 1, $
              synopticoffset=720, $
              samplingmethod=['lat1.','lat2.','lat3.','lat4.','lat5.'], $
              /shave, method=method[imeth]

  endfor

end
