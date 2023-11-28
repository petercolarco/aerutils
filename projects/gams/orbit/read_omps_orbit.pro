; Colarco, January 2017
; Nick Gorkavyi provides these orbit tracks

  file = 'Parameters-orbit-06-22-16.dat'
  file = 'Parameters-orbit-12-22-16.dat'

  openr, lun, file, /get
  str = 'a'
  icount = 0
  while(not(eof(lun))) do begin
   readf, lun, str
   icount = icount+1
  endwhile
  free_lun, lun

; Now have line count
; Nick defines data as columns
;  n frames
;  seconds since midnight
;  latitude of 25 km tangent height
;  longitude of 25 km tangent height
;  SZA at 25 km tangent height
;  single scattering angle at 25 km tangent height
;  solar azimuth angle at 25 km tangent height
;  satellite azimuth at 25 km tangent height
  openr, lun, file, /get
  data = fltarr(8,icount)
  readf, lun, data
  free_lun, lun
  data = transpose(data)

  sec = data[*,1]
  lon = data[*,3]
  lat = data[*,2]
  sza = data[*,4]
  ssa = data[*,5]
  

end

