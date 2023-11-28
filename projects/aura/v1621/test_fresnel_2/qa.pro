; Corrected AI

; Plot from the OMI granule

  set_plot, 'ps'
  device, file='qa.ps', xsize=16, ysize=8, xoff=.5, yoff=.5, /color
  loadct, 39
  !p.font=0
  !p.multi=[0,2,1]



; This is the AI I stuffed into OMI granule (only at 388 nm)

  filename = './OMI-Aura_L2-OMAERUV_2007m0605t1407-o15368_v003-2015m0918t203128.vl_rad.geos5_pressure.he5'
  file_id = h5f_open(filename)
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/GroundPixelQualityFlags')
  qa      = h5d_read(var_id)
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/Longitude')
  lon     = h5d_read(var_id)
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/Latitude')
  lat     = h5d_read(var_id)
  h5f_close, file_id


  colors = [80,208,128,254,176,0,64,32]

  map_set, /cont, /noerase, title='QA'
  for ix = 0, 59 do begin
   for iy = 0, 1643 do begin
    if(qa[ix,iy] gt 0) then begin
     plots, lon[ix,iy], lat[ix,iy], color=colors[qa[ix,iy]], psym=3
    endif
   endfor
  endfor

  labels = strpad(indgen(8),1)
  makekey, .05, .1, .4, .05, 0, -.035, $
   charsize=.5, align=0, $
   colors=colors, labels=labels, /noborder

  device, /close
end
