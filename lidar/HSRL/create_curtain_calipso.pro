; Colarco
; February 4, 2010
; Loop over a set of available flight track files.  Bring out the
; lat/lon/altitude/time from the flight track file.  Extract the
; model parameters along the flight track.

; The code here will (i) find the track files, (ii) read the track
; files, and then (iii) call the extraction code.

; Get the HSRL points
  openr, lun, 'hsrl_coords.txt', /get
  i = 0
  while(not(eof(lun))) do begin
   readf, lun, lon_, lat_
   if(i eq 0) then begin
    lon = lon_
    lat = lat_
   endif else begin
    lon = [lon,lon_]
    lat = [lat,lat_]
   endelse
   i = i+ 1
  endwhile
  free_lun, lun

  tracklon = lon
  tracklat = lat
  trackdates = lon
  trackdates[*] = 20110705.d + 15.d/24.

  nfiles = 1

; Loop over the individual trackfiles
  for ifiles = 0, nfiles-1 do begin

   date0 = double('20110705')
   for id = 1,1 do begin
    date1 = double(incstrdate(date0*100.d0,24)/100L)

    datestr = strcompress(string(trackdates[0],format='(i8)'),/rem)
    outfile = './e572_fp.hsrl_532nm.'+datestr+'.nc'
    model_track, outfile, tracklon, tracklat, trackdates, $
                 vartable='hsrl_532nm_table.txt'
    date0 = date1
   endfor

  endfor

end
