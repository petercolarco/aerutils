  pro integrateoptics, tauf, ssaf, gf, bbckf, etobf, $
                       tau, ssa, g, bbck, etob, abck0, abck1

; integrate over species
  
  tau  = total(tauf,3)
  ssa  = total(tauf*ssaf,3)/tau
  g    = total(gf*ssaf*tauf,3)/(tau*ssa)
  bbck = total(bbckf*tauf,3)/tau
  etob = total(etobf*tauf,3)/tau

; Now do the attentuated backscatter
; abck0 = from ground
; abck1 = from space
  szarr = size(tau)
  nx = szarr[1]
  nz = szarr[2]
  abck0 = fltarr(nx,nz)
  abck1 = fltarr(nx,nz)

  ztop = nz-1
  zbot = 0
  zstep = -1
  abck1[*,ztop] = bbck[*,ztop]*exp(-tau[*,ztop])
  for iz = ztop+zstep, zbot, zstep do begin
   taulev = make_array(nx,val=0.)
   for ik = ztop, iz-zstep, zstep do begin
    taulev = taulev + tau[*,ik]
   endfor
   taulev = taulev+0.5*tau[*,iz]
   abck1[*,iz] = bbck[*,iz]*exp(-2.*taulev)
  endfor

  ztop = 0
  zbot = nz-1
  zstep = 1
  abck0[*,ztop] = bbck[*,ztop]*exp(-tau[*,ztop])
  for iz = ztop+zstep, zbot, zstep do begin
   taulev = make_array(nx,val=0.)
   for ik = ztop, iz-zstep, zstep do begin
    taulev = taulev + tau[*,ik]
   endfor
   taulev = taulev+0.5*tau[*,iz]
   abck0[*,iz] = bbck[*,iz]*exp(-2.*taulev)
  endfor



end
