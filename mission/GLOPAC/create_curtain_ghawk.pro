; Colarco
; February 4, 2010
; Loop over a set of available flight track files.  Bring out the
; lat/lon/altitude/time from the flight track file.  Extract the
; model parameters along the flight track.

; The code here will (i) find the track files, (ii) read the track
; files, and then (iii) call the extraction code.

;  fcast = '2010042812'
; if your forecast doesn't cover the desired flight, set maxdate inside the forecast
;  maxdate = 20100421.75d
; else
  maxdate = 21000101.00d 

; This method used the flight plan tracks
; Track files location
  track = 'b1.6_04_23'
  trackfiles = './output/tracks/glopac_'+track+'_path_pfister.txt'
  nfiles = n_elements(trackfiles)

; This method uses the "fake" exchange file format actual flight path
  track = '20100423'
  datadir = '/science/missions/exchange/data/incoming/glopac/data/ghawk/'
  nfiles = 1

; Loop over the individual trackfiles
  for ifiles = 0, nfiles-1 do begin
;   Flight plans
;   read_ghawk_track, trackfiles[ifiles], tracklon, tracklat, trackalt, trackdates
;   Exchange format actuals
    get_ghawk_navtrack, datadir, track, tracklon, tracklat, trackalt, trackprs, trackdates

    datestr = strcompress(string(trackdates[0],format='(i8)'),/rem)
    outfile = './output/data/glopac.fcast.chm.'+track+'_dust.v'+datestr+'.asm.nc'
    model_track, outfile, tracklon, tracklat, trackalt, trackdates, maxdate=maxdate
;    outfile = './output/data/glopac.fcast.met.'+track+'.v'+datestr+'.asm.nc'
;    model_track_met, outfile, tracklon, tracklat, trackalt, trackdates, maxdate=maxdate

  endfor

end
