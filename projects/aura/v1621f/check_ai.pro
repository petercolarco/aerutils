; Colarco
; I compute the AI in python code
; How does that compare to what I calculate using the new algorithm
; from Santiago that has a "cloud fraction" implied.

  filename = './OMI-Aura_L2-OMAERUV_2007m0605t1407-o15368_v003-2015m0918t203128.vl_rad.geos5_pressure.he5'

; Get the radiances
    file_id = h5f_open(filename)
    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/Longitude')
    lon     = h5d_read(var_id)
    nxy     = n_elements(lon)
    lon     = reform(lon,nxy)
    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/Latitude')
    lat     = h5d_read(var_id)
    lat     = reform(lat,nxy)
    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/NormRadiance')
    rad     = h5d_read(var_id)
    rad     = reform(rad[0:1,*,*],2,nxy)  ; 354 and 388 nm
    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/Radiance388Calc')
    i388c   = h5d_read(var_id)
    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/Transmissivity')
    trans   = h5d_read(var_id)
    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/SphericalAlbedo')
    spher   = h5d_read(var_id)
    i388c   = reform(i388c,nxy)
    trans   = reform(trans,nxy)
    spher   = reform(spher,nxy)
    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/SurfaceAlbedo')
    albedo  = h5d_read(var_id)
    albedo  = reform(albedo[0:1,*,*],2,nxy)  ; 354 and 388 nm
    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/UVAerosolIndex')
    ai      = h5d_read(var_id)
    ai     = reform(ai,nxy)
  h5f_close, file_id



; Calculate the LER
  refl = reform((rad[1,*]-i388c) / (trans + spher*(rad[1,*]-i388c)))

; Calculate correction factor to account for bright scenes
  cf = make_array(nxy,val=0.)
  a = where(refl lt .15)
  cf[a] = 1.
  a = where(refl ge .15 and refl lt .8)
  cf[a] = 1.-((refl[a]-.15)/(0.8-.15))

; Calculate the spectral correction
  diff = make_array(nxy,val=0.)
  a = where(albedo[0,*] gt 0 and albedo[1,*] gt 0)
  diff[a] = (albedo[1,a]-albedo[0,a])*cf[a]

; Corrected reflectivity
  cor_refl = refl - diff

; Calculate the radiance for AI equation (calc, trans and spher are wrong channel)
; This requires properly the 354 calc, trans and spher, which I did not save
  calrad = i388c + cor_refl*trans/(1.-cor_refl*spher)

; Calculation the AI
  ai_calc = -100.*alog10(rad[0,*]/calrad)



  set_plot, 'ps'
  device, file='check_ai.ps', xsize=16, ysize=24, xoff=.5, yoff=.5, /color
  loadct, 39
  !p.font=0
  !p.multi=[0,2,4]

; Radiance -- 354 nm
  map_set, /cont, /noerase, $
           limit=[-50,-100,80,20], /grid, $
           latdel=20,londel=20, /iso
  a = where(rad[0,*] gt 0)
  rad_ = rad[0,a]
  lon_ = lon[a]
  lat_ = lat[a]
  nxy = n_elements(a)
  a = where(rad_ gt .1)
  rad_[a] = .1
  rad_ = rad_/0.1*254
  usersym, [-1,1,1,-1,-1]*.2, [-1,-1,1,1,-1]*.2, /fill
  for ixy = 0, nxy-1 do begin
   plots, lon_[ixy], lat_[ixy], color=rad_[ixy], psym=8, noclip=0
  endfor
  map_continents, color=0, thick=3
  map_continents, color=0, thick=1, /countries
;  plots, lon[50000:50200], lat[50000:50200], psym=4

; Radiance -- 388 nm
  !p.multi=[7,2,4]
  map_set, /cont, /noerase, $
           limit=[-50,-100,80,20], /grid, $
           latdel=20,londel=20, /iso
  a = where(rad[1,*] gt 0)
  rad_ = rad[1,a]
  lon_ = lon[a]
  lat_ = lat[a]
  nxy = n_elements(a)
  a = where(rad_ gt .1)
  rad_[a] = .1
  rad_ = rad_/0.1*254
  usersym, [-1,1,1,-1,-1]*.2, [-1,-1,1,1,-1]*.2, /fill
  for ixy = 0, nxy-1 do begin
   plots, lon_[ixy], lat_[ixy], color=rad_[ixy], psym=8, noclip=0
  endfor
  map_continents, color=0, thick=3
  map_continents, color=0, thick=1, /countries


