; Read from balkanski_fig4.ptxt and pluck out the middle column
; refractive indices (1.5% hematite internal mixtures)

  pro read_balkanski27, file, lambda, refreal, refimag

  openr, lun, file, /get_lun

  str = 'a'
  readf, lun, str

  i = 0
  while(not(eof(lun))) do begin
   data = fltarr(7)
   readf, lun, data
   if(i eq 0) then begin
    lambda  = data[0]*1.e-3
    refreal = data[6]
    refimag = data[3]
    i = i+1
   endif else begin
    lambda  = [lambda,data[0]*1.e-3]
    refreal = [refreal,data[6]]
    refimag = [refimag,data[3]]
    i = i+1
   endelse
  endwhile
  free_lun, lun

end
