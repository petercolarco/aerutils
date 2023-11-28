; Colarco
; September 2, 2008
; Read the CALIPSO track files provided by Chieko Kittaka

; With the optional MBL keyword, read Judd Welton's files

  pro read_calipso_track, trackfile, lon, lat, date, mbl=mbl

  if(not(keyword_set(mbl))) then mbl = 0


  case mbl of
   0: begin
;     Chieko provided tracks
      nhead = 1
      ncol = 8
      nlon = 4
      nlat = 5
      end
   1: begin
;     Offset MBL tracks
      nhead = 0
      ncol = 3
      nlon = 2
      nlat = 1
      end
   2: begin
;     Original MBL tracks
      nhead = 6
      ncol = 3
      nlon = 2
      nlat = 1
      end
  endcase

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
  readf, lun, dataInp
  free_lun, lun

  lon = reform(dataInp[nlon,*])
  lat = reform(dataInp[nlat,*])

  if(mbl eq 0) then begin
;  Split date from Chieko's files
   sec_  = reform(double(dataInp[3,*]))
   yyyy_ = reform(long(dataInp[0,*]))
   mm_   = reform(long(dataInp[1,*]))
   dd_   = reform(long(dataInp[2,*]))

   yyyym1_ = yyyy_-1

;  cast the date as a fractional day number
;  Judd gives date as YYYYMMDD.fraction_of_day_from_0Z
   date   = yyyy_*10000.d + mm_*100.d + dd_*1.d + sec_/86400.d
   daynum_ = julday(mm_,dd_,yyyy_) - julday(12,31,yyyym1_) + sec_/86400.

  endif else begin
   date = reform(dataInp[0,*])
  endelse

end

