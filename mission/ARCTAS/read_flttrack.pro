 filename = "d5_arctas_02.dc8.20080401.nc"
 cdfid = ncdf_open(filename)
  id = ncdf_varid(cdfid,'longitude')
  ncdf_varget, cdfid, id, lon
  id = ncdf_varid(cdfid,'latitude')
  ncdf_varget, cdfid, id, lat
  id = ncdf_varid(cdfid,'time')
  ncdf_varget, cdfid, id, time
  id = ncdf_varid(cdfid,'totext')
  ncdf_varget, cdfid, id, totext
  id = ncdf_varid(cdfid,'HGHT')
  ncdf_varget, cdfid, id, hght
 ncdf_close, cdfid

; plot the track
  window, 0
  map_set, /cont, limit=[20,-180,90,-100], title='flight_track'
  plots, lon, lat, thick=6

; plot the extinction profile
  window, 1
  plot, time, hght[0,*]/1000, /nodata, $
   xtitle='time [yyyymmdd.fraction]', ytitle='mid-layer height [km]', $
   title='extinction profile [532 nm, km-1]', yrange=[0,20]
  contour, transpose(totext), time, hght[*,0]/1000., /overplot

end
