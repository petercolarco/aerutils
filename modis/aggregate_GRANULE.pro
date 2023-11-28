; Generate the aggregated MODIS files

; Resolutions
;  resolution = ['a','b','c','d']
  resolution = ['d']
  nres = n_elements(resolution)
  outdir = '/misc/prc10/MODIS/Level3/MOD04/GRANULE/'+resolution+'/GRITAS/'

; QAWT styles
;  qatype  = ['qawt','noqawt','qawt3']
  qatype  = ['qawt']
  nqatype = n_elements(qatype)

; Header information
  satid = 'MOD04'
  startdate = '20000224'
  stopdate  = '20100101'


  for ires = 0, nres-1 do begin
   for iqa = 0, nqatype-1 do begin

    ods2grid, satid, startdate, stopdate, $
              odsdir = '/misc/prc10/MODIS/Level3/MOD04/GRANULE/ODS/', $
              odsver = 'aero_005', $
              outdir = outdir[ires], $
              obsspecial = 'obs_22', $
              synopticoffset=90, ntday = 8, resolution = resolution[ires], $
              qatype = qatype[iqa], /shave, regrid='v'
   endfor
  endfor

end
