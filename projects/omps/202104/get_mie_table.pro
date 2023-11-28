; Given a bin and relative humidity return the table structure sampled
; accordingly

  pro get_mie_table, tableIn, tableOut, ibin, rh

  irh = interpol(indgen(n_elements(tableIn.rh)),tableIn.rh,rh)

  reff = interpolate(tableIn.reff[*,ibin],irh)
  rmass = interpolate(tableIn.rmass[*,ibin],irh)
  qext = interpolate(tableIn.qext[*,ibin],irh)
  qsca = interpolate(tableIn.qsca[*,ibin],irh)
  bext = interpolate(tableIn.bext[*,ibin],irh)
  bsca = interpolate(tableIn.bsca[*,ibin],irh)
  bbck = interpolate(tableIn.bbck[*,ibin],irh)
  g    = interpolate(tableIn.g[*,ibin],irh)
  refr = interpolate(tableIn.refr[*,ibin],irh)
  refi = interpolate(tableIn.refi[*,ibin],irh)
  nmom = n_elements(tableIn.pmom[0,0,*])
  pmom = fltarr(nmom,6)
  for ivec = 0, 5 do begin
   for imom = 0, nmom-1 do begin
    pmom[imom,ivec] = interpolate(tableIn.pmom[*,ibin,imom,ivec],irh)
   endfor
  endfor

  tableOut = {reff:reff, lambda:tableIn.lambda, qext:qext, qsca:qsca, $
              bext:bext, bsca:bsca, bbck:bbck, g:g, refr:refr, refi:refi, $
              pmom:pmom}

  end
