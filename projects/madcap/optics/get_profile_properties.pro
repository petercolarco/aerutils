; Colarco, November 2018
; Given an input optics table(s) and constituent grid return the
; integrated optical properties

; tables is a structure of tables (e.g., {strSU, strDU, ...}
; const  is a structure of consitutents (e.g., {constSU, ...}

  pro get_profile_properties, rh, delp, tables, const, ssa, tau, g, pmom

  nz   = n_elements(rh)
  nmom = 301
  tau  = fltarr(nz)
  ssa  = fltarr(nz)
  g    = fltarr(nz)
  pmom = fltarr(nz,nmom)
  grav = 9.81

; Sulfate
  if(tag_exist(tables,'strSU') and tag_exist(const,'constSU')) then begin
   profile_properties, rh, delp, tables.strSU, const.constSU, ssa_, tau_, g_, pmom_
   tau = tau + tau_
   ssa = ssa + ssa_*tau_
   g   = +g_*ssa_*tau_
   for imom = 0, nmom-1 do begin
    pmom[*,imom] = pmom[*,imom] + pmom_[*,imom]*ssa_*tau_
   endfor
  endif

; Dust
  if(tag_exist(tables,'strDU') and tag_exist(const,'constDU')) then begin
   profile_properties, rh, delp, tables.strDU, const.constDU, ssa_, tau_, g_, pmom_
   tau = tau + tau_
   ssa = ssa + ssa_*tau_
   g   = +g_*ssa_*tau_
   for imom = 0, nmom-1 do begin
    pmom[*,imom] = pmom[*,imom] + pmom_[*,imom]*ssa_*tau_
   endfor
  endif

; BC
  if(tag_exist(tables,'strBC') and tag_exist(const,'constBC')) then begin
   profile_properties, rh, delp, tables.strBC, const.constBC, ssa_, tau_, g_, pmom_
   tau = tau + tau_
   ssa = ssa + ssa_*tau_
   g   = +g_*ssa_*tau_
   for imom = 0, nmom-1 do begin
    pmom[*,imom] = pmom[*,imom] + pmom_[*,imom]*ssa_*tau_
   endfor
  endif

; OC
  if(tag_exist(tables,'strOC') and tag_exist(const,'constOC')) then begin
   profile_properties, rh, delp, tables.strOC, const.constOC, ssa_, tau_, g_, pmom_
   tau = tau + tau_
   ssa = ssa + ssa_*tau_
   g   = +g_*ssa_*tau_
   for imom = 0, nmom-1 do begin
    pmom[*,imom] = pmom[*,imom] + pmom_[*,imom]*ssa_*tau_
   endfor
  endif

; Nitrate
  if(tag_exist(tables,'strNI') and tag_exist(const,'constNI')) then begin
   profile_properties, rh, delp, tables.strNI, const.constNI, ssa_, tau_, g_, pmom_
   tau = tau + tau_
   ssa = ssa + ssa_*tau_
   g   = +g_*ssa_*tau_
   for imom = 0, nmom-1 do begin
    pmom[*,imom] = pmom[*,imom] + pmom_[*,imom]*ssa_*tau_
   endfor
  endif

; Seasalt
  if(tag_exist(tables,'strSS') and tag_exist(const,'constSS')) then begin
   profile_properties, rh, delp, tables.strSS, const.constSS, ssa_, tau_, g_, pmom_
   tau = tau + tau_
   ssa = ssa + ssa_*tau_
   g   = +g_*ssa_*tau_
   for imom = 0, nmom-1 do begin
    pmom[*,imom] = pmom[*,imom] + pmom_[*,imom]*ssa_*tau_
   endfor
  endif



; Normalize
  ssa  = ssa / tau
  g    = g / (ssa*tau)
  for imom = 0, nmom-1 do begin
   pmom[*,imom] = pmom[*,imom] / (ssa*tau)
  endfor

end

