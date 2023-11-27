; Colarco, May 2007
; Given surface pressure and hybrid coordinates construct the three
; dimensional pressure levels.  Assume each level is at the arithmatic
; middle of the eta level

  pro pressure_levels, surfp, hyai, hybi, p, delp

; size of surface pressure array
  sps = size(surfp)
  nx = sps[1]
  ny = sps[2]
  nz = n_elements(hyai)-1
  nt = 1
  if(sps[0] eq 4) then nt = sps[4]

; create the output array
  p    = make_array(nx,ny,nz,nt)
  delp = make_array(nx,ny,nz,nt)

; loop to create the three-d pressure
  for it = 0, nt-1 do begin
   for iz = 0, nz-1 do begin
    plow = hyai[iz]  +surfp[*,*,0]*hybi[iz]
    pup  = hyai[iz+1]+surfp[*,*,0]*hybi[iz+1]
    plow = reform(plow,nx,ny)
    pup  = reform(pup,nx,ny)
    p[*,*,iz,it] = 0.5*(pup+plow)
    delp[*,*,iz,it] = plow-pup
   endfor
  endfor

end
