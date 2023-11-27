  pro get_regional, ctlfile, var, yyyy, nt, $
                    maskwant, lon0want, lon1want, lat0want, lat1want, $
                    reswant, inp_reg, date, q, lon, lat, gocart=gocartInp

  gocart = 0
  if(keyword_set(gocartInp)) then gocart = gocartInp

  if(reswant eq 'b') then begin
   nx = 144
   ny = 91
  endif else begin
   nx = 288
   ny = 181
  endelse

  nreg = n_elements(maskwant)


  ga_get_mask, mask, lon, lat, res=reswant
  nvars = n_elements(var)
  inp = fltarr(nx,ny)
  inp_reg = fltarr(nt,nreg)
  date = strarr(nt)
  q = fltarr(nx,ny,nreg)
  for it = 1, nt do begin
   imon = it- (it/12)*12
   iyear = it/12
   mon = strcompress(string(imon),/rem)
   if(imon lt 10) then mon = '0'+mon
   date[it-1] = strcompress(string(yyyy+iyear),/rem)+mon
   inp[*,*] = 0.
   for ivar = 0, nvars-1 do begin
    ga_get_diag_xdf, ctlfile, it, var[ivar], varout, lon, lat
    inp = inp + varout
   endfor

;  If code is gocart based let's assume I need to divide by seconds/month
;  and gridbox area
   if(gocart) then begin
    lon = findgen(144)*2.5
    lat = -90 + findgen(91)*2
    lat[0] = -89.
    lat[90] = 89.
    area, lon, lat, nx, ny, dxx, dyy, area
    inp = inp/30./86400/area
   endif

   for ireg = 0, nreg-1 do begin
    integrate_region, inp, lon, lat, mask, $
                      maskwant[ireg], lon0want[ireg], lon1want[ireg], $
                      lat0want[ireg], lat1want[ireg], intreg, q=qback
    q[*,*,ireg] = qback
    inp_reg[it-1,ireg] = intreg
   endfor
  endfor

end
