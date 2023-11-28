; Colarco, May 2016
; Santiago ran some specialized runs for me to pull the
; transmissivity, spherical albedo, and i388calc from the retrieval
; algorithms.  He provides two files, one titled "count" that contains
; the grid points and whether they have a valid set of values or not,
; and then one called "mydata" which has a sequential list of the
; values.  He leaves it as an exercise to me to merge these into
; something I can compare to my own results.

; Notes on valid points:
;  - my own calculations fail for SZA >= 90, and AI, rad, etc. come
;    back as undefined numbers
;  - santiago also fails at sza > 80 and then under some other view
;    conditions


; Get the count file
; I know ahead of time the size of this files
  npts = 60.*1644.
  data = fltarr(7,npts)
  openr, lun, 'RowColumn_and_AI.txt', /get
  readf, lun, data
  free_lun, lun
  i     = reform(data[0,*])
  j     = reform(data[1,*])
  valid = reform(data[2,*])
  valid2 = reform(data[3,*])
; map i & j to actual index of full orbit
  index = (i-1)+(j-1)*60

; Now use the valid the criteria (valid = 9999) to reduce number of
; index values
  a = where(valid eq 9999)
  index = index[a]


; Now get the actual output which are a list at valid points
  openr, lun, 'WAVE388_ITOA_TRANS_SPHALB.txt', /get
  data = 1.
  icts = 0.
  while(not(eof(lun))) do begin
   readf, lun, data
   icts = icts+1
  endwhile
  free_lun, lun
  openr, lun, 'WAVE388_ITOA_TRANS_SPHALB.txt', /get
  ncts = icts
  data = fltarr(5,ncts)
  readf, lun, data
  free_lun, lun

  i388c_omi = make_array(npts,val=!values.f_nan)
  trans_omi = make_array(npts,val=!values.f_nan)
  spher_omi = make_array(npts,val=!values.f_nan)
  ai_omi    = make_array(npts,val=!values.f_nan)
  i388c_omi[index] = data[0,*]
  trans_omi[index] = data[1,*]
  spher_omi[index] = data[2,*]
  ai_omi[index] = data[3,*]

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
; Reform arrays accordingly
  n = 45*71*3*9.
  lon = reform(lon[0:n-1],45,71,3,9)
  lat = reform(lat[0:n-1],45,71,3,9)
  prs = reform(prs[0:n-1],45,71,3,9)
  vza = reform(vza[0:n-1],45,71,3,9)
  sza = reform(sza[0:n-1],45,71,3,9)
  raa = reform(raa[0:n-1],45,71,3,9)
  mu0  = cos(sza/360.*2.*!pi)
  mu   = cos(vza/360.*2.*!pi)
  ra   = cos(raa/360.*2.*!pi)
  sca  = 360./2./!pi*acos(-mu0*mu+ra*sqrt((1.-mu0)*(1.-mu)))
  a = where(trans lt 0)
  trans[a] = !values.f_nan
  spher[a] = !values.f_nan
  i388c[a] = !values.f_nan
  trans = reform(trans[0:n-1],45,71,3,9)
  trans_omi = reform(trans_omi[0:n-1],45,71,3,9)
  spher = reform(spher[0:n-1],45,71,3,9)
  spher_omi = reform(spher_omi[0:n-1],45,71,3,9)
  i388c = reform(i388c[0:n-1],45,71,3,9)
  i388c_omi = reform(i388c_omi[0:n-1],45,71,3,9)
  rad388c = reform(rad388[0:n-1],45,71,3,9)
  ler388c = reform(ler388[0:n-1],45,71,3,9)
  ai      = reform(ai[0:n-1],45,71,3,9)
  ai_omi  = reform(ai_omi[0:n-1],45,71,3,9)

  set_plot, 'ps'
  device, file='bin_sensitivity.valid.ps', /color, $
   xsize=16, ysize=16, xoff=.5, yoff=.5

; Pressure and RAA
  loadct, 0
  map_set, /cont, $
   title='Pressure (light = 600, dark = 1000) and RAA'
  plots, lon, lat, psym=3
  loadct, 55
  a = where(raa eq 0)
  color = (prs-600)/400.*256
  plots, lon[a], lat[a], psym=3, color=color[a]  
  loadct, 50
  a = where(raa eq 90)
  plots, lon[a], lat[a], psym=3, color=color[a]  
  loadct, 51
  a = where(raa eq 180)
  plots, lon[a], lat[a], psym=3, color=color[a]  

; Scattering angle
  loadct, 0
  map_set, /cont, title='scattering angle'
  color=(sca-min(sca))/(max(sca)-min(sca))*256
  loadct, 39
  plots, lon, lat, psym=3, color=fix(color)

