; Read the AERONET daily file
; Works by passing in a filename (full path)
; All other variables are parsed and returned from the file
  pro read_aeronet_daily, filename, $
                          location, lon, lat, elev, nmeas, pi, pi_email, $
                          date, aot, ang, naot, nang


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

  nday = 0
  while(not eof(lun)) do begin
   readf, lun, strdata
   dataline = strsplit(strdata, ',' , /extract)
   strdate = dataline[0]
   datespl = strsplit(strdate,':', /extract)
   date_  = long(datespl[2]*1000000L)+long(datespl[1]*10000L)+long(datespl[0]*100L)+12L
   aot_   = dataline[3:18]
   ang_   = dataline[37:42]
   naot_  = dataline[43:58]
   nang_  = dataline[60:65]

;  replace missing/no data with flag
   a = where(aot_ eq 'N/A')
   if(a[0] ne -1) then aot_[a] = '-9999.'
   a = where(ang_ eq 'N/A')
   if(a[0] ne -1) then ang_[a] = '-9999.'
   a = where(naot_ eq 'N/A')
   if(a[0] ne -1) then naot_[a] = '-9999'
   a = where(nang_ eq 'N/A')
   if(a[0] ne -1) then nang_[a] = '-9999'

;  accumulate
   if(nday eq 0) then begin
    date = date_
    aot = float(aot_)
    ang = float(ang_)
    naot = fix(naot_)
    nang = fix(nang_)
   endif else begin
    date = [date, date_]
    aot = [aot, float(aot_)]
    ang = [ang, float(ang_)]
    naot = [naot, fix(naot_)]
    nang = [nang, fix(nang_)]
   endelse
   nday = nday + 1
  endwhile

  free_lun, lun

; Hard reform
  aot = reform(aot,16,nday)
  ang = reform(ang,6,nday)
  naot = reform(naot,16,nday)
  nang = reform(nang,6,nday)


end
