; Colarco, September 2018
; Read the non-volcanic balloon soundings and return the altitude and
; particle size distribution profile

  pro read_wpc, filename, alt, pres, temp, pottemp, rh, o3, cn, n, r, lat, lon

; Open the file and read a header
  openr, lun, filename, /get
  a = 'str'
  while(strmid(a,0,6) ne '------') do begin
   readf, lun, a
;   print, a
  endwhile

; Now read a five line specific header
  for i = 0, 4 do begin
   readf, lun, a
;   print, a
  endfor

; Now read line that gives you lat/lon
  readf, lun, a
  strs = strsplit(a,/extract)
  lat  = float(strs[9])
  lon  = float(strs[11])

; Now read 7 lines of cruft
  for i = 0, 6 do begin
   readf, lun, a
;   print, a
  endfor

; Next line contains the radius spacings
  readf, lun, a
; split string on ">" symbol and figure the radius is the next 5
; characters
  strs = strsplit(a,'>')
  nbin = n_elements(strs)-1
  r = fltarr(nbin)
  for ibin = 0, nbin-1 do begin
   x0 = strs[ibin+1]
   r[ibin] = float(strmid(a,x0,5))
  endfor

; Read one more line
  readf, lun, a

; Now read the data
  readf, lun, a
  strs = strsplit(a,/extract)
  pottemp = float(strs[1])
  alt     = float(strs[2])
  pres    = float(strs[3])
  temp    = float(strs[4])
  rh      = float(strs[5])
  o3      = float(strs[6])
  cn      = float(strs[7])
  n       = float(strs[8:8+nbin-1])
  icnt = 1
  while(not(eof(lun))) do begin
   readf, lun, a
   strs = strsplit(a,/extract)
   pottemp_ = float(strs[1])
   alt_     = float(strs[2])
   pres_    = float(strs[3])
   temp_    = float(strs[4])
   rh_      = float(strs[5])
   o3_      = float(strs[6])
   cn_      = float(strs[7])
   n_       = float(strs[8:8+nbin-1])
   pottemp  = [pottemp,pottemp_]
   alt      = [alt,alt_]
   pres     = [pres,pres_]
   temp     = [temp,temp_]
   rh       = [rh,rh_]
   o3       = [o3,o3_]
   cn       = [cn,cn_]
   n        = [n,n_]
   icnt     = icnt+1
  endwhile
  n = transpose(reform(n,nbin,icnt))

  free_lun, lun

end

