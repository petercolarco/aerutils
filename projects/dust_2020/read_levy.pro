  pro read_levy, model, rv, sig, vm, nmode

  openr, lun, 'AllAlgs_allmodels_modeparam_t1p00.csv', /get

  str = 'a'
  readf, lun, str
  header = strsplit(str,',',/extract)
  nmod = n_elements(header)/2
  readf, lun, str
  algo   = strsplit(str,',',/extract)
  readf, lun, str
  model  = strsplit(str,',',/extract)
  readf, lun, str
  aod    = strsplit(str,',',/extract)
  readf, lun, str
  lambda = strsplit(str,',',/extract)
  readf, lun, str
  modes  = strsplit(str,',',/extract)
  i = 0
  while(not(eof(lun))) do begin
   readf, lun, str
   i = i+1
  endwhile
  free_lun, lun

; reread
  data = strarr(i)
  openr, lun, 'AllAlgs_allmodels_modeparam_t1p00.csv', /get

  str = 'a'
  readf, lun, str
  header = strsplit(str,',',/extract)
  nmod = n_elements(header)/2
  readf, lun, str
  algo   = strsplit(str,',',/extract)
  readf, lun, str
  model  = strsplit(str,',',/extract)
  readf, lun, str
  aod    = strsplit(str,',',/extract)
  readf, lun, str
  lambda = strsplit(str,',',/extract)
  readf, lun, str
  modes  = strsplit(str,',',/extract)
  readf, lun, data

  free_lun, lun

  n = n_elements(header)
  algo   = algo[1:n-1:2]
  model  = model[1:n-1:2]
  aod    = aod[1:n-1:2]
  lambda = lambda[1:n-1:2]
  nmode  = modes[1:n-1:2]

  rv  = fltarr(nmod,4)
  sig = fltarr(nmod,4)
  vm  = fltarr(nmod,4)
  k = 0
  for j = 1, i-1, 14 do begin
   tmp = strsplit(data[j],',',/extract)
   tmp = tmp[1:n-1:2]
   sig[*,k] = tmp
   tmp = strsplit(data[j+3],',',/extract)
   tmp = tmp[1:n-1:2]
   rv[*,k] = tmp
   tmp = strsplit(data[j+5],',',/extract)
   tmp = tmp[1:n-1:2]
   vm[*,k] = tmp
   k = k+1
  endfor


end
