; Colarco, August 1, 2011
; Read an example of the SOCRATES orbit file
; This is a bit confusing.  There are 10 satellites in the file.  You
; can separate them by the time string, which repeats (although not on
; a uniform cycle).  Each satellite has a series of lat and lon
; points, which alternate between the sunrise and sunset observation.
; So think that each satellite should be subdivided into two series,
; one for sunrise and one for sunset.

; The starting EPOCH for this data set is July 16 (arbitrary year).
; Put in terms of day.fraction (as with others)

  pro read_socrates, time, lon, lat

  openr, lun, 'Configuration8.txt', /get
  header = 'a'
  readf, lun, header

  npoints=long(298909)
  d = fltarr(4)
  time_ = FltArr(npoints)
  lat_  = FltArr(npoints)
  lon_  = FltArr(npoints)

  for ipoint=long(0),npoints-1 do begin
    readf, lun, d
    time_(ipoint) = d(0)
    lat_(ipoint)  = d(1)
    lon_(ipoint)  = d(2)
  endfor

  free_lun, lun

; There are 10 satellites.  Now find the indices which separate them.
  startindex = make_array(10,val=0L)
  startindex[0] = 0L
  numindex   = make_array(10,val=0L)
  ntimes = n_elements(time_)
  a =where((time_[1L:ntimes-1] - time_[0L:ntimes-2]) lt 0)
  startindex[1:9] = a+1
  numindex[0:8] = startindex[1:9]-startindex[0:8]
  numindex[9]   = ntimes-startindex[9]-1

  time = make_array(max(numindex+1),10,val=!values.f_nan)
  lon  = make_array(max(numindex+1),10,val=!values.f_nan)
  lat  = make_array(max(numindex+1),10,val=!values.f_nan)

  for isat = 0, 9 do begin
   time[0:numindex[isat]-1,isat] = time_[startindex[isat]:startindex[isat] + $
                                                          numindex[isat]-1]
   lon[0:numindex[isat]-1,isat]  = lon_[startindex[isat]:startindex[isat] + $
                                                         numindex[isat]-1]
   lat[0:numindex[isat]-1,isat]  = lat_[startindex[isat]:startindex[isat] + $
                                                         numindex[isat]-1]
  endfor

; Sort sunrise, sunset
  time = reform(time,2,max(numindex+1)/2,10)
  lon  = reform(lon,2,max(numindex+1)/2,10)
  lat  = reform(lat,2,max(numindex+1)/2,10)

; Munge the dates up to YYYYMMDD.fraction (double precision)
  jday0 = julday(07,16,2008,0,0,0)
  jday  = jday0+time
  caldat, jday, mm, dd, yyyy, hh, nn
  time  = yyyy*10000.d + mm*100.d + dd*1.d + (hh*3600.+nn*60.)/86400.d
  a = where(finite(jday) eq 0)
  time[a] = !values.f_nan

end
