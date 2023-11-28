; Colarco, May 2016
; Read from Drew Rollins NC file and create the relevant csv files for
; the sampler

; Open and read file
  cdfid = ncdf_open('VIRGAS_1min.nc')
   id = ncdf_varid(cdfid,'date')
   ncdf_varget, cdfid, id, nymd
   id = ncdf_varid(cdfid,'time')
   ncdf_varget, cdfid, id, ss
   id = ncdf_varid(cdfid,'lat')
   ncdf_varget, cdfid, id, lat
   id = ncdf_varid(cdfid,'lon')
   ncdf_varget, cdfid, id, lon
  ncdf_close, cdfid

; This splits into 4 different flights
  a = where(nymd eq 20151020L)
  b = where(nymd eq 20151022L); or nymd eq 20151023L)
  c = where(nymd eq 20151027L); or nymd eq 20151028L)
  d = where(nymd eq 20151029L); or nymd eq 20151030L)
  e = where(nymd eq 20151030L); or nymd eq 20151030L)

; Create the dates

; Now let's massage
  yyyy = nymd/10000L
  mon  = (nymd-yyyy*10000L)/100L
  dd   = nymd-yyyy*10000L-mon*100L
  datehead = strpad(yyyy,1000)+'-'+strpad(mon,100)+'-'+strpad(dd,100)+'T'
  hh = strpad(ss/86400.*24,10)
  mm = strpad((ss-hh*3600.)/60,10)
  nn = strpad(ss-hh*3600.-mm*60.,10)
  datestr = datehead+hh+':'+mm+':'+nn

  dataout = strarr(n_elements(ss))
  dataout = strcompress(string(lon),/rem)+','+$
            strcompress(string(lat),/rem)+','+$
            datestr

; Write output files
  openw, lun, 'csvfile2.virgas_'+strcompress(string(nymd[a[0]]),/rem)+'.csv', /get
  printf, lun, 'lon,lat,time'
  for j = 0, n_elements(a)-1 do begin
   printf, lun, dataout[a[j]]
  endfor
  free_lun, lun


  openw, lun, 'csvfile2.virgas_'+strcompress(string(nymd[b[0]]),/rem)+'.csv', /get
  printf, lun, 'lon,lat,time'
  for j = 0, n_elements(b)-1 do begin
   printf, lun, dataout[b[j]]
  endfor
  free_lun, lun

  openw, lun, 'csvfile2.virgas_'+strcompress(string(nymd[c[0]]),/rem)+'.csv', /get
  printf, lun, 'lon,lat,time'
  for j = 0, n_elements(c)-1 do begin
   printf, lun, dataout[c[j]]
  endfor
  free_lun, lun

  openw, lun, 'csvfile2.virgas_'+strcompress(string(nymd[d[0]]),/rem)+'.csv', /get
  printf, lun, 'lon,lat,time'
  for j = 0, n_elements(d)-1 do begin
   printf, lun, dataout[d[j]]
  endfor
  free_lun, lun

  openw, lun, 'csvfile2.virgas_'+strcompress(string(nymd[e[0]]),/rem)+'.csv', /get
  printf, lun, 'lon,lat,time'
  for j = 0, n_elements(e)-1 do begin
   printf, lun, dataout[e[j]]
  endfor
  free_lun, lun





end

