; Colarco, Sept. 2008
; Read in supplied CALIPSO orbit tracks (or MBL tracks) based on
; providing path to data file, trackfile name to read, and return the
; lon, lat, and date of the points in the track

; method
;  = 0::  6 line header
;  = 1::  0 line header

  pro get_calipso_track, lon, lat, date, $
                         datapath = datapath, trackfile=trackfile, $
                         method = method

  if(not(keyword_set(datapath))) then datapath = './'
  if(not(keyword_set(method)))   then method = 0
  filename = datapath + trackfile

  openr, lun, filename, /get_lun
  str = 'a'

; Possibly read a header
  if(method eq 0) then begin
   for i = 0, 5 do begin
    readf, lun, str
   endfor
  endif

; Count the data lines
  i = 0L
  while(not eof(lun) ) do begin
   readf, lun, str_
   i = i+1L
  endwhile
  free_lun, lun

; Now read and parse the data
  dataInp = dblarr(3,i)
  openr, lun, filename, /get_lun
  str = 'a'

; Possibly read a header
  if(method eq 0) then begin
   for i = 0, 5 do begin
    readf, lun, str
   endfor
  endif
  readf, lun, dataInp

  date = reform(dataInp[0,*])
  lon  = reform(dataInp[2,*])
  lat  = reform(dataInp[1,*])


end
