; Colarco
; March 2016
; Gather retrieval information a specified region of latitudes and
; longitudes

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


  n    = 45L*71*3*9
  sza = sza[0:n-1]
  vza = vza[0:n-1]
  raa = raa[0:n-1]
  prs = prs[0:n-1]
  trans = trans[0:n-1]
  spher = spher[0:n-1]
  i388c = i388c[0:n-1]

  sza = reform(sza,45,71,3,9)
  vza = reform(vza,45,71,3,9)
  raa = reform(raa,45,71,3,9)
  prs = reform(prs,45,71,3,9)
  trans = reform(trans,45,71,3,9)
  spher = reform(spher,45,71,3,9)
  i388c = reform(i388c,45,71,3,9)

  mu0  = cos(sza/360.*2.*!pi)
  mu   = cos(vza/360.*2.*!pi)
  ra   = cos(raa/360.*2.*!pi)
  sca  = 360./2./!pi*acos(-mu0*mu+ra*sqrt((1.-mu0)*(1.-mu)))

  sca = reform(sca,45*71*3L,9)
  prs = reform(prs,45*71*3L,9)
  sza = reform(sza,45*71*3L,9)
  vza = reform(vza,45*71*3L,9)
  trans = reform(trans,45*71*3L,9)
  spher = reform(spher,45*71*3L,9)
  i388c = reform(i388c,45*71*3L,9)

  set_plot, 'ps'
  device, file='plot_sensitivity.ps', /color, /helvetica, font_size=14, $
   xoff=.5, yoff=.5, xsize=16, ysize=26
  !p.font=0
  !p.multi = [0,2,5]

  loadct, 39  

  for i = 0, 8 do begin
   plot, findgen(2), /nodata, $
    xrange=[0,180], xtitle='Scattering Angle', $
    yrange=[0,.25], ytitle='Transmissivity', $
    title=string(prs[0,i],format='(i4)')+' hPa'
   a = where(trans[*,i] gt 0)
   color=sza/max(sza)*254
   plots, sca[a,i], trans[a,i], psym=3, color=color[a,i]
  endfor
  
  device, /close


  device, file='plot_sensitivity.2.ps', /color, /helvetica, font_size=14, $
   xoff=.5, yoff=.5, xsize=24, ysize=8
  !p.font=0
  !p.multi=[0,3,1]

  plot, indgen(2), /nodata, $
   xrange=[600,1000], xtitle='pressure [hPa]', $
   yrange=[0,.25], ytitle='transmissivity', $
   title='Transmissivity'
  a = where(sza eq 10. and vza eq 46. and raa eq 0.)
  oplot, prs[a], trans[a], thick=3
  a = where(sza eq 10. and vza eq 46. and raa eq 90.)
  oplot, prs[a], trans[a], thick=3, lin=2, color=84
  a = where(sza eq 10. and vza eq 46. and raa eq 180.)
  oplot, prs[a], trans[a], thick=3, lin=1, color=254
  xyouts, 620, .05, 'SZA = 10!Eo!N', charsize=.5
  xyouts, 620, .03, 'VZA = 46!Eo!N', charsize=.5
  xyouts, 620, .01, 'RAA = 0!Eo!N (black), = 90!Eo!N (blue), = 180!Eo!N (red)', charsize=.5

  plot, indgen(2), /nodata, $
   xrange=[600,1000], xtitle='pressure [hPa]', $
   yrange=[0,.3], ytitle='spherical albedo', $
   title='Spherical Albedo'
  a = where(sza eq 10. and vza eq 46. and raa eq 0.)
  oplot, prs[a], spher[a], thick=3
  a = where(sza eq 10. and vza eq 46. and raa eq 90.)
  oplot, prs[a], spher[a], thick=3, lin=2, color=84
  a = where(sza eq 10. and vza eq 46. and raa eq 180.)
  oplot, prs[a], spher[a], thick=3, lin=1, color=254

  plot, indgen(2), /nodata, $
   xrange=[600,1000], xtitle='pressure [hPa]', $
   yrange=[0,.1], ytitle='i388c', $
   title='I!D388!N calculated'
  a = where(sza eq 10. and vza eq 46. and raa eq 0.)
  oplot, prs[a], i388c[a], thick=3
  a = where(sza eq 10. and vza eq 46. and raa eq 90.)
  oplot, prs[a], i388c[a], thick=3, lin=2, color=84
  a = where(sza eq 10. and vza eq 46. and raa eq 180.)
  oplot, prs[a], i388c[a], thick=3, lin=1, color=254




  plot, indgen(2), /nodata, $
   xrange=[600,1000], xtitle='pressure [hPa]', $
   yrange=[0,.25], ytitle='transmissivity', $
   title='Transmissivity'
  a = where(sza eq 46. and vza eq 46. and raa eq 0.)
  oplot, prs[a], trans[a], thick=3
  a = where(sza eq 46. and vza eq 46. and raa eq 90.)
  oplot, prs[a], trans[a], thick=3, lin=2, color=84
  a = where(sza eq 46. and vza eq 46. and raa eq 180.)
  oplot, prs[a], trans[a], thick=3, lin=1, color=254
  xyouts, 620, .05, 'SZA = 46!Eo!N', charsize=.5
  xyouts, 620, .03, 'VZA = 46!Eo!N', charsize=.5
  xyouts, 620, .01, 'RAA = 0!Eo!N (black), = 90!Eo!N (blue), = 180!Eo!N (red)', charsize=.5

  plot, indgen(2), /nodata, $
   xrange=[600,1000], xtitle='pressure [hPa]', $
   yrange=[0,.3], ytitle='spherical albedo', $
   title='Spherical Albedo'
  a = where(sza eq 46. and vza eq 46. and raa eq 0.)
  oplot, prs[a], spher[a], thick=3
  a = where(sza eq 46. and vza eq 46. and raa eq 90.)
  oplot, prs[a], spher[a], thick=3, lin=2, color=84
  a = where(sza eq 46. and vza eq 46. and raa eq 180.)
  oplot, prs[a], spher[a], thick=3, lin=1, color=254

  plot, indgen(2), /nodata, $
   xrange=[600,1000], xtitle='pressure [hPa]', $
   yrange=[0,.1], ytitle='i388c', $
   title='I!D388!N calculated'
  a = where(sza eq 46. and vza eq 46. and raa eq 0.)
  oplot, prs[a], i388c[a], thick=3
  a = where(sza eq 46. and vza eq 46. and raa eq 90.)
  oplot, prs[a], i388c[a], thick=3, lin=2, color=84
  a = where(sza eq 46. and vza eq 46. and raa eq 180.)
  oplot, prs[a], i388c[a], thick=3, lin=1, color=254


  device, /close

end
