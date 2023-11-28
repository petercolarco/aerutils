; Colarco
; February 4, 2010
; Loop over a set of available flight track files.  Bring out the
; lat/lon/altitude/time from the flight track file.  Extract the
; model parameters along the flight track.

; The code here will (i) find the track files, (ii) read the track
; files, and then (iii) call the extraction code.

; Get the GLAS track from the file
  openr, lun, 'GLAS_Track_20031009.dat', /get
  str = 'a'
  readf, lun, str
  readf, lun, str
  readf, lun, str
  data = fltarr(9,11591)
  readf, lun, data
  free_lun, lun

  tracklon   = reform(data[8,*])
  tracklat   = reform(data[7,*])
  hh         = reform(data[4,*])
  nn         = reform(data[5,*])
  ss         = reform(data[6,*])
  frac       = (hh*3600.d + nn*60.d + ss)/86400.d
  trackdates = 20031009.d + frac

  datestr = strcompress(string(trackdates[0],format='(i8)'),/rem)
  outfile = './output/data/dR_Fortuna-M-1-1.glas_532nm.'+datestr+'.nc'
  model_track, outfile, tracklon, tracklat, trackdates, $
               vartable='glas_532nm_table.txt'

end
