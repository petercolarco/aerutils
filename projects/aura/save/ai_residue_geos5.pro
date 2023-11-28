; Plot the AI residue from GEOS-5

  filename = './OMI-Aura_L2-OMAERUV_2007m0605t1407-o15368_v003-2014m1202t172538.vl_rad.geos5_pressure.he5'
  file_id = h5f_open(filename)
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/Residue')
  ai      = h5d_read(var_id)
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/Longitude')
  lon     = h5d_read(var_id)
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/Latitude')
  lat     = h5d_read(var_id)
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/NormRadiance')
  rad     = h5d_read(var_id)
  h5f_close, file_id

; Make a plot
  set_plot, 'ps'
  device, file='ai_residue_geos5.ps', xsize=12, ysize=16, xoff=.5, yoff=.5, /color
  loadct, 39
  !p.font=0
  !p.multi=[0,1,1]

  map_set, /cont, /noerase, $
           limit=[-50,-100,80,20], /grid, $
           position=[.05,.2,.95,.9], latdel=20,londel=20, /iso
  map_grid, /box, latdel=20,londel=20, charsize=.75

; reduce aod
  a = where(ai lt -1e10)
  ai[a] = !values.f_nan

  a = where(finite(ai) eq 1)
  maxx = max(ai[a])
  minn = min(ai[a])
  maxx = maxx-minn

  for ix = 0, 59 do begin
   for iy = 0, 1643 do begin
    if(finite(ai[ix,iy]) eq 1) then begin
     val = ai[ix,iy]-minn
     color = fix(val*(250/maxx)+.5)    ; Dynamic range is 0.01, so this sets.
     plots, lon[ix,iy], lat[ix,iy], color=color, psym=3
    endif
   endfor
  endfor

  map_continents, thick=6

  labels = make_array(251,val=' ')
  for i = 0, 9 do begin
   labels[i*25] = string((i*25)/250.*maxx+minn,format='(f5.2)')
  endfor
  makekey, .075, .1, .85, .05, 0, -.035, $
   charsize=.75, align=0, $
   colors=findgen(254), labels=labels, /noborder

  xyouts, .5, .95, 'AI', /normal, align=.5
  device, /close

end