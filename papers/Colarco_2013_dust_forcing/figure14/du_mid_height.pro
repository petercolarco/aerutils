; Colarco
; Given a filename, return a vector containing the
; height above which half the dust mass resides

  pro du_mid_height, filename, dulev, lon=lon

  nc4readvar, filename, 'du', du, lon=lon, lat=lat, lev=lev

  nx = n_elements(lon)
  nz = n_elements(lev)
  delp = lev
  delp[1:nz-1] = lev[1:nz-1]-lev[0:nz-2]

; average du over some latitude band
  a = where(du gt 1e14)
  du[a] = !values.f_nan
  a = where(lat ge 10 and lat le 30)
  du = mean(du[*,a,*],dimension=2,/nan)
  dulontot = fltarr(nx)
  dulev = fltarr(nx)
  for ix = 0, nx-1 do begin
   dulontot[ix] = total(du[ix,*]*delp,/nan)
   tot = 0
   for iz = 0, nz-1 do begin
    dulev[ix] = 0.
    tot = tot + du[ix,iz]*delp[iz]
    if(tot ge 0.5*dulontot[ix]) then begin  ; refine
     tot = tot - du[ix,iz]*delp[iz]
     delp_ = delp[iz] / 100.
     dulev[ix] = lev[iz-1]
     for j = 0, 99 do begin
      tot = tot + du[ix,iz]*delp_
      dulev[ix] = dulev[ix]+delp_
      if(tot ge 0.5*dulontot[ix]) then break
     endfor
    endif
    if(dulev[ix] gt 0) then break
   endfor
  endfor

end
