; Read the AERONET monthly file
; Works by passing in a filename (full path)
; All other variables are parsed and returned from the file

; The data file layout is 4 rows for each month
; 1) means from daily averages
; 2) means from weighted averages
; 3) number of days included
; 4) number of obs included

  pro read_aeronet_inversions_allpts, filename, $
                                      location, lon, lat, elev, nmeas, $
                                      pi, pi_email, $
                                      date, aotw, water, $
                                      tauext, tauextf, tauextc, angext, $
                                      ssa, tauabs, angabs, dvdlnr, rc=rc

  rc = 0

  openr, lun, filename, /get_lun
  strheader = strarr(4)
  strdata   = 'a'
  readf, lun, strheader

; parse out of the header the desired output
  header = strsplit(strheader(0), ',', /extract)
  location = strmid(header[1],strpos(header[1],'=')+1)
  lon      = float(strmid(header[2],strpos(header[2],'=')+1))
  lat      = float(strmid(header[3],strpos(header[3],'=')+1))
  elev     = float(strmid(header[4],strpos(header[4],'=')+1))
  nmeas    = fix(strmid(header[5],strpos(header[5],'=')+1))
  pi       = strmid(header[6],strpos(header[6],'=')+1)
  pi_email = strmid(header[7],strpos(header[7],'=')+1)

  nday = 0

  while(not eof(lun)) do begin

   readf, lun, strdata
   dataline = strsplit(strdata, ',' , /extract)
   strdate = dataline[0]
   datespl = strsplit(strdate,'-', /extract)
   datespl = strsplit(strdate,':', /extract)
   date_  = long(datespl[2]*1000000L)+long(datespl[1]*10000L)+long(datespl[0]*100L)
;  resolve the fraction of the day to the nearest hour
   fraction    = float(dataline[2])-fix(dataline[2])
   datehr_     = long(24*fraction+0.5)
   date_  = date_ + datehr_

   aotw_    = dataline[3:18]
   water_   = dataline[19]
   tauext_  = dataline[20:23]
   tauextf_ = dataline[24:27]
   tauextc_ = dataline[28:31]
   angext_  = dataline[32]
   ssa_     = dataline[33:36]
   tauabs_  = dataline[37:40]
   angabs_  = dataline[41]
   dvdlnr_  = dataline[62:83]

;  replace missing/no data with flag
   a = where(aotw_ eq 'N/A')
   if(a[0] ne -1) then aotw_[a] = '-9999.'
   a = where(water_ eq 'N/A')
   if(a[0] ne -1) then water_[a] = '-9999.'
   a = where(tauext_ eq 'N/A')
   if(a[0] ne -1) then tauext_[a] = '-9999.'
   a = where(tauextf_ eq 'N/A')
   if(a[0] ne -1) then tauextf_[a] = '-9999.'
   a = where(tauextc_ eq 'N/A')
   if(a[0] ne -1) then tauextc_[a] = '-9999.'
   a = where(angext_ eq 'N/A')
   if(a[0] ne -1) then angext_[a] = '-9999.'
   a = where(ssa_ eq 'N/A')
   if(a[0] ne -1) then ssa_[a] = '-9999.'
   a = where(tauabs_ eq 'N/A')
   if(a[0] ne -1) then tauabs_[a] = '-9999.'
   a = where(angabs_ eq 'N/A')
   if(a[0] ne -1) then angabs_[a] = '-9999.'
   a = where(dvdlnr_ eq 'N/A')
   if(a[0] ne -1) then dvdlnr_[a] = '-9999.'


;  accumulate
   if(nday eq 0) then begin
    date    = date_
    aotw    = float(aotw_)
    water   = float(water_)
    tauext  = float(tauext_)
    tauextf = float(tauextf_)
    tauextc = float(tauextc_)
    tauabs  = float(tauabs_)
    ssa     = float(ssa_)
    angext  = float(angext_)
    angabs  = float(angabs_)
    dvdlnr  = float(dvdlnr_)
   endif else begin
    date    = [date,    date_]
    aotw    = [aotw,    float(aotw_)]
    water   = [water,   float(water_)]
    tauext  = [tauext,  float(tauext_)]
    tauextf = [tauextf, float(tauextf_)]
    tauextc = [tauextc, float(tauextc_)]
    tauabs  = [tauabs,  float(tauabs_)]
    ssa     = [ssa,     float(ssa_)]
    angext  = [angext,  float(angext_)]
    angabs  = [angabs,  float(angabs_)]
    dvdlnr  = [dvdlnr, float(dvdlnr_)]
   endelse
   nday = nday + 1
  endwhile

  free_lun, lun

; Some files evidently have no data in them
  if(nday eq 0) then begin
   rc = 1
   return
  endif

  aotw    = reform(aotw,16,nday)
  tauext  = reform(tauext,4,nday)
  tauextf = reform(tauextf,4,nday)
  tauextc = reform(tauextc,4,nday)
  tauabs  = reform(tauabs,4,nday)
  ssa     = reform(ssa,4,nday)
  dvdlnr  = reform(dvdlnr,22,nday)

end
