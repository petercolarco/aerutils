; Plot from the OMI granule that has had model fields stuffed back
; into it

  filename = './OMI-Aura_L2-OMAERUV_2007m0605t1407-o15368_v003-2014m1202t172538.vl.he5'
  file_id = h5f_open(filename)
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/SurfaceAlbedo')
  albedo  = h5d_read(var_id)
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/SolarZenithAngle')
  sza     = h5d_read(var_id)
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/RelativeAzimuthAngle')
  raa     = h5d_read(var_id)
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/ViewingZenithAngle')
  vza     = h5d_read(var_id)
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/Longitude')
  lon     = h5d_read(var_id)
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/Latitude')
  lat     = h5d_read(var_id)
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/UVAerosolIndex')
  ai      = h5d_read(var_id)
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/NormRadiance')
  rad     = h5d_read(var_id)
  h5f_close, file_id

  set_plot, 'ps'
  device, file='omi_granule.vl.ps', xsize=16, ysize=24, xoff=.5, yoff=.5, /color
  loadct, 39
  !p.font=0

  !p.multi=[0,2,4]

  map_set, /cont, title='grid'
  plots, lon, lat, psym=3

  !p.multi=[7,2,4]
  map_set, /cont, /noerase, title='solar zenith angle - red > 90'
  a = where(sza lt 0)
  plots, lon[a], lat[a], psym=3
  a = where(sza gt 90)
  plots, lon[a], lat[a], psym=4, color=254

  !p.multi=[6,2,4]
  map_set, /cont, /noerase, title='viewing zenith angle - red > 90'
  a = where(vza lt 0)
  plots, lon[a], lat[a], psym=3
  a = where(vza gt 90)
  plots, lon[a], lat[a], psym=4, color=254

  !p.multi=[5,2,4]
  map_set, /cont, /noerase, title='relative azimuth angle - black < 0'
  a = where(raa lt 0)
  plots, lon[a], lat[a], psym=3
  a = where(raa gt 180)
  plots, lon[a], lat[a], psym=4, color=254

  !p.multi=[4,2,4]
  map_set, /cont, /noerase, title='albedo(0) - black < 0'
  a = where(albedo[0,*,*] lt 0)
  plots, lon[a], lat[a], psym=3
  a = where(albedo[0,*,*] gt 1)
  plots, lon[a], lat[a], psym=4, color=254

  !p.multi=[3,2,4]
  map_set, /cont, /noerase, title='albedo(1) - black < 0'
  a = where(albedo[1,*,*] lt 0)
  plots, lon[a], lat[a], psym=3
  a = where(albedo[1,*,*] gt 1)
  plots, lon[a], lat[a], psym=4, color=254

  !p.multi=[2,2,4]
  map_set, /cont, /noerase, title='aerosol index - black < -10'
  a = where(ai[*,*] lt -10)
  plots, lon[a], lat[a], psym=3
  a = where(ai[*,*] gt -10)
  plots, lon[a], lat[a], psym=3, color=254

  !p.multi=[1,2,4]
  loadct, 39
  map_set, /cont, /noerase, title='radiance(0) > 0'
  for ix = 0, 59 do begin
   for iy = 0, 1643 do begin
    if(rad[0,ix,iy] gt 0) then begin
     val = rad[0,ix,iy]
     val = val/max(rad[0,*,*])
     color = fix(val*254)
     plots, lon[ix,iy], lat[ix,iy], color=color, psym=3
  endif
 endfor
endfor





  device, /close


end
