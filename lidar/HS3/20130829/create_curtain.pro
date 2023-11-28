; Colarco
; February 4, 2010
; Loop over a set of available flight track files.  Bring out the
; lat/lon/altitude/time from the flight track file.  Extract the
; model parameters along the flight track.

; The code here will (i) find the track files, (ii) read the track
; files, and then (iii) call the extraction code.

; Loop over the individual trackfiles
  trackfiles = 'gh.track.8.29.30.txt'
  read_calipso_track, trackfiles, lon, lat, date, mbl=1
  npts = n_elements(lon)-1
  lon  = lon[0:npts:10]
  lat  = lat[0:npts:10]
  date = date[0:npts:10]

  datestr = strpad(long(date[0]),10000000L)
  outfile = './e5110_fp.'+datestr+'.nc'
  model_track, outfile, lon, lat, date, $
               vartable='calipso_532nm_table.txt'

end
