; Colarco
; May 2016
; The purpose of this is to manipulate one of the OMI input files in
; order to test the calculation of the transmissivity, spherical
; albedo, etc., and hence the parameters needed for the aerosol index

; Filename
; This is a file I've simply copied from the OMI directory
; locally and will open and modify.
; Variables to be modified are the pressure and viewing geometry
  filename = 'OMI-Aura_L2-OMAERUV_2007m0605t1407-o15368_v003-2015m0918t203128.he5'

  file_id = h5f_open(filename,/write)

; Manipulate the viewing geometry
; Range of SZA for this granule appears to be 8 - 96 (?)
; Range of VZA for this granule appears to be 0 - 70
; Range of RAA for this granule appears to be 0 - 180
; This gives a range of scattering angle for this geometry 65 - 162
; So this is the space we want to probe

  sza_ = fltarr(45,71,3,9)
  vza_ = fltarr(45,71,3,9)
  raa_ = fltarr(45,71,3,9)

  prs_ = fltarr(45,71,3,9)

  for l = 0, 8 do begin      ; pressure
  
  prs_[*,*,*,l] = 600.+l*50.
   
  for k = 0, 2 do begin      ; raa
   raa_[*,*,k,l] = 90.*k
   for j = 0, 70 do begin    ; vza
    sza_[*,j,k,l] = findgen(45)*2.+8.
   endfor
   for i = 0, 44 do begin    ; sza
    vza_[i,*,k,l] = findgen(71)
   endfor
  endfor
  endfor
  mu0  = cos(sza_/360.*2.*!pi)
  mu   = cos(vza_/360.*2.*!pi)
  ra   = cos(raa_/360.*2.*!pi)
  sca_ = 360./2./!pi*acos(-mu0*mu+ra*sqrt((1.-mu0)*(1.-mu)))

  n = n_elements(sca_)

; Get the solar zenith angle
  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/SolarZenithAngle')
  sza     = h5d_read(var_id)
  sza[0:n-1L] = sza_
  h5d_write, var_id, sza

  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/RelativeAzimuthAngle')
  raa     = h5d_read(var_id)
  raa[0:n-1L] = raa_
  h5d_write, var_id, raa

  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/ViewingZenithAngle')
  vza     = h5d_read(var_id)
  vza[0:n-1L] = vza_
  h5d_write, var_id, vza

  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/TerrainPressure')
  prs     = h5d_read(var_id)
  prs[0:n-1L] = prs_
  h5d_write, var_id, prs

  var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/SurfaceAlbedo')
  albedo  = h5d_read(var_id)
  albedo[*] = 0.05
  h5d_write, var_id, albedo

  h5f_close, file_id

  mu0 = sza
  mu  = sza
  ra  = sza
  sca = sza
  sca[*] = -1.e14
  a = where(raa ge 0)
  mu0[a] = cos(sza[a]/360.*2.*!pi)
  mu[a]  = cos(vza[a]/360.*2.*!pi)
  ra[a]  = cos(raa[a]/360.*2.*!pi)
  sca[a] = 360./2./!pi*acos(-mu0[a]*mu[a]+ra[a]*sqrt((1.-mu0[a])*(1.-mu[a])))


end
