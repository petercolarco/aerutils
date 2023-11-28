; Generate the aggregated MODIS files

; Resolutions
  resolution = ['a','b','c','d','e']
  resolution = ['b']
  satid = 'MYD04'
  method = ['ocean','land']
  nres = n_elements(resolution)
  nmethod = n_elements(method)
  outdir = './'

; QAWT styles
  qatype  = ['noqawt']
  nqatype = n_elements(qatype)

; Header information
;  startdate = '20040101'
  startdate = '20100601'
  stopdate  = '20100602'


  for ires = 0, nres-1 do begin
   for iqa = 0, nqatype-1 do begin
    for imeth = 0, nmethod-1 do begin

;   Don't do deepblue for MOD04 after 2005
    ods2grid, satid, startdate, stopdate, $
              odsdir = '/home/colarco/', $
              outdir = outdir[ires], $
              synopticoffset=90, ntday = 8, resolution = resolution[ires], $
              qatype = qatype[iqa], /shave, method=method[imeth]
    endfor
   endfor
  endfor

end