; SZA angle
  loadct, 0
  map_set, /cont, title='solar zenith angle'
  color=(sza-min(sza))/(max(sza)-min(sza))*256
  loadct, 39
  plots, lon, lat, psym=3, color=fix(color)

; VZA angle
  loadct, 0
  map_set, /cont, title='viewing zenith angle'
  color=(vza-min(vza))/(max(vza-min(vza)))*256
  loadct, 51
  plots, lon, lat, psym=3, color=color

; Santiago invalid
  loadct, 39
  map_set, /cont, title='Santiago invalid in red'
  a = where(finite(i388c_omi) eq 1)
  plots, lon[a], lat[a], psym=3, color=0 
  a = where(finite(i388c_omi) eq 0)
  plots, lon[a], lat[a], psym=sym(1), color=254, symsize=.1

; Pete invalid
  map_set, /cont, title='Pete invalid in red'
  a = where(ai ge -100)
  plots, lon[a], lat[a], psym=3, color=0 
  a = where(ai lt -100)
  plots, lon[a], lat[a], psym=sym(1), color=254, symsize=.1

  device, /close

; residuals
  fi388c = (i388c_omi-i388c)/i388c
  fspher = (spher_omi-spher)/spher
  ftrans = (trans_omi-trans)/trans

  fi388c = reform(fi388c,45.*71,3,9)
  fspher = reform(fspher,45.*71,3,9)
  ftrans = reform(ftrans,45.*71,3,9)

  ai_omi = reform(ai_omi,45.*71,3,9)

; Compute the LER from equation 1 in my paper
  a = where(rad388c lt 0)
  rad388c[a] = !values.f_nan
  ler_merra = (rad388c - i388c)/(trans + spher*(rad388c-i388c))
  ler_omi   = (rad388c - i388c_omi)/(trans_omi + spher_omi*(rad388c-i388c_omi))
  ler_merra = reform(ler_merra,45.*71,3,9)
  ler_omi   = reform(ler_omi,45.*71,3,9)
  fler      = (ler_omi - ler_merra)/ler_merra
  fler      = reform(fler,45.*71,3,9)

; Make array of nsca vs. pressure vs. raa
  dsca = 10.   ; degrees width of scattering angle bins
  nsca = 15
  scas = findgen(nsca)*dsca+30.
  nprs = 9
  prss = findgen(nprs)*50+600.
  arr = make_array(nprs,nsca,3,val=!values.f_nan)


; Make the plots for each of the three parameters above
; fspher
  for i = 0, 2 do begin
  for j = 0, nprs-1 do begin
   for k = 0, nsca-1 do begin
    a = where(sca[*,*,i,j] ge scas[k]-dsca/2. and $
              sca[*,*,i,j] lt scas[k]+dsca/2.)
    if(a[0] ne -1) then arr[j,k,i] = mean(fspher[a,i,j],/nan)
   endfor
  endfor
  endfor
check, arr

  set_plot, 'ps'
  device, file='bin_sensitivity.fspher.ps', /helvetica, font_size=14, /color
  !p.font=0
  loadct, 0
  ctable = 55
  contour, arr[*,*,0], prss, scas, /nodata, $
   xrange=[600,1000], xtitle='Pressure [hPa]', $
   yrange=[60,170], ytitle='Scattering Angle', $
   ystyle=1, $
   position = [.1,.25,.9,.95]
  loadct, ctable
  colors = findgen(9)*30
  levels = [.001,.004,.008,.012,.016,.018,.022,.026,.03]
  contour, /over, arr[*,*,0], prss, scas, $ 
   levels=levels, /cell, c_color=colors
  loadct, 0
  contour, arr[*,*,0], prss, scas, /nodata, /noerase, $
   xrange=[600,1000], xtitle='Pressure [hPa]', $
   yrange=[60,170], ytitle='Scattering Angle', $
   ystyle=1, $
   position = [.1,.25,.9,.95]
  makekey, .1, .05, .8, .05, 0, -0.035, color=colors, $
   label=string(levels,format='(f5.3)'), align=0
  loadct, ctable
  makekey, .1, .05, .8, .05, 0, -0.035, color=colors, $
   label=[' ',' ']

  device, /close



; ftrans
  for i = 0, 2 do begin
  for j = 0, nprs-1 do begin
   for k = 0, nsca-1 do begin
    a = where(sca[*,*,i,j] ge scas[k]-dsca/2. and $
              sca[*,*,i,j] lt scas[k]+dsca/2.)
    if(a[0] ne -1) then arr[j,k,i] = mean(ftrans[a,i,j],/nan)
   endfor
  endfor
  endfor
