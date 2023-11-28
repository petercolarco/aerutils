; Colarco, April 2011
; Read the daily provided (all sites aggregated) NRT Level 1.5 AERONET AOT

  pro read_aeronet_nrt, filename, site, date, aot, lon, lat

  openr, lun, filename, /get_lun
  strheader = 'a'
  strdata   = 'a'
  readf, lun, strheader

; Get the number of lines
  nobs = 0L
  while(not eof(lun)) do begin
   readf, lun, strdata
   nobs = nobs + 1
  endwhile
  free_lun, lun

; Open and read the data
  openr, lun, filename, /get_lun
  readf, lun, strheader
  strdata = strarr(nobs)
  readf, lun, strdata
  free_lun, lun

; And break it up
  aot  = strarr(16,nobs)
  date = lonarr(nobs)
  site = strarr(nobs)
  lat  = fltarr(nobs)
  lon  = fltarr(nobs)

  for iobs = 0L, nobs-1 do begin
   dataline = strsplit(strdata[iobs], ',' , /extract)
   strdate = dataline[3]
   datespl = strsplit(strdate,':', /extract)
   date_   = long(datespl[2]*10000L)+long(datespl[1]*100L)+long(datespl[0])
   strtime = dataline[4]
   timespl = strsplit(strtime,':', /extract)
   fraction  = (float(timespl[0]) + float(timespl[1])/60. + float(timespl[2])/3600.)/24.
;  resolve time to nearest hour
   datehr_ = long(24*fraction+0.5)
   if(datehr_ ge 24) then begin
    datehr = datehr_-24L
    date_  = long(incstrdate(date_*100L,24L))
   endif
   date[iobs] = date_*100L + datehr_
   aot[*,iobs] = dataline[6:21]
   site[iobs]  = dataline[0]
   lat[iobs]   = dataline[1]
   lon[iobs]   = dataline[2]
;  replace missing/no data with flag
   a = where(aot[*,iobs] eq 'N/A')
   if(a[0] ne -1) then aot[a,iobs] = '-9999.'
  endfor

  aot = float(aot)

; Sort by ascending sitename
  a = sort(site)
  date = date[a]
  site = site[a]
  aot  = aot[*,a]
  lon  = lon[a]
  lat  = lat[a]

end
