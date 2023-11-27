; Procedure will create a standard atmosphere pressure and temperature
; profile consistent with the GEOS-5 edges and mid-layer profiles.
; Colarco, February 2011

  pro atmosphere, p, pe, delp, z, ze, delz, t, te, rhoa, nz=nz

  psfc = 101315.  ; Pa
  grav = 9.81     ; m s-1 acceleration of gravity

  if(not(keyword_set(nz))) then nz = 72

; Get the eta-levels
  set_eta, hyai, hybi, nz=nz
  hyai = reverse(hyai)
  hybi = reverse(hybi)

; Edge pressures in Pa
  pe = hyai + hybi*psfc 

; Compute the delp and mid-layer pressure (assume logarithmic)
  nz = n_elements(hyai)-1
  delp = fltarr(nz)
  p    = fltarr(nz)
  delp = pe[1:nz]-pe[0:nz-1]
  p    = exp(0.5 * (alog(pe[0:nz-1]) + alog(pe[1:nz])))

; Get the layer edge and mid-layer temperatures and altitudes from US
; standard atmosphere
  presaltnew, p/100., z, rhoa, t, 99999.
  presaltnew, pe/100., ze, rhoa_e, te, 99999.

; Units
  z    = z*1000.  ; m
  ze   = ze*1000. ; m
  delz = ze[0:nz-1]-ze[1:nz]

end