check, arr

  set_plot, 'ps'
  device, file='bin_sensitivity.ftrans.ps', /helvetica, font_size=14, /color
  !p.font=0
  loadct, 0
  ctable = 55
  contour, arr[*,*,0], prss, scas, /nodata, $
   xrange=[600,1000], xtitle='Pressure [hPa]', $
   yrange=[60,170], ytitle='Scattering Angle', $
   ystyle=1, $
   position = [.1,.25,.9,.95]
  loadct, ctable
  colors = findgen(9)*30
  levels = [.001,.004,.008,.012,.016,.018,.022,.026,.03]
  contour, /over, arr[*,*,0], prss, scas, $ 
   levels=levels, /cell, c_color=colors
  loadct, 0
  contour, arr[*,*,0], prss, scas, /nodata, /noerase, $
   xrange=[600,1000], xtitle='Pressure [hPa]', $
   yrange=[60,170], ytitle='Scattering Angle', $
   ystyle=1, $
   position = [.1,.25,.9,.95]
  makekey, .1, .05, .8, .05, 0, -0.035, color=colors, $
   label=string(levels,format='(f5.3)'), align=0
  loadct, ctable
  makekey, .1, .05, .8, .05, 0, -0.035, color=colors, $
   label=[' ',' ']

  device, /close



; fi388c
  for i = 0, 2 do begin
  for j = 0, nprs-1 do begin
   for k = 0, nsca-1 do begin
    a = where(sca[*,*,i,j] ge scas[k]-dsca/2. and $
              sca[*,*,i,j] lt scas[k]+dsca/2.)
    if(a[0] ne -1) then arr[j,k,i] = mean(fi388c[a,i,j],/nan)
   endfor
  endfor
  endfor
check, arr

  set_plot, 'ps'
  device, file='bin_sensitivity.fi388c.ps', /helvetica, font_size=14, /color
  !p.font=0
  loadct, 0
  ctable = 55
  contour, arr[*,*,0], prss, scas, /nodata, $
   xrange=[600,1000], xtitle='Pressure [hPa]', $
   yrange=[60,170], ytitle='Scattering Angle', $
   ystyle=1, $
   position = [.1,.25,.9,.95]
  loadct, ctable
  colors = findgen(9)*30
  levels = [.001,.004,.008,.012,.016,.018,.022,.026,.03]
  contour, /over, arr[*,*,0], prss, scas, $ 
   levels=levels, /cell, c_color=colors
  loadct, 0
  contour, arr[*,*,0], prss, scas, /nodata, /noerase, $
   xrange=[600,1000], xtitle='Pressure [hPa]', $
   yrange=[60,170], ytitle='Scattering Angle', $
   ystyle=1, $
   position = [.1,.25,.9,.95]
  makekey, .1, .05, .8, .05, 0, -0.035, color=colors, $
   label=string(levels,format='(f5.3)'), align=0
  loadct, ctable
  makekey, .1, .05, .8, .05, 0, -0.035, color=colors, $
   label=[' ',' ']

  device, /close



; ler_omi
  for i = 0, 2 do begin
  for j = 0, nprs-1 do begin
   for k = 0, nsca-1 do begin
    a = where(sca[*,*,i,j] ge scas[k]-dsca/2. and $
              sca[*,*,i,j] lt scas[k]+dsca/2.)
    if(a[0] ne -1) then arr[j,k,i] = mean(ler_omi[a,i,j],/nan)
   endfor
  endfor
  endfor
check, arr

  set_plot, 'ps'
  device, file='bin_sensitivity.ler_omi.ps', /helvetica, font_size=14, /color
  !p.font=0
  loadct, 0
  ctable = 55
  contour, arr[*,*,0], prss, scas, /nodata, $
   xrange=[600,1000], xtitle='Pressure [hPa]', $
   yrange=[60,170], ytitle='Scattering Angle', $
   ystyle=1, $
   position = [.1,.25,.9,.95]
  loadct, ctable
  colors = findgen(9)*30
  levels = .0375+findgen(9)*.0015
  contour, /over, arr[*,*,0], prss, scas, $ 
   levels=levels, /cell, c_color=colors
  loadct, 0
  contour, arr[*,*,0], prss, scas, /nodata, /noerase, $
   xrange=[600,1000], xtitle='Pressure [hPa]', $
   yrange=[60,170], ytitle='Scattering Angle', $
   ystyle=1, $
   position = [.1,.25,.9,.95]
  makekey, .1, .05, .8, .05, 0, -0.035, color=colors, $
   label=string(levels,format='(f6.4)'), align=0
  loadct, ctable
  makekey, .1, .05, .8, .05, 0, -0.035, color=colors, $
   label=[' ',' ']

  device, /close


