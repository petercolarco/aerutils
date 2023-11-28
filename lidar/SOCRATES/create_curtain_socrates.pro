; Colarco
; February 4, 2010
; Loop over a set of available flight track files.  Bring out the
; lat/lon/altitude/time from the flight track file.  Extract the
; model parameters along the flight track.

; The code here will (i) find the track files, (ii) read the track
; files, and then (iii) call the extraction code.

; Read the SOCRATES orbits
  read_socrates, date_, lon_, lat_

; Transpose above to a different order
  date = transpose(date_,[1,2,0])
  lon  = transpose(lon_,[1,2,0])
  lat  = transpose(lat_,[1,2,0])
  arr  = size(date)
  nt   = arr[1]

; Loop over the dates wanted
  date0 = double('20090101')
  for id = 1,365 do begin
   date1 = double(incstrdate(date0*100.d0,24)/100L)
   a = where(date ge date0 and date lt date1)
   orbit = a/nt + 1  ; index of particular orbit
   tracklon   = lon[a]
   tracklat   = lat[a]
   trackdates = date[a]

;  resort this so they are monotonic
   a = sort(trackdates)
   trackdates = trackdates[a]
   tracklon = tracklon[a]
   tracklat = tracklat[a]
   orbit = orbit[a]

   datestr = strcompress(string(trackdates[0],format='(i8)'),/rem)
   outfile = './output/data/dR_Fortuna-2-4-b4.socrates08.'+datestr+'.nc'
   model_track, outfile, tracklon, tracklat, trackdates, $
                vartable='socrates_table.txt', orbit=orbit
;  skip a day
   date1 = double(incstrdate(date1*100.d0,24)/100L)
   date0 = date1

  endfor

end
