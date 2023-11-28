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

   date0 = double('20070720')
   for id = 1, 1 do begin
    date1 = double(incstrdate(date0*100.d0,24)/100L)
    a = where(date ge date0 and date lt date1)
    tracklon   = lon[a]
    tracklat   = lat[a]
    trackdates = date[a]

    datestr = strcompress(string(trackdates[0],format='(i8)'),/rem)
    outfile = './output/data/d_rep_21.calipso_532nm.'+datestr+'.nc'
    model_track, outfile, tracklon, tracklat, trackdates, $
                 vartable='calipso_532nm_table.txt'
    date0 = date1
   endfor

  endfor

end
