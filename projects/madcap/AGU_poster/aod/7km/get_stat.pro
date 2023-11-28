  pro get_stat, ddf, res, wantlon=wantlon, wantlat=wantlat, $
                nt0=nt0_, nt1=nt1_, aotm=aotm, aotn=aotn, lon=lon, lat=lat

  print, ddf

  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nt0 = 0
  nt1 = n_elements(filename)-1
  if(n_elements(nt0_) ne 0) then nt0 = nt0_[0]
  if(n_elements(nt1_) ne 0) then nt1 = nt1_[0]
  filename = filename[nt0:nt1]
  nc4readvar, filename, ['totexttau'], aot, wantlat=wantlat, wantlon=wantlon, lon=lon, lat=lat
  a = where(aot lt 1.e12)
; Make a mean
  aot_ = aot
  b    = where(aot_ gt 1e12)
  if(b[0] ne -1) then aot_[b] = !values.f_nan
  aotm = mean(aot_,dim=3,/nan)
; Get the number of samples
  nx = n_elements(lon)
  ny = n_elements(lat)
  aotn = lonarr(nx,ny)
  for ix=0, nx-1 do begin
   for iy=0, ny-1 do begin
    n = where(finite(aot_[ix,iy,*]) eq 1)
    if(n[0] ne -1) then aotn[ix,iy] = n_elements(n)
   endfor
  endfor

  aot = aot[a]
  n = n_elements(a)
  c = sort(aot)
  aot = aot[c]
  mv = 1.
  res = createboxplotdata(aot, mean_values=mv)
  res[0] = aot[long(.1*n)]
  res[4] = aot[long(.9*n)]

; last element is mean value
  res = reform(res)
  res = [res,mv[0]]

end
