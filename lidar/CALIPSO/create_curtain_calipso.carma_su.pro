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
  lambda = ['355','532','1064']
  for ifiles = 0, nfiles-1 do begin
   read_calipso_track, trackfiles[ifiles], lon, lat, date, mbl=3

   for ilam = 0, 2 do begin

   date0 = double('20090715')

   for id = 1,1 do begin
    date1 = double(incstrdate(date0*100.d0,24)/100L)
    a = where(date ge date0 and date lt date1)
    tracklon   = lon[a]
    tracklat   = lat[a]
    trackdates = date[a]

    datestr = strcompress(string(trackdates[0],format='(i8)'),/rem)
    outfile = './output/data/carma_su/dR_MERRA-AA-r2.calipso_'+lambda[ilam]+'nm-carma_su.'+datestr+'.nc'
    model_track, outfile, tracklon, tracklat, trackdates, $
                 vartable='calipso_'+lambda[ilam]+'nm_table.carma_su.txt'
    date0 = date1
   endfor

   endfor

  endfor

end
