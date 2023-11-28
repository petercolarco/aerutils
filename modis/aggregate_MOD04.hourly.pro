; Generate the aggregated MODIS files

; Resolutions
  resolution = ['b']
  nres = n_elements(resolution)
  satid = 'MOD04'
  method = ['ocean','land','deep']
;  method = ['ocean','land']
  nres = n_elements(resolution)
  nmethod = n_elements(method)
  outdir = '/science/modis/data/Level3/'+satid+'/hourly/'+resolution+'/GRITAS/'

; Header information
  startdate = '20000224'
  stopdate  = '20160630'


  for ires = 0, nres-1 do begin
   for imeth = 0, nmethod-1 do begin

    if(method[imeth] eq 'ocean') then qatype = 'qawt'
    if(method[imeth] eq 'land')  then qatype = 'qawt3'

    ods2grid, satid, startdate, stopdate, $
              odsdir = '/science/modis/data/Level3/'+satid+'/ODS_03/', $
              odsver = 'aero_tc8', collection='006', $
              outdir = outdir[ires], $
              synopticoffset=0, ntday = 24, resolution = resolution[ires], $
              qatype = qatype, /shave, method=method[imeth]
   endfor
  endfor

end
