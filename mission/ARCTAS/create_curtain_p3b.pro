; Colarco
; February 4, 2010
; Loop over a set of available flight track files.  Bring out the
; lat/lon/altitude/time from the flight track file.  Extract the
; model parameters along the flight track.

; The code here will (i) find the track files, (ii) read the track
; files, and then (iii) call the extraction code.

; Track files location
  trackdir = '/home/liang/DATA/ARCTAS/merge/'
  trackfiles = trackdir + ['mrg60_p3b_20080331_R1_thru20080419.ict', $
                           'mrg60_p3b_20080622_R1_thru20080626.ict', $
                           'mrg60_p3b_20080628_R1_thru20080712.ict']
  nfiles = n_elements(trackfiles)

; Loop over the individual trackfiles
  for ifiles = 0, nfiles-1 do begin
   read_dc8_track, trackfiles[ifiles], lon, lat, alt, date, flights

;  Possibly the file contains multiple flights, so loop over individual flights
   flightnums = flights[uniq(flights)]
   nflights = n_elements(flightnums)
   for iflights = 0, nflights-1 do begin
    a = where(flights eq flightnums[iflights])
    tracklon   = lon[a]
    tracklat   = lat[a]
    trackdates = date[a]

    datestr = strcompress(string(trackdates[0],format='(i8)'),/rem)
    outfile = './output/data/dR_arctas.p3b.'+datestr+'.nc'
    model_track, outfile, tracklon, tracklat, trackdates, vartable='arctas_532nm_table.txt'
   endfor
  endfor

end
