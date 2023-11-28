  pro gather_diurnal_pm25, fileh, out

; Read in the land/ocean fraction
  filen = 'M2R12K.const_2d_asm_Nx.20060101_0000z.1deg.nc'
  nc4readvar, filen,'FROCEAN',frocean,lon=lon,lat=lat
  nc4readvar, filen,'AREA',area,lon=lon,lat=lat

  nx = n_elements(lon)
  ny = n_elements(lat)
  nt = 24

  mm = ['01','02','03','04','05','06','07','08','09','10','11','12']
  nd = [ 31,  28,  31,  30,  31,  30,  31,  31,  30,  31,  30,  31 ]

  read_diurnal_nc, fileh, 'pm25', nx, ny, nt, p_full, n_full

  latt = fltarr(nx,ny)
  for ix = 0, nx-1 do begin
   latt[ix,*] = lat
  endfor

; Do a global average diurnal cycle
  p_full_glb = fltarr(nt)
  p_full_lnd = fltarr(nt)
  p_full_ocn = fltarr(nt)
  p_full_glb_n = fltarr(nt)
  p_full_lnd_n = fltarr(nt)
  p_full_ocn_n = fltarr(nt)
  p_full_glb_s = fltarr(nt)
  p_full_lnd_s = fltarr(nt)
  p_full_ocn_s = fltarr(nt)
  p_full_glb_t = fltarr(nt)
  p_full_lnd_t = fltarr(nt)
  p_full_ocn_t = fltarr(nt)
  a = where(frocean eq 1.)
  b = where(frocean ne 1.)
  c = where(frocean eq 1. and latt ge 30.)
  d = where(frocean ne 1. and latt ge 30.)
  e = where(frocean eq 1. and latt le -30.)
  f = where(frocean ne 1. and latt le -30.)
  g = where(frocean eq 1. and latt gt -30. and latt lt 30.)
  h = where(frocean ne 1. and latt gt -30. and latt lt 30.)
  for it = 0, nt-1 do begin
   p_full_glb[it] = total(p_full[*,it]*n_full[*,it]*area)/total(n_full[*,it]*area)
   p_full_ocn[it] = total(p_full[a,it]*n_full[a,it]*area[a])/total(n_full[a,it]*area[a])
   p_full_lnd[it] = total(p_full[b,it]*n_full[b,it]*area[b])/total(n_full[b,it]*area[b])
   i = where(latt ge 30.)
   p_full_glb_n[it] = total(p_full[i,it]*n_full[i,it]*area[i])/total(n_full[i,it]*area[i])
   p_full_ocn_n[it] = total(p_full[c,it]*n_full[c,it]*area[c])/total(n_full[c,it]*area[c])
   p_full_lnd_n[it] = total(p_full[d,it]*n_full[d,it]*area[d])/total(n_full[d,it]*area[d])
   j = where(latt le -30.)
   p_full_glb_s[it] = total(p_full[j,it]*n_full[j,it]*area[j])/total(n_full[j,it]*area[j])
   p_full_ocn_s[it] = total(p_full[e,it]*n_full[e,it]*area[e])/total(n_full[e,it]*area[e])
   p_full_lnd_s[it] = total(p_full[f,it]*n_full[f,it]*area[f])/total(n_full[f,it]*area[f])
   l = where(latt gt -30. and latt lt 30.)
   p_full_glb_t[it] = total(p_full[l,it]*n_full[l,it]*area[l])/total(n_full[l,it]*area[l])
   p_full_ocn_t[it] = total(p_full[g,it]*n_full[g,it]*area[g])/total(n_full[g,it]*area[g])
   p_full_lnd_t[it] = total(p_full[h,it]*n_full[h,it]*area[h])/total(n_full[h,it]*area[h])
  endfor

  out = fltarr(12,24)
  out[0,*] = p_full_glb
  out[1,*] = p_full_ocn
  out[2,*] = p_full_lnd

  out[3,*] = p_full_glb_n
  out[4,*] = p_full_ocn_n
  out[5,*] = p_full_lnd_n

  out[6,*] = p_full_glb_s
  out[7,*] = p_full_ocn_s
  out[8,*] = p_full_lnd_s

  out[9,*] = p_full_glb_t
  out[10,*] = p_full_ocn_t
  out[11,*] = p_full_lnd_t

; kg m-3

end
