; Colarco, October 2015
; Read in the synthetic OMI data and plot the AOD at 388 nm for
; a day

; Files
  files = ['/misc/prc08/colarco/OMAERUV_V1731_DATA/2007/OMI-Aura_L2-OMAERUV_2007m0605t1228-o15367_v003-2016m0921t221551.he5']

; Read the files and get a variable
  for ifile = 0, n_elements(files)-1 do begin
    file_id = h5f_open(files[ifile])
    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/Longitude')
    lon_    = h5d_read(var_id)
    nxy     = n_elements(lon_)
    lon_    = reform(lon_,nxy)
    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/Latitude')
    lat_    = h5d_read(var_id)
    lat_    = reform(lat_,nxy)
    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/UVAerosolIndex')
    ai_    = h5d_read(var_id)
    ai_    = reform(ai_,nxy)
    h5f_close, file_id
    if(ifile eq 0) then begin
     ai = ai_
     lon = lon_
     lat = lat_
    endif else begin
     ai = [ai,ai_]
     lon = [lon,lon_]
     lat = [lat,lat_]
    endelse
  endfor

; Now set up a plot
  set_plot, 'ps'
  device, file='ai388.ps', xsize=16, ysize=12, xoff=.5, yoff=.5, /color, /helvetica
  !p.font=0
  loadct, 0

  map_set, /noborder, /noerase, limit=[-40,-30,30,30]
  nxy = n_elements(lon)
; plot negative AI
  a = where(ai lt 0.0001 and ai gt -100)
  ai_ = ai[a]
  lon_ = lon[a]
  lat_ = lat[a]
  nxy = n_elements(a)
  usersym, [-1,1,1,-1,-1]*.1, [-1,-1,1,1,-1]*.1, /fill
  for ixy = 0, nxy-1 do begin
   plots, lon_[ixy], lat_[ixy], color=120, psym=8, noclip=0
  endfor
; plot positive AI
  loadct, 39
  a = where(ai gt -2.1)
  ai = ai[a]
  lon = lon[a]
  lat = lat[a]
  nxy = n_elements(a)
  col = fltarr(nxy)
  a = where(ai gt -2)
  col[a] = 30
  a = where(ai gt -1.5)
  col[a] = 60
  a = where(ai gt -1)
  col[a] = 90
  a = where(ai gt -.5)
  col[a] = 112
  a = where(ai gt 0)
  col[a] = 120
  a = where(ai gt .5)
  col[a] = 128
  a = where(ai gt 1)
  col[a] = 176
  a = where(ai gt 1.5)
  col[a] = 192
  a = where(ai gt 2)
  col[a] = 198
  a = where(ai gt 2.5)
  col[a] = 208
  a = where(ai gt 3)
  col[a] = 254

  usersym, [-1,1,1,-1,-1]*.1, [-1,-1,1,1,-1]*.1, /fill
  for ixy = 0, nxy-1 do begin
   plots, lon[ixy], lat[ixy], color=col[ixy], psym=sym(1), symsize=.5, noclip=0
  endfor
  map_continents, color=0, thick=3
  map_continents, color=0, thick=1, /countries
  map_set, /noerase, limit=[-40,-30,30,30], $
           /horizon, /grid, glinestyle=0, color=0, glinethick=2

  makekey, .1, .05, .8, .05, 0, -0.035, $
           charsize=.75, align=.5, colors=[30,60,90,112,120,128,176,192,198,208,254], $
           labels=string(findgen(11)*.5-2.,format='(f4.1)'), /noborder


  device, /close

end
