; Colarco, May 2016
; Santiago ran some specialized runs for me to pull the
; transmissivity, spherical albedo, and i388calc from the retrieval
; algorithms.  He provides two files, one titled "count" that contains
; the grid points and whether they have a valid set of values or not,
; and then one called "mydata" which has a sequential list of the
; values.  He leaves it as an exercise to me to merge these into
; something I can compare to my own results.

; Get the count file
; I know ahead of time the size of this files
  npts = 60.*1644.
  data = fltarr(3,npts)
  openr, lun, 'count.sensitivity.txt', /get
  readf, lun, data
  free_lun, lun
  valid = reform(data[2,*])

; Now get the actual output
  openr, lun, 'mydata.sensitivity.txt', /get
  data = 1.
  icts = 0.
  while(not(eof(lun))) do begin
   readf, lun, data
   icts = icts+1
  endwhile
  free_lun, lun
  openr, lun, 'mydata.sensitivity.txt', /get
  ncts = icts
  data = fltarr(3,ncts)
  readf, lun, data
  free_lun, lun

  i388c_omi = make_array(n_elements(valid),val=!values.f_nan)
  trans_omi = make_array(n_elements(valid),val=!values.f_nan)
  spher_omi = make_array(n_elements(valid),val=!values.f_nan)
  a = where(valid eq 0)
  i388c_omi[a] = data[0,*]
  trans_omi[a] = data[1,*]
  spher_omi[a] = data[2,*]

; Now let's get my own values
  filen  = 'OMI-Aura_L2-OMAERUV_2007m0605t1407-o15368_v003-2015m0918t203128.vl_rad.geos5_pressure.he5'

    file_id = h5f_open(filen)

    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/Longitude')
    lon    = h5d_read(var_id)
    nxy     = n_elements(lon)
    lon    = reform(lon,nxy)

    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/Radiance388Calc')
    i388c   = h5d_read(var_id)
    i388c   = reform(i388c,nxy)

    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/Transmissivity')
    trans   = h5d_read(var_id)
    trans   = reform(trans,nxy)

    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/SphericalAlbedo')
    spher   = h5d_read(var_id)
    spher   = reform(spher,nxy)

    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields//Radiance388Calc')
    i388c   = h5d_read(var_id)
    i388c   = reform(i388c,nxy)

    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/Latitude')
    lat    = h5d_read(var_id)
    lat    = reform(lat,nxy)

    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/UVAerosolIndex')
    ai    = h5d_read(var_id)
    ai    = reform(ai,nxy)

    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/Reflectivity')
    refl     = h5d_read(var_id)
    ler388   = reform(refl[1,*,*],nxy)

    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/MERRAero_AOT')
    aod    = h5d_read(var_id)
    aod    = reform(aod[1,*,*],nxy)

    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/ViewingZenithAngle')
    vza    = h5d_read(var_id)
    vza    = reform(vza,nxy)

    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/SolarZenithAngle')
    sza    = h5d_read(var_id)
    sza    = reform(sza,nxy)

    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/RelativeAzimuthAngle')
    raa    = h5d_read(var_id)
    raa    = reform(raa,nxy)

    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/MERRAero_SSA')
    ssa    = h5d_read(var_id)
    ssa    = reform(ssa[1,*,*],nxy)

    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/Residue')
    residue = h5d_read(var_id)
    residue = reform(residue,nxy)

    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/NormRadiance')
    rad_    = h5d_read(var_id)
    rad388  = reform(rad_[1,*,*],nxy)
    rad354  = reform(rad_[0,*,*],nxy)

    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/TerrainPressure')
    prs    = h5d_read(var_id)
    prs    = reform(prs,nxy)

  h5f_close, file_id

; The sensitivity test was valid for fltarr(45,71,3,9) nodes
  n = 45*71*3*9.
  prs = reform(prs[0:n-1],45,71,3,9)
  vza = reform(vza[0:n-1],45,71,3,9)
  sza = reform(sza[0:n-1],45,71,3,9)
  raa = reform(raa[0:n-1],45,71,3,9)
  mu0  = cos(sza/360.*2.*!pi)
  mu   = cos(vza/360.*2.*!pi)
  ra   = cos(raa/360.*2.*!pi)
  sca  = 360./2./!pi*acos(-mu0*mu+ra*sqrt((1.-mu0)*(1.-mu)))
  trans = reform(trans[0:n-1],45,71,3,9)
  trans_omi = reform(trans_omi[0:n-1],45,71,3,9)
  spher = reform(spher[0:n-1],45,71,3,9)
  spher_omi = reform(spher_omi[0:n-1],45,71,3,9)
  i388c = reform(i388c[0:n-1],45,71,3,9)
  i388c_omi = reform(i388c_omi[0:n-1],45,71,3,9)

; residuals
  fi388c = (i388c_omi-i388c)/i388c
  fspher = (spher_omi-spher)/spher
  ftrans = (trans_omi-trans)/trans

  fi388c = reform(fi388c,45.*71,3,9)
  fspher = reform(fspher,45.*71,3,9)
  ftrans = reform(ftrans,45.*71,3,9)

; Make array of nsca vs. pressure vs. raa
  dsca = 10.   ; degrees width of scattering angle bins
  nsca = 15
  scas = findgen(nsca)*dsca+30.
  nprs = 9
  prss = findgen(nprs)*50+600.
  arr = make_array(nprs,nsca,3,val=!values.f_nan)

  i = 0
  for i = 0, 2 do begin
  for j = 0, nprs-1 do begin
   for k = 0, nsca-1 do begin
    a = where(sca[*,*,i,j] ge scas[k]-dsca/2. and $
              sca[*,*,i,j] lt scas[k]+dsca/2.)
    if(a[0] ne -1) then arr[j,k,i] = mean(fi388c[a,i,j],/nan)
   endfor
  endfor
  endfor

  set_plot, 'ps'
  device, file='bin_sensitivity.ps', /helvetica, font_size=14, /color
  !p.font=0
  loadct, 0
  contour, arr[*,*,0], prss, scas, /nodata, $
   xrange=[600,1000], xtitle='Pressure [hPa]', $
   yrange=[60,170], ytitle='Scattering Angle', $
   ystyle=9, $
   position = [.1,.25,.9,.95]
  loadct, 69
  colors = findgen(9)*30
  levels = [.001,.004,.008,.012,.016,.018,.022,.026,.03]
  contour, /over, arr[*,*,0], prss, scas, $ 
   levels=levels, /cell
  loadct, 0
  makekey, .1, .05, .8, .05, 0, -0.035, color=colors, $
   label=string(levels,format='(f5.3)'), align=0
  loadct, 69
  makekey, .1, .05, .8, .05, 0, -0.035, color=colors, $
   label=[' ',' ']

  device, /close

end
