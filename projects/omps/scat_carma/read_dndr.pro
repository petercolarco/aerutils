  openr, lun, 'dndr_global.txt', /get
  str = 'a'
  readf, lun, str
  spl = strsplit(str,/extract)
  r = float(spl[2:23])
  readf, lun, str
  spl = strsplit(str,/extract)
  dr = float(spl[2:23])
  alt_km = fltarr(72)
  dndr = fltarr(72,22)
  for iz = 0, 71 do begin
   readf, lun, str
   spl = strsplit(str,/extract)
   alt_km[iz] = float(spl[0])
   dndr[iz,*] = float(spl[2:23])
  endfor

  free_lun, lun

end
