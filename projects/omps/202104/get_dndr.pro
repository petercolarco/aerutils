; Get the dndr from a provided file (profile in 22 bins and 72 levels)
; r is particle bin radius in [m]
; dr is particle bin width in [m]
; dndr is the particle size distribution dN / dr in [# m-3 m-1]
;  -- multiply dndr * dr to get [# m-3] in each bin
  pro get_dndr, filename, r, dr, dndr, alt
  openr, lun, filename, /get
  strrad = 'a'
  strdr  = 'a'
  stralt = strarr(72)
  readf, lun, strrad
  strl = strlen(strrad)
  r = float(strsplit(strmid(strrad,10,strl-10),/extract))
  readf, lun, strdr
  strl = strlen(strdr)
  dr = float(strsplit(strmid(strdr,10,strl-10),/extract))
  readf, lun, stralt
  alt = fltarr(72)
  dndr = fltarr(72,22)
  for i = 0, 71 do begin
   strl = strlen(stralt[i])
   alts = strsplit(strmid(stralt[i],0,10),/extract)
   alt[i] = alts[0]  ; km
   dndr[i,*] = float(strsplit(strmid(stralt[i],10,strl-10),/extract))
  endfor
  nbin = n_elements(r)
  free_lun, lun

end
