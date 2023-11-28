; Colarco
; February 4, 2010
; Loop over a set of available flight track files.  Bring out the
; lat/lon/altitude/time from the flight track file.  Extract the
; model parameters along the flight track.

; The code here will (i) find the track files, (ii) read the track
; files, and then (iii) call the extraction code.

; Track files location
  trackfiles = '/misc/prc08/calipso/MBL_STK_Orbit_Tracks_Jul07/nadir.txt'
  nfiles = n_elements(trackfiles)

; Loop over the individual trackfiles
  for ifiles = 0, nfiles-1 do begin
   read_calipso_track, trackfiles[ifiles], lon, lat, date, mbl=2

   for id = 1, 21 do begin
    date0 = 20070712.0d + double(id)-1.d
    date1 = date0 + 1.d
    a = where(date ge date0 and date lt date1)
    tracklon   = lon[a]
    tracklat   = lat[a]
    trackdates = date[a]

    datestr = strcompress(string(trackdates[0],format='(i8)'),/rem)
    outfile = '../output/data/tc4.calipso.'+datestr+'.nc'
    model_track, outfile, tracklon, tracklat, trackdates
   endfor

  endfor

end
