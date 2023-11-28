; Corrected AI

; Plot from the OMI granule

  set_plot, 'ps'
  device, file='aod.ps', xsize=16, ysize=8, xoff=.5, yoff=.5, /color
  loadct, 39
  !p.font=0
  !p.multi=[0,2,1]



; This is the AI I stuffed into OMI granule (only at 388 nm)

  filename = './OMI-Aura_L2-OMAERUV_2007m0605t1407-o15368_v003-2015m0918t203128.vl_rad.geos5_pressure.he5'
  file_id = h5f_open(filename)
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/MERRAero_AOT')
  ai      = h5d_read(var_id)
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/Longitude')
  lon     = h5d_read(var_id)
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/Latitude')
  lat     = h5d_read(var_id)
  h5f_close, file_id
  ai = reform(ai[1,*,*])

; Set max at 1
  ai[where(ai gt 1)] = 1.

  map_set, /cont, /noerase, title='Pete'
  for ix = 0, 59 do begin
   for iy = 0, 1643 do begin
    if(ai[ix,iy] gt 0) then begin
     val = ai[ix,iy]
     color = fix(val*254.)
     plots, lon[ix,iy], lat[ix,iy], color=color, psym=3
    endif
   endfor
  endfor

  labels = make_array(255,val=' ')
  for i = 0, 10 do begin
   labels[i*25] = string(i*.1,format='(f4.2)')
  endfor
  makekey, .05, .1, .4, .05, 0, -.035, $
   charsize=.5, align=0, $
   colors=findgen(255), labels=labels, /noborder



; Now get the AI that Santiago returned to me
  filename = './2007m0605-o15368_PGEOSS_Nov102015.nc'
  cdfid = ncdf_open(filename)
  id    = ncdf_varid(cdfid,'AOD388')
  ncdf_varget, cdfid, id, ai_inp
  ncdf_close, cdfid
; Put onto same grid as below will have...Santiago gives 60x1201
  ai_return = make_array(60,1644,val=min(ai_inp))
  ai_return[*,199:1399] = ai_inp


  map_set, /cont, /noerase, title='Santiago'
  for ix = 0, 59 do begin
   for iy = 0, 1643 do begin
    if(ai_return[ix,iy] gt 0) then begin
     val = ai_return[ix,iy]
     val = min([val,1])
     color = fix(val*254.)
     if(color gt 253) then color=0
     plots, lon[ix,iy], lat[ix,iy], color=color, psym=3
    endif
   endfor
  endfor

  device, /close


end