  pro read_woodward, file, lambda, refreal, refimag

  openr, lun, file, /get_lun

  str = 'a'
  readf, lun, str

  i = 0
  while(not(eof(lun))) do begin
   data = fltarr(3)
   readf, lun, data
   if(i eq 0) then begin
    lambda  = data[0]
    refreal = data[1]
    refimag = data[2]
    i = i+1
   endif else begin
    lambda  = [lambda,data[0]]
    refreal = [refreal,data[1]]
    refimag = [refimag,data[2]]
    i = i+1
   endelse
  endwhile
  free_lun, lun

end
