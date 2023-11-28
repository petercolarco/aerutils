  pro get_pm25_line, lun, state_, county_, site_, lat_, lon_, date_, mean_, rc

  str = 'a'
  readf, lun, str
  rc = 0
  str = str_replace(str,'"',' ')
  str = strcompress(str,/rem)
  data = strsplit(str,',',/extract)

  param = data[9]
; Check if strings in first line
  if(data[0] eq 'Date' or strpos(param,'Local') eq -1) then begin
   rc = 1
   return
  endif

  date_   = data[0]
  aqs     = data[1]
  state_  = strmid(aqs,0,2)
  county_ = strmid(aqs,2,3)
  site_   = strmid(aqs,5,4)
  lat_    = float(data[17])
  lon_    = float(data[18])
  mean_   = float(data[3])

end
