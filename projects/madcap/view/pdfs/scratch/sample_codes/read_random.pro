  pro read_random, file, lon, lat, $
                   vza, sza, vaa, saa, scat, $
                   date, time

  openr, lun, file, /get
  readf, lun, n, na
  lon = fltarr(n)
  lat = fltarr(n)
  vza = fltarr(na,n)
  sza = fltarr(na,n)
  vaa = fltarr(na,n)
  saa = fltarr(na,n)
  scat = fltarr(na,n)
  time = fltarr(na,n)
  date = strarr(n)
  str = 'a'
  for i = 0, n-1 do begin
   for j = 0, na-1 do begin
    readf, lun, str
    str_      = strsplit(str,',',/extract)
    lon[i]    = float(str_[0])
    lat[i]    = float(str_[1])
    date[i]   = str_[2]
    time[j,i] = float(str_[3])
    vza[j,i]  = float(str_[4])
    sza[j,i]  = float(str_[5])
    vaa[j,i]  = float(str_[6])
    saa[j,i]  = float(str_[7])
    scat[j,i] = float(str_[8])
   endfor
  endfor
  free_lun, lun

end
