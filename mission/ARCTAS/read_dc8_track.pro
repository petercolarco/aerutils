; Colarco, February 2010
; Read the ARCTAS DC-8 merge files
; Uses readmerge.pro and missdata.pro provided by Qing Liang

  pro read_dc8_track, trackfile, lon, lat, altp, date, flight

  readmerge, trackfile, datainp, names, units, ncol, ndat, vmiss

  utime  = datainp[*,0]
  utc    = datainp[*,1]
  jday_  = datainp[*,2]
  lat    = datainp[*,6]
  lon    = datainp[*,7]
  flight = datainp[*,4]
  altp   = datainp[*,8]*1000.   ; pressure altitude put into meters

; Construct the date, assuming base year of 2007
; date is in form YYYYMMDD.fraction of day from 0Z
  jday = julday(12,31,2007,0,0,0) + utime
  caldat, jday, mm, dd, yyyy, hh, nn, ss
  date = yyyy*10000.d0 + mm*100.d0 + dd*1.d0 + (utime-fix(utime))*1.d0

  end
