; Read the AERONET monthly file
; Works by passing in a filename (full path)
; All other variables are parsed and returned from the file
  pro read_aeronet_monthly, filename, $
                            location, lon, lat, elev, nmeas, pi, pi_email, $
                            date, aotm, aotw, ndays, nobs

  mon = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', $
         'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC']
  mmdd = ['0115', '0215', '0315', '0415', '0515', '0615', $
          '0715', '0815', '0915', '1015', '1115', '1215']

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

  nmon = 0
  while(not eof(lun)) do begin
   readf, lun, strdata
   dataline = strsplit(strdata, ',' , /extract)
   strdate = dataline[0]
   datespl = strsplit(strdate,'-', /extract)
   imon = where(datespl[1] eq mon)
   date_  = long(datespl[0]*1000000L)+long(mmdd[imon]*100L)+12
   aotm_  = dataline[1:17]
   aotw_  = dataline[18:34]
   ndays_ = dataline[35:51]
   nobs_  = dataline[52:68]

;  replace missing/no data with flag
   a = where(aotm_ eq 'N/A')
   if(a[0] ne -1) then aotm_[a] = '-9999.'
   a = where(aotw_ eq 'N/A')
   if(a[0] ne -1) then aotw_[a] = '-9999.'
   a = where(ndays_ eq 'N/A')
   if(a[0] ne -1) then ndays_[a] = '-9999'
   a = where(nobs_ eq 'N/A')
   if(a[0] ne -1) then nobs_[a] = '-9999'

;  accumulate
   if(nmon eq 0) then begin
    date = date_
    aotm = float(aotm_)
    aotw = float(aotw_)
    ndays = fix(ndays_)
    nobs = fix(nobs_)
   endif else begin
    date = [date, date_]
    aotm = [aotm, float(aotm_)]
    aotw = [aotw, float(aotw_)]
    ndays = [ndays, fix(ndays_)]
    nobs = [nobs, fix(nobs_)]
   endelse
   nmon = nmon + 1
  endwhile

  free_lun, lun

  aotm = reform(aotm,17,nmon)
  aotw = reform(aotw,17,nmon)
  ndays = reform(ndays,17,nmon)
  nobs = reform(nobs,17,nmon)


end
