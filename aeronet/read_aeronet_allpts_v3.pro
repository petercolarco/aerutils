; Read the AERONET daily file
; Works by passing in a filename (full path)
; All other variables are parsed and returned from the file
  pro read_aeronet_allpts_v3, filename, $
                              location, lon, lat, elev, nmeas, pi, pi_email, $
                              date, aot, ang


; Read a header
  openr, lun, filename, /get_lun
  strheader = strarr(7)
  strdata   = 'a'
  readf, lun, strheader

; parse out of the header the desired output
  location = strcompress(strheader[1],/rem)
  header   = strsplit(strheader(4), ';', /extract)
  pi       = strcompress(strmid(header[0],strpos(header[0],'=')+1),/rem)
  pi_email = strcompress(strmid(header[1],strpos(header[1],'=')+1),/rem)

; Get the number of lines
  nday = 0L
  while(not eof(lun)) do begin
   readf, lun, strdata
   nday = nday + 1
  endwhile
  free_lun, lun

; Open and read the data
  openr, lun, filename, /get_lun
  strheader = strarr(7)
  strdata   = 'a'
  readf, lun, strheader

; Now the data
  strdata = strarr(nday)
  readf, lun, strdata
  free_lun, lun

; And break it up
  aot = strarr(22,nday)
  ang = strarr(6,nday)
  date = strarr(nday)
  for iday = 0L, nday-1 do begin
   dataline = strsplit(strdata[iday], ',' , /extract)
;  This was a fixed field in V2, now could vary, but here we just
;  assume "0" value is okay
   if(iday eq 0L) then begin
    lon   = float(dataline[74])
    lat   = float(dataline[73])
    elev  = float(dataline[75])
    nmeas = 0.
   endif
   strdate = dataline[0]
   datespl = strsplit(strdate,':', /extract)
   date_  = long(datespl[2]*10000L)+long(datespl[1]*100L)+long(datespl[0])
;  resolve the fraction of the day to the nearest hour
   fraction    = float(dataline[2])-fix(dataline[2])
   datehr_     = long(24*fraction+0.5)
   date[iday]  = date_*100L + datehr_
   aot[*,iday] = dataline[4:25]
   ang[*,iday] = dataline[64:69]
;  replace missing/no data with flag
   a = where(aot[*,iday] eq 'N/A' or aot[*,iday] lt -990.)
   if(a[0] ne -1) then aot[a,iday] = '-9999.'
   a = where(ang[*,iday] eq 'N/A' or ang[*,iday] lt -990.)
   if(a[0] ne -1) then ang[a,iday] = '-9999.'
  endfor

  aot = float(aot)
  ang = float(ang)
end
