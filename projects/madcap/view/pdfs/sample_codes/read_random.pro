; Colarco, May 2020
; Simple IDL reader for reading the random extract text files provided
; from the orbital sampling calculations
; The file has "n" entries and "na" angles per entry, for a total of 
; n * na lines
; Lines have the following fields
;  lon     - longitude
;  lat     - latitude
;  date    - YYYYMMDD_HH00Z of the file the sample comes from
;  time_ss - seconds into the one hour file (above) of the satellite
;            overpass of that lon/lat
;  time    - seconds actual (relative to the "0" time of the file) for
;            the particular view to see the lon/lat point on the track
;  vza     - viewing zenith angle at the ground
;  sza     - solar zenith angle at the ground
;  vaa     - viewing azimuth angle
;  saa     - solar azimuth angle
;  scat    - scattering angle observed

  pro read_random, file, lon, lat, $
                   vza, sza, vaa, saa, scat, $
                   date, time, time_ss

  openr, lun, file, /get
  readf, lun, n, na
  lon     = fltarr(n)
  lat     = fltarr(n)
  vza     = fltarr(na,n)
  sza     = fltarr(na,n)
  vaa     = fltarr(na,n)
  saa     = fltarr(na,n)
  scat    = fltarr(na,n)
  time    = fltarr(n)    ; seconds on input file
  time_ss = fltarr(na,n) ; seconds of particular view
  date    = strarr(n)
  str = 'a'
  for i = 0, n-1 do begin
   for j = 0, na-1 do begin
    readf, lun, str
    str_         = strsplit(str,',',/extract)
    lon[i]       = float(str_[0])
    lat[i]       = float(str_[1])
    date[i]      = str_[2]
    time[i]      = float(str_[3])
    time_ss[j,i] = float(str_[4])
    vza[j,i]     = float(str_[5])
    sza[j,i]     = float(str_[6])
    vaa[j,i]     = float(str_[7])
    saa[j,i]     = float(str_[8])
    scat[j,i]    = float(str_[9])
   endfor
  endfor
  free_lun, lun

end
