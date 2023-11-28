; Plot from the OMI granule

  set_plot, 'ps'
  device, file='albedo.ps', xsize=24, ysize=8, xoff=.5, yoff=.5, /color
  loadct, 39
  !p.font=0
  !p.multi=[0,3,1]



; This is the LER I stuffed into OMI granule (only at 388 nm)

  filename = './OMI-Aura_L2-OMAERUV_2007m0605t1407-o15368_v003-2014m1202t172538.vl_rad.geos5_pressure.he5'
  file_id = h5f_open(filename)
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/SurfaceAlbedo')
  albedo  = h5d_read(var_id)
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/Longitude')
  lon     = h5d_read(var_id)
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/Latitude')
  lat     = h5d_read(var_id)
  h5f_close, file_id

  map_set, /cont, /noerase, title='OMI Albedo 354 nm'
  for ix = 0, 59 do begin
   for iy = 0, 1643 do begin
    if(albedo[0,ix,iy] gt 0) then begin
     val = albedo[0,ix,iy]
     color = fix(val*254+.5)    ; Max albedo ~ 1 so this scales to color max 254.
     plots, lon[ix,iy], lat[ix,iy], color=color, psym=3
    endif
   endfor
  endfor
  labels = make_array(255,val=' ')
  for i = 0, 10 do begin
   labels[i*25] = string(i*.04,format='(f4.2)')
  endfor
  makekey, .03, .1, .27, .05, 0, -.035, $
   charsize=.5, align=0, $
   colors=findgen(255), labels=labels, /noborder
  tmp = albedo[0,*,*]
  a = where(tmp lt 0)
  loadct, 0
  if(a[0] ne -1) then plots, lon[a], lat[a], psym=3, color=120
  loadct, 39


  !p.multi=[2,3,1]
  map_set, /cont, /noerase, title='OMI Albedo 388 nm'
  for ix = 0, 59 do begin
   for iy = 0, 1643 do begin
    if(albedo[1,ix,iy] gt 0) then begin
     val = albedo[1,ix,iy]
     color = fix(val*254+.5)    ; Max albedo ~ 1 so this scales to color max 254.
     plots, lon[ix,iy], lat[ix,iy], color=color, psym=3
    endif
   endfor
  endfor
  tmp = albedo[1,*,*]
  a = where(tmp lt 0)
  loadct, 0
  if(a[0] ne -1) then plots, lon[a], lat[a], psym=3, color=120
  loadct, 39


  !p.multi=[1,3,1]
  map_set, /cont, /noerase, title='OMI Albedo 471 nm'
  for ix = 0, 59 do begin
   for iy = 0, 1643 do begin
    if(albedo[2,ix,iy] gt 0) then begin
     val = albedo[2,ix,iy]
     color = fix(val*254+.5)    ; Max albedo ~ 1 so this scales to color max 254.
     plots, lon[ix,iy], lat[ix,iy], color=color, psym=3
    endif
   endfor
  endfor
  tmp = albedo[2,*,*]
  a = where(tmp lt 0)
  loadct, 0
  if(a[0] ne -1) then plots, lon[a], lat[a], psym=3, color=120
  loadct, 39

  device, /close

end
