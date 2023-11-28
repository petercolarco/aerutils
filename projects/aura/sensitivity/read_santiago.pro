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

  set_plot, 'ps'
  device, file='comp_sensitivity.ps', /color, /helvetica, font_size=14, $
   xoff=.5, yoff=.5, xsize=24, ysize=8
  !p.font=0
  !p.multi=[0,3,1]

  loadct, 39

  plot, indgen(2), /nodata, $
   xrange=[600,1000], xtitle='pressure [hPa]', $
   yrange=[0,.25], ytitle='transmissivity', $
   title='Transmissivity'
  a = where(sza eq 10. and vza eq 46. and raa eq 0.)
  oplot, prs[a], trans[a], thick=3
  oplot, prs[a], trans_omi[a], thick=3, color=254
  a = where(sza eq 10. and vza eq 46. and raa eq 90.)
  oplot, prs[a], trans[a], thick=6, lin=2
  oplot, prs[a], trans_omi[a], thick=6, lin=2, color=254
  a = where(sza eq 10. and vza eq 46. and raa eq 180.)
  oplot, prs[a], trans[a], thick=8, lin=1
  oplot, prs[a], trans_omi[a], thick=8, lin=1, color=254

  xyouts, 620, .05, 'SZA = 10!Eo!N', charsize=.5
  xyouts, 620, .03, 'VZA = 46!Eo!N', charsize=.5
  xyouts, 620, .01, 'RAA = 0!Eo!N (solid), = 90!Eo!N (dashed), = 180!Eo!N (dotted)', charsize=.5

  plot, indgen(2), /nodata, $
   xrange=[600,1000], xtitle='pressure [hPa]', $
   yrange=[0,.3], ytitle='spherical albedo', $
   title='Spherical Albedo'
  a = where(sza eq 10. and vza eq 46. and raa eq 0.)
  oplot, prs[a], spher[a], thick=3
  oplot, prs[a], spher_omi[a], thick=3, color=254
  a = where(sza eq 10. and vza eq 46. and raa eq 90.)
  oplot, prs[a], spher[a], thick=6, lin=2
  oplot, prs[a], spher_omi[a], thick=6, lin=2, color=254
  a = where(sza eq 10. and vza eq 46. and raa eq 180.)
  oplot, prs[a], spher[a], thick=8, lin=1
  oplot, prs[a], spher_omi[a], thick=8, lin=1, color=254

  plot, indgen(2), /nodata, $
   xrange=[600,1000], xtitle='pressure [hPa]', $
   yrange=[0,.1], ytitle='i388c', $
   title='I!D388!N calculated'
  a = where(sza eq 10. and vza eq 46. and raa eq 0.)
  oplot, prs[a], i388c[a], thick=3
  oplot, prs[a], i388c_omi[a], thick=3, color=254
  a = where(sza eq 10. and vza eq 46. and raa eq 90.)
  oplot, prs[a], i388c[a], thick=6, lin=2
  oplot, prs[a], i388c_omi[a], thick=6, lin=2, color=254
  a = where(sza eq 10. and vza eq 46. and raa eq 180.)
  oplot, prs[a], i388c[a], thick=8, lin=1
  oplot, prs[a], i388c_omi[a], thick=8, lin=1, color=254




  plot, indgen(2), /nodata, $
   xrange=[600,1000], xtitle='pressure [hPa]', $
   yrange=[0,.25], ytitle='transmissivity', $
   title='Transmissivity'
  a = where(sza eq 46. and vza eq 46. and raa eq 0.)
  oplot, prs[a], trans[a], thick=3
  oplot, prs[a], trans_omi[a], thick=3, color=254
  a = where(sza eq 46. and vza eq 46. and raa eq 90.)
  oplot, prs[a], trans[a], thick=6, lin=2
  oplot, prs[a], trans_omi[a], thick=6, lin=2, color=254
  a = where(sza eq 46. and vza eq 46. and raa eq 180.)
  oplot, prs[a], trans[a], thick=8, lin=1
  oplot, prs[a], trans_omi[a], thick=8, lin=1, color=254

  xyouts, 620, .05, 'SZA = 46!Eo!N', charsize=.5
  xyouts, 620, .03, 'VZA = 46!Eo!N', charsize=.5
  xyouts, 620, .01, 'RAA = 0!Eo!N (solid), = 90!Eo!N (dashed), = 180!Eo!N (dotted)', charsize=.5

  plot, indgen(2), /nodata, $
   xrange=[600,1000], xtitle='pressure [hPa]', $
   yrange=[0,.3], ytitle='spherical albedo', $
   title='Spherical Albedo'
  a = where(sza eq 46. and vza eq 46. and raa eq 0.)
  oplot, prs[a], spher[a], thick=3
  oplot, prs[a], spher_omi[a], thick=3, color=254
  a = where(sza eq 46. and vza eq 46. and raa eq 90.)
  oplot, prs[a], spher[a], thick=6, lin=2
  oplot, prs[a], spher_omi[a], thick=6, lin=2, color=254
  a = where(sza eq 46. and vza eq 46. and raa eq 180.)
  oplot, prs[a], spher[a], thick=8, lin=1
  oplot, prs[a], spher_omi[a], thick=8, lin=1, color=254

  plot, indgen(2), /nodata, $
   xrange=[600,1000], xtitle='pressure [hPa]', $
   yrange=[0,.1], ytitle='i388c', $
   title='I!D388!N calculated'
  a = where(sza eq 46. and vza eq 46. and raa eq 0.)
  oplot, prs[a], i388c[a], thick=3
  oplot, prs[a], i388c_omi[a], thick=3, color=254
  a = where(sza eq 46. and vza eq 46. and raa eq 90.)
  oplot, prs[a], i388c[a], thick=6, lin=2
  oplot, prs[a], i388c_omi[a], thick=6, lin=2, color=254
  a = where(sza eq 46. and vza eq 46. and raa eq 180.)
  oplot, prs[a], i388c[a], thick=8, lin=1
  oplot, prs[a], i388c_omi[a], thick=8, lin=1, color=254

  !p.multi=0
  plot, prs[a], i388c_omi[a]-i388c[a], thick=8, $
        xtitle='pressure [hPa]', $
        ytitle='!9D!3I!D388calc!N (OMAERUV-MERRAero)'
  plot, prs[a], spher_omi[a]-spher[a], thick=8, $
        xtitle='pressure [hPa]', $
        ytitle='!9D!3spher!N (OMAERUV-MERRAero)'
  plot, prs[a], trans_omi[a]-trans[a], thick=8, $
        xtitle='pressure [hPa]', $
        ytitle='!9D!3trans!N (OMAERUV-MERRAero)'
  rad = 0.05
  ler_ = (rad - i388c[a])/(trans[a]+spher[a]*(rad-i388c[a]))
  ler_omi_ = (rad - i388c_omi[a])/(trans_omi[a]+spher_omi[a]*(rad-i388c_omi[a]))
  plot, prs[a], ler_omi_-ler_, thick=8, $
        xtitle='pressure [hPa]', $
        ytitle='!9D!3LER!N (OMAERUV-MERRAero)'


  !p.multi=[0,3,1]
  

  device, /close


; Now assign a radiance and calculate LER differences for different
; terms of above
  rad = 0.05
  a = where(valid eq 0)
  ler = (rad - i388c[a])/(trans[a]+spher[a]*(rad-i388c[a]))
  ler_omi = (rad - i388c_omi[a])/(trans_omi[a]+spher_omi[a]*(rad-i388c_omi[a]))
  prs_ = prs[a]
  b = where(ler gt 0 and ler_omi gt 0)
  set_plot, 'x'
  !p.multi=0
  plot, ler-ler_omi


end
