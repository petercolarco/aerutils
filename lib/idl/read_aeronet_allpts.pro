; Read the AERONET daily file
; Works by passing in a filename (full path)
; All other variables are parsed and returned from the file
  pro read_aeronet_allpts, filename, $
                           location, lon, lat, elev, nmeas, pi, pi_email, $
                           date, aot, ang


  openr, lun, filename, /get_lun
  strheader = strarr(5)
  strdata   = 'a'
  readf, lun, strheader

; parse out of the header the desired output
  header = strsplit(strheader(2), ',', /extract)
  location = strmid(header[0],strpos(header[0],'=')+1)
  lon      = float(strmid(header[1],strpos(header[1],'=')+1))
  lat      = float(strmid(header[2],strpos(header[2],'=')+1))
  elev     = float(strmid(header[3],strpos(header[3],'=')+1))
  nmeas    = fix(strmid(header[4],strpos(header[4],'=')+1))
  pi       = strmid(header[5],strpos(header[5],'=')+1)
  pi_email = strmid(header[6],strpos(header[6],'=')+1)

; Get the number of lines
  nday = 0L
  while(not eof(lun)) do begin
   readf, lun, strdata
   nday = nday + 1
  endwhile
  free_lun, lun

; Open and read the data
  openr, lun, filename, /get_lun
  strheader = strarr(5)
  strdata   = 'a'
  readf, lun, strheader

; Now the data
  strdata = strarr(nday)
  readf, lun, strdata
  free_lun, lun

; And break it up
  aot = strarr(16,nday)
  ang = strarr(6,nday)
  date = strarr(nday)
  for iday = 0L, nday-1 do begin
   dataline = strsplit(strdata[iday], ',' , /extract)
   strdate = dataline[0]
   datespl = strsplit(strdate,':', /extract)
   date_  = long(datespl[2]*10000L)+long(datespl[1]*100L)+long(datespl[0])
;  resolve the fraction of the day to the nearest hour
   fraction    = float(dataline[2])-fix(dataline[2])
   datehr_     = long(24*fraction+0.5)
   date[iday]  = date_*100L + datehr_
   aot[*,iday] = dataline[3:18]
   ang[*,iday] = dataline[37:42]
;  replace missing/no data with flag
   a = where(aot[*,iday] eq 'N/A')
   if(a[0] ne -1) then aot[a,iday] = '-9999.'
   a = where(ang[*,iday] eq 'N/A')
   if(a[0] ne -1) then ang[a,iday] = '-9999.'
  endfor

  aot = float(aot)
  ang = float(ang)
end
