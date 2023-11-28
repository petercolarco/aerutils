; Colarco, January 2015
; Extract at lidar site

; Profile location
  nt = 96
  tracklon = make_array(nt,val=-105.08)
  tracklat = make_array(nt,val=40.58)
  trackdates = 20140717.0d + dindgen(nt)*1./24.d

  datestr = strcompress(string(trackdates[0],format='(i8)'),/rem)
  outfile = './output/data/MERRA2.mpl_ft_collins.'+datestr+'.nc'
  model_track, outfile, tracklon, tracklat, trackdates, $
               vartable='mpl_table.txt'

end
