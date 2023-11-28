; Read the AERONET monthly file
; Works by passing in a filename (full path)
; All other variables are parsed and returned from the file
  pro read_aeronet_monthly_v3, filename, $
                               location, lon, lat, elev, nmeas, pi, pi_email, $
                               date, aotm, ndays, nobs, angm, ndang, nobsang

  mon = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', $
         'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC']
  mmdd = ['0115', '0215', '0315', '0415', '0515', '0615', $
          '0715', '0815', '0915', '1015', '1115', '1215']

  openr, lun, filename, /get_lun
  strheader = strarr(7)
  strdata   = 'a'
  readf, lun, strheader

; parse out of the header the desired output
  location = strcompress(strheader[1],/rem)
  header   = strsplit(strheader(4), ';', /extract)
  pi       = strcompress(strmid(header[0],strpos(header[0],'=')+1),/rem)
  pi_email = strcompress(strmid(header[1],strpos(header[1],'=')+1),/rem)

  nmon = 0

  while(not eof(lun)) do begin
   readf, lun, strdata
   dataline = strsplit(strdata, ',' , /extract)
   strdate = dataline[0]
   datespl = strsplit(strdate,'-', /extract)
   imon = where(datespl[1] eq mon)
   date_  = long(datespl[0]*1000000L)+long(mmdd[imon]*100L)+12
   aotm_  = dataline[1:22]
   angm_  = dataline[31:36]
   ndays_ = dataline[37:58]
   ndang_ = dataline[67:72]
   nobs_  = dataline[73:94]
   nobsang_ = dataline[103:108]
;  replace missing/no data with flag
   a = where(aotm_ eq 'N/A' or aotm_ lt -990.)
   if(a[0] ne -1) then aotm_[a] = '-9999.'
   a = where(ndays_ eq 'N/A')
   if(a[0] ne -1) then ndays_[a] = '-9999'
   a = where(angm_ eq 'N/A' or angm_ lt -990.)
   if(a[0] ne -1) then angm_[a] = '-9999.'
   a = where(ndang_ eq 'N/A')
   if(a[0] ne -1) then ndang_[a] = '-9999'
   a = where(nobs_ eq 'N/A')
   if(a[0] ne -1) then nobs_[a] = '-9999'
   a = where(nobsang_ eq 'N/A')
   if(a[0] ne -1) then nobsang_[a] = '-9999'

;  accumulate
   if(nmon eq 0) then begin
;   This was a fixed field in V2, now could vary, but here we just
;   assume "0" value is okay
    lon   = float(dataline[111])
    lat   = float(dataline[110])
    elev  = float(dataline[112])
    nmeas = 0.
    date = date_
    aotm = float(aotm_)
    angm = float(angm_)
    ndays = fix(ndays_)
    ndang = fix(ndang_)
    nobs  = fix(nobs_)
    nobsang = fix(nobsang_)
   endif else begin
    date = [date, date_]
    aotm = [aotm, float(aotm_)]
    angm = [angm, float(angm_)]
    ndays = [ndays, fix(ndays_)]
    ndang = [ndang, fix(ndang_)]
    nobs  = [nobs,fix(nobs_)]
    nobsang = [nobsang,fix(nobsang_)]
   endelse
   nmon = nmon + 1
  endwhile

  free_lun, lun

  aotm = reform(aotm,22,nmon)
  angm = reform(angm,6,nmon)
  ndays = reform(ndays,22,nmon)
  ndang = reform(ndang,6,nmon)
  nobs = reform(nobs,22,nmon)
  nobsang = reform(nobsang,6,nmon)


end