; Cloud Fraction
  !p.multi=[6,2,4]
  map_set, /cont, /noerase, $
           limit=[-50,-100,80,20], /grid, $
           latdel=20,londel=20, /iso
  a = where(cf gt 0)
  rad_ = cf[a]
  lon_ = lon[a]
  lat_ = lat[a]
  nxy = n_elements(a)
  a = where(rad_ gt 1.)
  rad_[a] = 1.
  rad_ = rad_/1.*254
  usersym, [-1,1,1,-1,-1]*.2, [-1,-1,1,1,-1]*.2, /fill
  for ixy = 0, nxy-1 do begin
   plots, lon_[ixy], lat_[ixy], color=rad_[ixy], psym=8, noclip=0
  endfor
  map_continents, color=0, thick=3
  map_continents, color=0, thick=1, /countries

; LER388
  !p.multi=[5,2,4]
  map_set, /cont, /noerase, $
           limit=[-50,-100,80,20], /grid, $
           latdel=20,londel=20, /iso
  a = where(refl gt 0)
  rad_ = refl[a]
  lon_ = lon[a]
  lat_ = lat[a]
  nxy = n_elements(a)
  a = where(rad_ gt 1.)
  rad_[a] = 1.
  rad_ = rad_/1.*254
  usersym, [-1,1,1,-1,-1]*.2, [-1,-1,1,1,-1]*.2, /fill
  for ixy = 0, nxy-1 do begin
   plots, lon_[ixy], lat_[ixy], color=rad_[ixy], psym=8, noclip=0
  endfor
  map_continents, color=0, thick=3
  map_continents, color=0, thick=1, /countries

; I388c
  !p.multi=[4,2,4]
  map_set, /cont, /noerase, $
           limit=[-50,-100,80,20], /grid, $
           latdel=20,londel=20, /iso
  a = where(i388c gt 0)
  rad_ = i388c[a]
  lon_ = lon[a]
  lat_ = lat[a]
  nxy = n_elements(a)
  a = where(rad_ gt .1)
  rad_[a] = .1
  rad_ = rad_/.1*254
  usersym, [-1,1,1,-1,-1]*.2, [-1,-1,1,1,-1]*.2, /fill
  for ixy = 0, nxy-1 do begin
   plots, lon_[ixy], lat_[ixy], color=rad_[ixy], psym=8, noclip=0
  endfor
  map_continents, color=0, thick=3
  map_continents, color=0, thick=1, /countries

; calrad
  !p.multi=[3,2,4]
  map_set, /cont, /noerase, $
           limit=[-50,-100,80,20], /grid, $
           latdel=20,londel=20, /iso
  a = where(calrad gt 0)
  rad_ = calrad[a]
  lon_ = lon[a]
  lat_ = lat[a]
  nxy = n_elements(a)
  a = where(rad_ gt .1)
  rad_[a] = .1
  rad_ = rad_/.1*254
  usersym, [-1,1,1,-1,-1]*.2, [-1,-1,1,1,-1]*.2, /fill
  for ixy = 0, nxy-1 do begin
   plots, lon_[ixy], lat_[ixy], color=rad_[ixy], psym=8, noclip=0
  endfor
  map_continents, color=0, thick=3
  map_continents, color=0, thick=1, /countries

; AI I calculated in VLIDORT
  !p.multi=[2,2,4]
  map_set, /cont, /noerase, $
           limit=[-50,-100,80,20], /grid, $
           latdel=20,londel=20, /iso
  a = where(ai gt 0)
  rad_ = ai[a]
  lon_ = lon[a]
  lat_ = lat[a]
  nxy = n_elements(a)
  a = where(rad_ gt 2.)
  rad_[a] = 2.
  rad_ = rad_/2.*254
  usersym, [-1,1,1,-1,-1]*.2, [-1,-1,1,1,-1]*.2, /fill
  for ixy = 0, nxy-1 do begin
   plots, lon_[ixy], lat_[ixy], color=rad_[ixy], psym=8, noclip=0
  endfor
  map_continents, color=0, thick=3
  map_continents, color=0, thick=1, /countries


; AI I calculated here
  !p.multi=[1,2,4]
  map_set, /cont, /noerase, $
           limit=[-50,-100,80,20], /grid, $
           latdel=20,londel=20, /iso
  a = where(ai_calc gt 0)
  rad_ = ai_calc[a]
  lon_ = lon[a]
  lat_ = lat[a]
  nxy = n_elements(a)
  a = where(rad_ gt 2.)
  rad_[a] = 2.
  rad_ = rad_/2.*254
  usersym, [-1,1,1,-1,-1]*.2, [-1,-1,1,1,-1]*.2, /fill
  for ixy = 0, nxy-1 do begin
   plots, lon_[ixy], lat_[ixy], color=rad_[ixy], psym=8, noclip=0
  endfor
  map_continents, color=0, thick=3
  map_continents, color=0, thick=1, /countries

  device, /close

end