; ai_omi
  for i = 0, 2 do begin
  for j = 0, nprs-1 do begin
   for k = 0, nsca-1 do begin
    a = where(sca[*,*,i,j] ge scas[k]-dsca/2. and $
              sca[*,*,i,j] lt scas[k]+dsca/2.)
    if(a[0] ne -1) then arr[j,k,i] = mean(ai_omi[a,i,j],/nan)
   endfor
  endfor
  endfor
check, arr

  set_plot, 'ps'
  device, file='bin_sensitivity.ai_omi.ps', /helvetica, font_size=14, /color
  !p.font=0
  loadct, 0
  ctable = 55
  contour, arr[*,*,0], prss, scas, /nodata, $
   xrange=[600,1000], xtitle='Pressure [hPa]', $
   yrange=[60,170], ytitle='Scattering Angle', $
   ystyle=1, $
   position = [.1,.25,.9,.95]
  loadct, ctable
  colors = findgen(11)*25
  levels = findgen(11)*.05
  contour, /over, arr[*,*,0], prss, scas, $ 
   levels=levels, /cell, c_color=colors
  loadct, 0
  contour, arr[*,*,0], prss, scas, /nodata, /noerase, $
   xrange=[600,1000], xtitle='Pressure [hPa]', $
   yrange=[60,170], ytitle='Scattering Angle', $
   ystyle=1, $
   position = [.1,.25,.9,.95]
  makekey, .1, .05, .8, .05, 0, -0.035, color=colors, $
   label=string(levels,format='(f4.2)'), align=0
  loadct, ctable
  makekey, .1, .05, .8, .05, 0, -0.035, color=colors, $
   label=[' ',' ']

  device, /close


; Make a final plot for the paper
  plotfile = 'bin_sensitivity.ps'
  set_plot, 'ps'
  device, file=plotfile, /helvetica, font_size=14, /color, $
   xsize=24, ysize=24, xoff=.5, yoff=.5
  !p.font=0
  

; Panel 1: Fractional difference in Spherical Albedo
  for i = 0, 2 do begin
  for j = 0, nprs-1 do begin
   for k = 0, nsca-1 do begin
    a = where(sca[*,*,i,j] ge scas[k]-dsca/2. and $
              sca[*,*,i,j] lt scas[k]+dsca/2.)
    if(a[0] ne -1) then arr[j,k,i] = mean(fspher[a,i,j],/nan)*100.
   endfor
  endfor
  endfor
  loadct, 0
  ctable = 55
  contour, arr[*,*,0], prss, scas, /nodata, $
   position=[.075,.65,.45,.975], $
   xrange=[600,1000], xtitle='Pressure [hPa]', $
   yrange=[60,170], ytitle='Scattering Angle', $
   ystyle=1, charsize=.75
  loadct, ctable
  colors = findgen(9)*30
  levels = (findgen(9)*.002+.002)*100
  contour, /over, arr[*,*,0], prss, scas, $ 
   levels=levels, /cell, c_color=colors
  loadct, 0
  xyouts, .075, .985, /normal, charsize=.75, $
   'a) Spherical Albedo (%-difference)'
  contour, arr[*,*,0], prss, scas, /nodata, /noerase, $
   position=[.075,.65,.45,.975], $
   xrange=[600,1000], xtitle='Pressure [hPa]', $
   yrange=[60,170], ytitle='Scattering Angle', $
   ystyle=1, charsize=.75

  loadct, 0
  makekey, .08, .555, .355, .035, 0, -0.025, color=colors, $
   label=string(levels,format='(f3.1)'), align=0, charsize=.75
  loadct, ctable
  makekey, .08, .555, .355, .035, 0, -0.025, color=colors, $
   label=[' ',' '], charsize=.75



