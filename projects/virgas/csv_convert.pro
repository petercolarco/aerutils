; Colarco
; Open a csvfile provided by VIRGAS group and convert to something I
; can use in trj_sampler.py

; Open and parse file
  fileinp = 'virgas_20151022.csv'
  openr, lun, fileinp, /get
; count line
  i = 0
  str = 'a'
  while(not(eof(lun))) do begin
   readf, lun, str
   i = i+1
  endwhile
; reopen file and extract data
  free_lun, lun
  openr, lun, fileinp, /get
; get header line
  readf, lun, str
  data = fltarr(i-1,5)   ; 5 columns
  for j = 0, i-2 do begin
   readf, lun, str
   data[j,*] = float(strsplit(str,',',/extract))
  endfor
  free_lun, lun

; Now let's massage
  utc = data[*,0]
  yyyymmdd = strmid(fileinp,7,8)
  datehead = strmid(fileinp,7,4)+'-'+strmid(fileinp,11,2)+'-'+$
             strmid(fileinp,13,2)+'T'
  hh = strpad(utc/86400.*24,10)
  mm = strpad((utc-hh*3600.)/60,10)
  nn = strpad(utc-hh*3600.-mm*60.,10)
  datestr = datehead+hh+':'+mm+':'+nn

  dataout = strarr(i-1)
  for j = 0, i-2 do begin
   dataout[j] = strcompress(string(data[j,2]),/rem)+','+$
                strcompress(string(data[j,1]),/rem)+','+$
                datestr[j]
  endfor

; write an output file
  openw, lun, 'csvfile.'+fileinp, /get
  printf, lun, 'lon,lat,time'
  for j = 0, i-2 do begin
   printf, lun, dataout[j]
  endfor
  free_lun, lun

end
