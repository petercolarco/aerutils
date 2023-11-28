; Plot from the OMI granule

  set_plot, 'ps'
  device, file='trans.ps', xsize=16, ysize=8, xoff=.5, yoff=.5, /color
  loadct, 39
  !p.font=0
  !p.multi=[0,2,1]



; This is the LER I stuffed into OMI granule (only at 388 nm)

  filename = './OMI-Aura_L2-OMAERUV_2007m0605t1407-o15368_v003-2014m1202t172538.vl_rad.geos5_pressure.he5'
  file_id = h5f_open(filename)
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/Radiance388Calc')
  i388c   = h5d_read(var_id)
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/Transmissivity')
  trans   = h5d_read(var_id)
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/SphericalAlbedo')
  spher   = h5d_read(var_id)
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/Longitude')
  lon     = h5d_read(var_id)
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/Latitude')
  lat     = h5d_read(var_id)
  h5f_close, file_id

  map_set, /cont, /noerase, title='Pete - Transmissivity > 0'
  for ix = 0, 59 do begin
   for iy = 0, 1643 do begin
    if(trans[ix,iy] gt 0) then begin
     val = trans[ix,iy]
     color = fix(val*950+.5)    ; Max LER is ~ 0.26 so this scales to color max 254.
     plots, lon[ix,iy], lat[ix,iy], color=color, psym=3
    endif
   endfor
  endfor

  labels = make_array(255,val=' ')
  for i = 0, 10 do begin
   labels[i*25] = string(i/100.,format='(f4.2)')
  endfor
  makekey, .05, .1, .4, .05, 0, -.035, $
   charsize=.5, align=0, $
   colors=findgen(255), labels=labels, /noborder


; Now get the LER that Santiago returned to me
  filename = './2007m0605t1407-o15368_julian156.nc'
  cdfid = ncdf_open(filename)
  id    = ncdf_varid(cdfid,'LER388')
  ncdf_varget, cdfid, id, ler_inp
  ncdf_close, cdfid
; Put onto same grid as below will have...Santiago gives 60x1201
  ler_return = make_array(60,1644,val=min(ler_inp))
  ler_return[*,199:1399] = ler_inp


  map_set, /cont, /noerase, title='Santiago - Transmissivity > 0'
  for ix = 0, 59 do begin
   for iy = 0, 1643 do begin
    if(ler_return[ix,iy] gt 0) then begin
     val = ler_return[ix,iy]
     color = fix(val*2300+.5)    ; 
;     if(color le 253) then $     ; only plot in range of model LER
;     plots, lon[ix,iy], lat[ix,iy], color=color, psym=3
    endif
   endfor
  endfor

  device, /close
stop
; Now create a scatter plot
  set_plot, 'ps'
  device, file='ler.scatter.ps', xsize=16, ysize=8, xoff=.5, yoff=.5, /color
  loadct, 39
  !p.font=0
  !p.multi=[0,2,1]

  plot, findgen(2), xrange=[0,0.15], yrange=[0,0.15], $
   xtitle = 'Pete', ytitle = 'Santiago', title='LER 388 nm'
  a = where(refl gt 0 and ler_return gt 0)
  plots, refl[a], ler_return[a], psym=3

  plot, refl[a]-ler_return[a], /nodata, $
   title='Pete - Santiago LER diff'
  plots, dindgen(n_elements(a)), refl[a]-ler_return[a], psym=3
  device, /close




end
