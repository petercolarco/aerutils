; Read the AERONET monthly file
; Works by passing in a filename (full path)
; All other variables are parsed and returned from the file

; The data file layout is 4 rows for each month
; 1) means from daily averages
; 2) means from weighted averages
; 3) number of days included
; 4) number of obs included

  pro read_aeronet_inversions_monthly, filename, $
                                       location, lon, lat, elev, nmeas, pi, pi_email, $
                                       date, aotw, water, $
                                       tauext, tauextf, tauextc, angext, $
                                       ssa, tauabs, angabs, ndays, naot, ninv, dvdlnr

  mon = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', $
         'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC']
  mmdd = ['0115', '0215', '0315', '0415', '0515', '0615', $
          '0715', '0815', '0915', '1015', '1115', '1215']

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

  nmon = 0
  while(not eof(lun)) do begin

;  Read the 4 lines of data
   for il = 1, 4 do begin
    readf, lun, strdata
    dataline = strsplit(strdata, ',' , /extract)
    strdate = dataline[0]
    datespl = strsplit(strdate,'-', /extract)

;   If first line (mean from daily averages) discard
    if(il eq 1) then continue
;   We assume the first entry in each of the following is constant across
    if(il eq 3) then begin
     ndays_ = dataline[2]
     continue
    endif
    if(il eq 4) then begin
     naot_  = dataline[2]
     ninv_  = dataline[32]
     continue
    endif

;   We only hit this point if il = 2 in this case (weighted means)
    imon = where(datespl[1] eq mon)
    date_    = long(datespl[0]*1000000L)+long(mmdd[imon]*100L)+12
    aotw_    = dataline[2:17]
    water_   = dataline[18]
    tauext_  = dataline[19:22]
    tauextf_ = dataline[23:26]
    tauextc_ = dataline[27:30]
    angext_  = dataline[31]
    ssa_     = dataline[32:35]
    tauabs_  = dataline[36:39]
    angabs_  = dataline[40]
    dvdlnr_  = dataline[61:82]
   endfor

;  Have now parsed the data

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
   a = where(ndays_ eq 'N/A')
   if(a[0] ne -1) then ndays_[a] = '-9999'
   a = where(naot_ eq 'N/A')
   if(a[0] ne -1) then naot_[a] = '-9999'
   a = where(ninv_ eq 'N/A')
   if(a[0] ne -1) then ninv_[a] = '-9999'

;  accumulate
   if(nmon eq 0) then begin
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
    ndays   = fix(ndays_)
    naot    = fix(naot_)
    ninv    = fix(ninv_)
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
    dvdlnr  = [dvdlnr,  float(dvdlnr_)]
    ndays   = [ndays,   fix(ndays_)]
    naot    = [naot,    fix(naot_)]
    ninv    = [ninv,    fix(ninv_)]
   endelse
   nmon = nmon + 1
  endwhile

  free_lun, lun

  aotw    = reform(aotw,16,nmon)
  tauext  = reform(tauext,4,nmon)
  tauextf = reform(tauextf,4,nmon)
  tauextc = reform(tauextc,4,nmon)
  tauabs  = reform(tauabs,4,nmon)
  ssa     = reform(ssa,4,nmon)
  dvdlnr  = reform(dvdlnr,22,nmon)

end
