; Corrected AI

; Plot from the OMI granule

  set_plot, 'ps'
  device, file='rad.ps', xsize=16, ysize=8, xoff=.5, yoff=.5, /color
  loadct, 39
  !p.font=0
  !p.multi=[0,2,1]



; This is the AI I stuffed into OMI granule (only at 388 nm)

  filename = './OMI-Aura_L2-OMAERUV_2007m0605t1407-o15368_v003-2015m0918t203128.vl_rad.geos5_pressure.he5'
  file_id = h5f_open(filename)
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/UVAerosolIndex')
  ai      = h5d_read(var_id)
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/Longitude')
  lon     = h5d_read(var_id)
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/Latitude')
  lat     = h5d_read(var_id)
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/NormRadiance')
  rad     = h5d_read(var_id)
  rad     = reform(rad[1,*,*])
  h5f_close, file_id

  filename = '../test_fresnel/OMI-Aura_L2-OMAERUV_2007m0605t1407-o15368_v003-2015m0918t203128.vl_rad.geos5_pressure.he5'
  file_id = h5f_open(filename)
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/NormRadiance')
  rado    = h5d_read(var_id)
  rado    = reform(rado[1,*,*])
  h5f_close, file_id

  map_set, /cont, /noerase, title='Pete - AI > 0'
  for ix = 0, 59 do begin
   for iy = 0, 1643 do begin
    if(rad[ix,iy] gt 0) then begin
     val = rad[ix,iy]
     color = rad[ix,iy]/.1*254
if(color gt 254) then color = 254
     plots, lon[ix,iy], lat[ix,iy], color=color, psym=3
    endif
   endfor
  endfor

  labels = ['0','0.05','0.1']
  makekey, .05, .1, .4, .05, 0, -.035, $
   charsize=.5, align=0, $
   colors=findgen(255), labels=labels, /noborder



; Now get the AI that Santiago returned to me
  map_set, /cont, /noerase, title='Rad diff (old - new)'
  for ix = 0, 59 do begin
   for iy = 0, 1643 do begin
    if(rad[ix,iy] gt 0 and rado[ix,iy] gt 0) then begin
     val = rado[ix,iy]-rad[ix,iy]
     val = val+.02
     color = val/.2*254
     if(color gt 254) then color=0
;    Make "zero" diff obvious
     if(val gt .019 and val lt .021) then color=255
     plots, lon[ix,iy], lat[ix,iy], color=color, psym=3
    endif
   endfor
  endfor

  labels = ['-.02','0','0.02','0.04','0.06','0.08','0.1','0.12','0.14','0.16','0.18','0.2']
  makekey, .55, .1, .4, .05, 0, -.035, $
   charsize=.5, align=0, $
   colors=findgen(255), labels=labels, /noborder

  device, /close

end
