; Colarco
; September 2, 2008
; Read the ER2 track files 

  pro read_er2_track, trackfile, lon, lat, data

  nhead = 6
  ncol = 4
  nlon = 2
  nlat = 1

; Count lines in file
  openr, lun, trackfile, /get_lun
; read a header
  str = 'a'
  for i = 0, nhead-1 do begin
   readf, lun, str
  endfor
; count the lines after the header
  i = 0L
  while(not eof(lun) ) do begin
   readf, lun, str
   i = i +1L
  endwhile
  free_lun, lun

; Create the data array
  dataInp = dblarr(ncol,i)
; Open to read
  openr, lun, trackfile, /get_lun
; read a header
  str = 'a'
  for i = 0, nhead-1 do begin
   readf, lun, str
  endfor
  readf, lun, dataInp, format = '(d17.8,3x,f11.7,3x,f11.7,3x,f8.4)'
  free_lun, lun

  lon = reform(dataInp[nlon,*])
  lat = reform(dataInp[nlat,*])
  data = dataInp

  date = reform(dataInp[0,*])

end

