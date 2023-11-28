; Plot from the OMI granule

  set_plot, 'ps'
  device, file='residue.ps', xsize=16, ysize=8, xoff=.5, yoff=.5, /color
  loadct, 39
  !p.font=0
  !p.multi=[0,2,1]



; This is the AI I stuffed into OMI granule (only at 388 nm)

  filename = './OMI-Aura_L2-OMAERUV_2007m0605t1407-o15368_v003-2015m0918t203128.vl_rad.geos5_pressure.he5'
  file_id = h5f_open(filename)
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/Residue')
  ai      = h5d_read(var_id)
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/Longitude')
  lon     = h5d_read(var_id)
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/Latitude')
  lat     = h5d_read(var_id)
  h5f_close, file_id

  map_set, /cont, /noerase, title='Pete - Uncorrected AI > 0'
  for ix = 0, 59 do begin
   for iy = 0, 1643 do begin
    if(ai[ix,iy] gt 0) then begin
     val = ai[ix,iy]
     color = fix(val*100+.5)    ; Max AI ~ 2.53 so this scales to color max 254.
     plots, lon[ix,iy], lat[ix,iy], color=color, psym=3
    endif
   endfor
  endfor

  labels = make_array(255,val=' ')
  for i = 0, 10 do begin
   labels[i*25] = string(i*.25,format='(f4.2)')
  endfor
  makekey, .05, .1, .4, .05, 0, -.035, $
   charsize=.5, align=0, $
   colors=findgen(255), labels=labels, /noborder



; Now get the AI that Santiago returned to me
  filename = './2007m0605-o15368_julian156.nc'
  cdfid = ncdf_open(filename)
  id    = ncdf_varid(cdfid,'RESIDUE')
  ncdf_varget, cdfid, id, ai_inp
  ncdf_close, cdfid
; Put onto same grid as below will have...Santiago gives 60x1201
  ai_return = make_array(60,1644,val=min(ai_inp))
  ai_return[*,199:1399] = ai_inp


  map_set, /cont, /noerase, title='Santiago - Uncorrected AI > 0'
  for ix = 0, 59 do begin
   for iy = 0, 1643 do begin
    if(ai_return[ix,iy] gt 0) then begin
     val = ai_return[ix,iy]
     color = fix(val*100+.5)    ; Max AI is ~ 2.53 so this scales to color max 254.
     if(color gt 253) then color=0
     plots, lon[ix,iy], lat[ix,iy], color=color, psym=3
    endif
   endfor
  endfor

  device, /close

; Now create a scatter plot
  set_plot, 'ps'
  device, file='residue.scatter.ps', xsize=16, ysize=8, xoff=.5, yoff=.5, /color
  loadct, 39
  !p.font=0
  !p.multi=[0,2,1]

  plot, findgen(2), xrange=[0,3], yrange=[0,3], $
   xtitle = 'Pete', ytitle = 'Santiago', title='AI'
  a = where(ai gt 0 and ai_return gt 0)
  plots, ai[a], ai_return[a], psym=3

  plot, ai[a]-ai_return[a], /nodata, $
   title='Pete - Santiago AI diff'
  plots, dindgen(n_elements(a)), ai[a]-ai_return[a], psym=3
  device, /close




end
