; Plot from the OMI granule

  set_plot, 'ps'
  device, file='ps.ps', xsize=16, ysize=8, xoff=.5, yoff=.5, /color
  loadct, 39
  !p.font=0
  !p.multi=[0,2,1]



; This is the AI I stuffed into OMI granule (only at 388 nm)

  filename = './OMI-Aura_L2-OMAERUV_2007m0605t1407-o15368_v003-2015m0918t203128.vl_rad.geos5_pressure.he5'
  file_id = h5f_open(filename)
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/TerrainPressure')
  ps      = h5d_read(var_id)
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/Longitude')
  lon     = h5d_read(var_id)
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/Latitude')
  lat     = h5d_read(var_id)
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/TerrainPressure')
  psin   = h5d_read(var_id)
  h5f_close, file_id

  map_set, /cont, /noerase, title='Pete - Surface Pressure'
  for ix = 0, 59 do begin
   for iy = 0, 1643 do begin
    if(ps[ix,iy] gt 0) then begin
     val = ps[ix,iy]-680. ;; scale down
     color = fix(val*.71+.5)    ; Max scaled PS ~ 360. so this scales to color max 254.
     plots, lon[ix,iy], lat[ix,iy], color=color, psym=3
    endif
   endfor
  endfor

  labels = make_array(255,val=' ')
  for i = 0, 10 do begin
   labels[i*25] = string(680+i*25./.71,format='(i4)')
  endfor
  makekey, .05, .1, .4, .05, 0, -.035, $
   charsize=.5, align=0, $
   colors=findgen(255), labels=labels, /noborder


  map_set, /cont, /noerase, title='Santiago -  Terrain Pressure'
  for ix = 0, 59 do begin
   for iy = 0, 1643 do begin
    if(psin[ix,iy] gt 0) then begin
     val = psin[ix,iy]-680.
     color = fix(val*.71+.5)    ; Max AI is ~ 2.53 so this scales to color max 254.
     if(color gt 253) then color=0
     plots, lon[ix,iy], lat[ix,iy], color=color, psym=3
    endif
   endfor
  endfor

  device, /close

; Now create a scatter plot
  set_plot, 'ps'
  device, file='ps.scatter.ps', xsize=16, ysize=8, xoff=.5, yoff=.5, /color
  loadct, 39
  !p.font=0
  !p.multi=[0,2,1]

  plot, findgen(2), xrange=[680,1040], yrange=[680,1040], $
   xtitle = 'Pete', ytitle = 'Santiago', title='Surface Pressure [hPa]'
  a = where(ps gt 0 and psin gt 0)
  plots, ps[a], psin[a], psym=3

  plot, ps[a]-psin[a], /nodata, $
   title='Pete - Santiago AI diff'
  plots, dindgen(n_elements(a)), ps[a]-psin[a], psym=3
  device, /close




end
