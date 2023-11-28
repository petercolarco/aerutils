; Colarco
; February 4, 2010
; Loop over a set of available flight track files.  Bring out the
; lat/lon/altitude/time from the flight track file.  Extract the
; model parameters along the flight track.

; The code here will (i) find the track files, (ii) read the track
; files, and then (iii) call the extraction code.

  lon0   = -43.
  lat0   = 17.
  angle  = 60.
  ttime  = 10.    ; hours
  ntime  = 3600   ; ttime/ntime = dtime (10 sec)
  deltax = 1.5    ; degrees of spacing

; Loop over the individual trackfiles
  for ifiles = 0, 0 do begin
   race_track, lon0, lat0, deltax, angle, ttime, ntime, $
               lon, lat, time

   date0 = double('20120906')
   for id = 1,1 do begin
    date1 = double(incstrdate(date0*100.d0,24)/100L)
    tracklon   = lon
    tracklat   = lat
    trackdates = date0 + .25 + time/24.

    datestr = strcompress(string(trackdates[0],format='(i8)'),/rem)
    outfile = './e572p5_fp.race_track_532nm.1_5deg.rot_e60.'+datestr+'.nc'
    model_track, outfile, tracklon, tracklat, trackdates, $
                 vartable='calipso_532nm_table.txt'
    date0 = date1
   endfor

  endfor

end
