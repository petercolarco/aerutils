; Generate the aggregated MODIS files

  outdir = '/science/terra/misr/data/Level3/'

; QAWT styles
  qatype  = ['noqawt']
  nqatype = n_elements(qatype)

; Header information
  startdate = '20160218'
  stopdate  = '20170531'


  for iqa = 0, nqatype-1 do begin

    ods2grid_misr, 'MISR', startdate, stopdate, $
                   odsdir = '/science/terra/misr/data/Level3/ODS_03/', $
                   odsver = 'aero_tc8', $
                   outdir = outdir, $
                   resolutions=['b','c','d','e'], $
                   synopticoffset=0, ntday = 24, $
                   qatype = qatype[iqa], /shave
  endfor

end
