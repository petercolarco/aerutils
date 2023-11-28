; Generate the aggregated MODIS files

; Resolutions
  resolution = ['a','b','c','d','e']
  resolution = ['d']
  nres = n_elements(resolution)
  satid = 'MYD04'
  method = ['ocean','land','deep']
  nres = n_elements(resolution)
  nmethod = n_elements(method)
  outdir = './'

; QAWT styles
  qatype  = ['noqawt']
  nqatype = n_elements(qatype)

; Header information
  startdate = '20090715'
  stopdate  = '20090715'


  for ires = 0, nres-1 do begin
   for iqa = 0, nqatype-1 do begin
   for imeth = 0, nmethod-1 do begin

    deepblue = 0
    if(qatype[iqa] eq 'qawt3') then deepblue = 1
    ods2grid, satid, startdate, stopdate, $
              odsdir = '/misc/prc10/MODIS/Level3/'+satid+'/ODS_03/', $
              odsver = 'aero_tc8', $
              outdir = outdir[ires], $
              ntday = 8, resolution = resolution[ires], $
              qatype = qatype[iqa], /shave, method=method[imeth]
   endfor
   endfor
  endfor

end
