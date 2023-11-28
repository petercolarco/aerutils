; Generate the aggregated MODIS files

; Resolutions
;  resolution = ['a','b','c','d','e']
  resolution = ['b','c','d','ten']
  nres = n_elements(resolution)
  outdir = '/science/terra/misr/data/Level3/'+resolution+'/'

; QAWT styles
  qatype  = ['noqawt']
  nqatype = n_elements(qatype)

; Header information
  startdate = '20120901'
  stopdate  = '20130101'


  for ires = 0, nres-1 do begin
   for iqa = 0, nqatype-1 do begin

    ods2grid_misr, 'MISR', startdate, stopdate, $
                   odsdir = '/science/terra/misr/data/Level3/ODS_03/', $
                   odsver = 'aero_tc8', $
                   outdir = outdir[ires], $
                   synopticoffset=90, ntday = 8, $
                   resolution = resolution[ires], $
                   qatype = qatype[iqa], /shave
   endfor
  endfor

end
