; Colarco
; February 4, 2010
; Loop over a set of available flight track files.  Bring out the
; lat/lon/altitude/time from the flight track file.  Extract the
; model parameters along the flight track.

; The code here will (i) find the track files, (ii) read the track
; files, and then (iii) call the extraction code.

; Track files location
  trackfiles = '/misc/prc08/calipso/CALIPSO_Orbit_Track_2009.cdf'
  nfiles = n_elements(trackfiles)

  date0 = 20090812.0d

; Loop over the individual trackfiles
  for ifiles = 0, nfiles-1 do begin
   read_calipso_track, trackfiles[ifiles], lon, lat, date, mbl=3

   for id = 0, 140 do begin
    yyyy  = long( date0/10000.)
    mm    = long((date0 - yyyy*10000.)/100.)
    dd    = long( date0 - yyyy*10000. - mm*100.)
;   next day
    jday  = julday(mm,dd,yyyy) + 1
    caldat, jday, mm, dd, yyyy
    date1 = yyyy*10000.d + mm*100.d + dd

    a = where(date ge date0 and date lt date1)
    tracklon   = lon[a]
    tracklat   = lat[a]
    trackdates = date[a]

    datestr = strcompress(string(trackdates[0],format='(i8)'),/rem)
    outfile = '/misc/prc13/dao_ops/e530_yotc_01/Y2009/e530_yotc_01.calipso.1064nm.'+datestr+'.nc'
    model_track, outfile, tracklon, tracklat, trackdates, lambda='1064'
    date0 = date1
   endfor

  endfor

end