; Panel 2: Fractional difference in i388c
  for i = 0, 2 do begin
  for j = 0, nprs-1 do begin
   for k = 0, nsca-1 do begin
    a = where(sca[*,*,i,j] ge scas[k]-dsca/2. and $
              sca[*,*,i,j] lt scas[k]+dsca/2.)
    if(a[0] ne -1) then arr[j,k,i] = mean(fi388c[a,i,j],/nan)*100.
   endfor
  endfor
  endfor
  loadct, 0
  ctable = 55
  contour, arr[*,*,0], prss, scas, /nodata, /noerase, $
   position=[.575,.65,.95,.975], $
   xrange=[600,1000], xtitle='Pressure [hPa]', $
   yrange=[60,170], ytitle='Scattering Angle', $
   ystyle=1, charsize=.75
  loadct, ctable
  colors = findgen(9)*30
  levels = (findgen(9)*.003+.003)*100
  contour, /over, arr[*,*,0], prss, scas, $ 
   levels=levels, /cell, c_color=colors
  loadct, 0
  xyouts, .575, .985, /normal, charsize=.75, $
   'b) I!ERay!N  atmospheric radiance (%-difference)'
  xyouts, .575, .985, /normal, charsize=.75, $
   'b) I!D388!N '
  contour, arr[*,*,0], prss, scas, /nodata, /noerase, $
   position=[.575,.65,.95,.975], $
   xrange=[600,1000], xtitle='Pressure [hPa]', $
   yrange=[60,170], ytitle='Scattering Angle', $
   ystyle=1, charsize=.75

  loadct, 0
  makekey, .58, .555, .355, .035, 0, -0.025, color=colors, $
   label=string(levels,format='(f3.1)'), align=0, charsize=.75
  loadct, ctable
  makekey, .58, .555, .355, .035, 0, -0.025, color=colors, $
   label=[' ',' '], charsize=.75



; Panel 3: LER
  for i = 0, 2 do begin
  for j = 0, nprs-1 do begin
   for k = 0, nsca-1 do begin
    a = where(sca[*,*,i,j] ge scas[k]-dsca/2. and $
              sca[*,*,i,j] lt scas[k]+dsca/2.)
    if(a[0] ne -1) then arr[j,k,i] = mean(ler_omi[a,i,j],/nan)
   endfor
  endfor
  endfor
  loadct, 0
  ctable = 55
  contour, arr[*,*,0], prss, scas, /nodata, /noerase, $
   position=[0.075,.15,.45,.475], $
   xrange=[600,1000], xtitle='Pressure [hPa]', $
   yrange=[60,170], ytitle='Scattering Angle', $
   ystyle=1, charsize=.75
  loadct, ctable
  colors = reverse(findgen(5)*45)+70
  levels = .04+findgen(5)*.002
  contour, /over, arr[*,*,0], prss, scas, $ 
   levels=levels, /cell, c_color=colors
  loadct, 0
  xyouts, .075, .485, /normal, charsize=.75, $
   'c) OMAERUV returned LER'
  contour, arr[*,*,0], prss, scas, /nodata, /noerase, $
   position=[.075,.15,.45,.475], $
   xrange=[600,1000], xtitle='Pressure [hPa]', $
   yrange=[60,170], ytitle='Scattering Angle', $
   ystyle=1, charsize=.75

  loadct, 0
  makekey, .08, .055, .355, .035, 0, -0.025, color=colors, $
   label=string(levels,format='(f5.3)'), align=0, charsize=.75
  loadct, ctable
  makekey, .08, .055, .355, .035, 0, -0.025, color=colors, $
   label=[' ',' '], charsize=.75



; Panel 4: AI
  for i = 0, 2 do begin
  for j = 0, nprs-1 do begin
   for k = 0, nsca-1 do begin
    a = where(sca[*,*,i,j] ge scas[k]-dsca/2. and $
              sca[*,*,i,j] lt scas[k]+dsca/2.)
    if(a[0] ne -1) then arr[j,k,i] = mean(ai_omi[a,i,j],/nan)
   endfor
  endfor
  endfor
  loadct, 0
  ctable = 55
  contour, arr[*,*,0], prss, scas, /nodata, /noerase, $
   position=[0.575,.15,.95,.475], $
   xrange=[600,1000], xtitle='Pressure [hPa]', $
   yrange=[60,170], ytitle='Scattering Angle', $
   ystyle=1, charsize=.75
  loadct, ctable
  colors = findgen(6)*45
  levels = findgen(6)*.1
  contour, /over, arr[*,*,0], prss, scas, $ 
   levels=levels, /cell, c_color=colors
  loadct, 0
  xyouts, .575, .485, /normal, charsize=.75, $
   'd) OMAERUV returned AI'
  contour, arr[*,*,0], prss, scas, /nodata, /noerase, $
   position=[.575,.15,.95,.475], $
   xrange=[600,1000], xtitle='Pressure [hPa]', $
   yrange=[60,170], ytitle='Scattering Angle', $
   ystyle=1, charsize=.75

  loadct, 0
  makekey, .58, .055, .355, .035, 0, -0.025, color=colors, $
   label=string(levels,format='(f5.1)'), align=0, charsize=.75
  loadct, ctable
  makekey, .58, .055, .355, .035, 0, -0.025, color=colors, $
   label=[' ',' '], charsize=.75

device, /close

end
