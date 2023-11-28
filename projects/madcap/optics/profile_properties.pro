; Colarco, November 2018
; Given an input optics table(s) and constituent grid return the
; integrated optical properties

; tables is a single table
; const  is a single constituent

  pro profile_properties, rh, delp, tables, const, ssa, tau, g, pmom

  nz   = n_elements(rh)
  nmom = 301
  tau  = fltarr(nz)
  ssa  = fltarr(nz)
  g    = fltarr(nz)
  pmom = fltarr(nz,nmom)
  grav = 9.81

  sz = size(const)
  if(sz[0] eq 1) then nbin = 1
  if(sz[0] eq 2) then nbin = sz[2]

  for iz = 0, nz-1 do begin
   for ib = 0, nbin-1 do begin
    get_mie_table, tables, table, ib, rh[iz]
    tau_ = const[iz,ib]*delp[iz]/grav*table.bext
    ssa_ = table.bsca / table.bext
    tau[iz] = tau[iz] + tau_
    ssa[iz] = ssa[iz] + ssa_*tau_
    g[iz]   = g[iz]   + table.g*ssa_*tau_
    for imom = 0, nmom-1 do begin
     pmom[iz,imom] = pmom[iz,imom] + table.pmom[imom]*ssa_*tau_
    endfor
   endfor
  endfor

; Normalize
  tau[where(tau lt 1.e-32,/null)] = 1.e-32
  ssa  = ssa / tau
  ssa[where(tau le 1.e-32,/null)] = 1.
  g    = g / (ssa*tau)
  for imom = 0, nmom-1 do begin
   pmom[*,imom] = pmom[*,imom] / (ssa*tau)
  endfor

end
