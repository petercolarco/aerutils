; Read the GLOPAC track for a given day
; Return the tracks and times


  pro read_ghawk_track, trackfile, lon, lat, altkm, date, rc=rc

  rc = 0

  satfile = trackfile
  openr, lun, satfile, /get_lun
  str = 'aaaaa'
; read a header
  nhead = 0
  while(strpos(str,'UTC') eq -1) do begin
   nhead = nhead+1
   readf, lun, str
  endwhile

  
; Read subsequent lines
  k = 0L
  while(not eof(lun)) do begin
   readf, lun, str
   if(str ne '') then k = k + 1L
  endwhile
  
  free_lun, lun

; Read again
  openr, lun, satfile, /get_lun
  str = 'a'
; read a header
  for i = 0, nhead-1 do begin
   readf, lun, str
  endfor

  data = strarr(k)
  readf, lun, data
  free_lun, lun

; Now parse the data out
  timestr  = strarr(k)
  lon   = fltarr(k)
  lat   = fltarr(k)
  altkm = fltarr(k)
 
  for i = 0L, k-1 do begin
   result = strsplit(data[i],/extract)
   timestr[i]  = result[0]
   lon[i]   = float(result[1])
   lat[i]   = float(result[2])
   altkm[i] = float(result[3])
  endfor
  
; Now convert the times to date
  date = dblarr(k)
  timestr = strcompress(timestr,/rem)
  yyyy = strmid(timestr,0,4)
  mm   = strmid(timestr,5,2)
  dd   = strmid(timestr,8,2)
  hh   = strmid(timestr,11,2)
  nn   = strmid(timestr,14,2)
  ss   = strmid(timestr,17,2)
  date = yyyy*10000.d0 + mm*100.d0 + dd*1.d0 $
        + (hh*3600.d0 + nn*60.d0 + ss)/86400.


end
