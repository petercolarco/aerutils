  pro read_diurnal_txt, head, nx, ny, nt, var, nn

  mm = ['01','02','03','04','05','06','07','08','09','10','11','12']
  nd = [ 31,  28,  31,  30,  31,  30,  31,  31,  30,  31,  30,  31 ]


; Get the precomputed preccon
   filen = head+'.txt'
print, filen
   openr, lun, filen, /get
   readf, lun, nx, ny, nt
   var = fltarr(nx,ny,nt)
   nn  = intarr(nx,ny,nt)
   readf, lun, var, nn
stop
   free_lun, lun

end
