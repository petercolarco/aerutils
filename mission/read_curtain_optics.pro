  pro read_curtain_optics, filename, $
      ps, delp, rh, tau, ssa, g, etob, attback0, attback1, lev, ext

  cdfid = ncdf_open(filename)
   id = ncdf_varid(cdfid,'ps')
   if(id eq -1) then begin
    makeps = 1
   endif else begin
    ncdf_varget, cdfid, id, ps
    makeps = 0
   endelse
   id = ncdf_varid(cdfid,'delp')
   ncdf_varget, cdfid, id, delp
   id = ncdf_varid(cdfid,'rh')
   ncdf_varget, cdfid, id, rh
   id = ncdf_varid(cdfid,'tau')
   ncdf_varget, cdfid, id, tau
   id = ncdf_varid(cdfid,'ssa')
   ncdf_varget, cdfid, id, ssa
   id = ncdf_varid(cdfid,'g')
   ncdf_varget, cdfid, id, g
   id = ncdf_varid(cdfid,'etob')
   ncdf_varget, cdfid, id, etob
   id = ncdf_varid(cdfid,'attback0')
   ncdf_varget, cdfid, id, attback0
   id = ncdf_varid(cdfid,'attback1')
   ncdf_varget, cdfid, id, attback1
  ncdf_close, cdfid

; reform everything
  delp = reform(delp)
  if(makeps) then ps = total(delp,1)+1.
  ps = reform(ps)
  tau = reform(tau)
  ssa = reform(ssa)
  rh = reform(rh)
  g = reform(g)
  etob = reform(etob)
  attback0 = reform(attback0)
  attback1 = reform(attback1)

; make an output level
  lev = delp
  szarr = size(delp)
  nz = szarr[1]
  lev[0,*] = ps - delp[0,*]
  for iz = 1, nz-1 do begin
   lev[iz,*] = lev[iz-1,*] - delp[iz,*]
  endfor

; extinction: assumption is air density = 1 kg m-3
  scaleheight = 8000.
  dz = scaleheight*delp/lev
  ext = tau/dz

  tau = transpose(tau)
  lev = transpose(lev)
  ext = transpose(ext)
  delp = transpose(delp)
  rh = transpose(rh)
  ssa = transpose(ssa)
  g = transpose(g)
  etob = transpose(etob)
  attback0 = transpose(attback0)
  attback1 = transpose(attback1)

end
