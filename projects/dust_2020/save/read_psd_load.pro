; Colarco
; Open and read Jasper Kok's PSD from Figure 2b in Nature 2017

  pro read_psd_load, diam, dmdlnd, dmdlndm2, dmdlndp2

  openr, lun, 'PSD_load.txt', /get
  str = 'a'
  readf, lun, str
  readf, lun, str
  icount = 0
  while(not(eof(lun))) do begin
   readf, lun, str
   icount = icount+1
  endwhile
  free_lun, lun

  openr, lun, 'PSD_load.txt', /get
  str = 'a'
  readf, lun, str
  readf, lun, str
  dat = strarr(icount)
  readf, lun, dat
  free_lun, lun

  diam = fltarr(icount)
  dmdlnd = fltarr(icount)
  dmdlndm2 = fltarr(icount)
  dmdlndp2 = fltarr(icount)
  for i = 0, icount-1 do begin
   spl = strsplit(dat[i],' ',/extract)
   diam[i] = float(spl[0])
   dmdlnd[i] = float(spl[1])
   dmdlndm2[i] = float(spl[2])
   dmdlndp2[i] = float(spl[5])
  endfor

;  x = [diam,reverse(diam),diam[0]]
;  y = [dmdlndp1,reverse(dmdlndm1),dmdlndp1[0]]
;  plot, diam, dmdlnd, /xlog, /ylog
;  polyfill, x, y, color=120, noclip=0

end
