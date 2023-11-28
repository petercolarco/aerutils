  pro read_rad, filename, wavelength, radiance

  openr, lun, filename, /get
; read header
  str = 'a'
  for i = 0, 11 do begin
   readf, lun, str
  endfor
; count remaining lines
  j = 0
  while(not(eof(lun))) do begin
   readf, lun, str
   j = j+1
  endwhile
  free_lun, lun

  openr, lun, filename, /get
; read header
  str = 'a'
  for i = 0, 11 do begin
   readf, lun, str
  endfor

  data = fltarr(3,j)
  readf, lun, data
  free_lun, lun

  wavelength = data[0,*]
  radiance = data[1,*]

end
