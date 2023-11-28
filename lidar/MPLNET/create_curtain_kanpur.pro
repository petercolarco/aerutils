; Colarco
; February 4, 2010
; Loop over a set of available flight track files.  Bring out the
; lat/lon/altitude/time from the flight track file.  Extract the
; model parameters along the flight track.

; The code here will (i) find the track files, (ii) read the track
; files, and then (iii) call the extraction code.


; Create the track
  deltat = 1./24.   ; fraction of day, 1 hour time resolution
  lon0   = 80.23268
  lat0   = 26.51900
; start day
  jday0  = julday('06','01','2009','0','0','0')
  ndays  = 61
  fday   = 1./deltat
  ntimes = ndays * fday + 1
  lon    = make_array(ntimes,val=lon0)
  lat    = make_array(ntimes,val=lat0)
  date   = make_array(ntimes,/double)
  jdays  = jday0 + findgen(ntimes)*deltat
  caldat,  jdays, mm, dd, yyyy, hh
  date   = double(yyyy*10000.d + mm*100.d + dd + hh/24.d)

  date0 = date[0]
  for id = 0, ndays-1 do begin
    date1 = double(incstrdate(date0*100.d0,24)/100L)
    a = where(date ge date0 and date lt date1)
    tracklon   = lon[a]
    tracklat   = lat[a]
    trackdates = date[a]
    datestr = strcompress(string(trackdates[0],format='(i8)'),/rem)
    outfile = './output/data/dR_Fortuna-2-4-b4.kanpur_532nm.'+datestr+'.nc'
    model_track, outfile, tracklon, tracklat, trackdates, $
                 vartable='calipso_532nm_table.txt'
    date0 = date1
  endfor

end
