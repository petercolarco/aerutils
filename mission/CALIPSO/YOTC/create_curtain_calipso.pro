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

; Loop over the individual trackfiles
  for ifiles = 0, nfiles-1 do begin
   read_calipso_track, trackfiles[ifiles], lon, lat, date, mbl=3

   for id = 1, 3 do begin
    date0 = 20090701.0d + double(id)
    date1 = date0 + 1.d
    a = where(date ge date0 and date lt date1)
    tracklon   = lon[a]
    tracklat   = lat[a]
    trackdates = date[a]

    datestr = strcompress(string(trackdates[0],format='(i8)'),/rem)
    outfile = '../output/data/e530_yotc_01.calipso.532nm.'+datestr+'.nc'
    model_track, outfile, tracklon, tracklat, trackdates
   endfor

  endfor

end
