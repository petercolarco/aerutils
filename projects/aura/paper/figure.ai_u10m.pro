; Colarco, February 2016
; Make a plot of the AI difference between OMAERUV own pressure and
; MERRAero, sorting on the pressure difference.  Two panels:
; 1) PDF of AI difference/pressure difference, showing frequency
; 2) AI difference vs. MERRAero AI sorted on pressure difference

restore, 'u10m.sav'
goto,jump

; Files
; Model calculated AI results
  files  = file_search('/misc/prc14/colarco/aura/dR_MERRA-AA-r2-v1621f_Full_u10m/', $
                       'OMI-Aura_L2-OMAERUV_2007m06*vl_rad.geos5_pressure.he5')
;  a = where(strpos(files,'2007m0605') ne -1)
;  files = files[a]

; model files with assumed surface wind
  ofilesd = '/misc/prc14/colarco/aura/dR_MERRA-AA-r2-v1621f_Full/'
; OMAERUV surface pressure fields
  pfilesd = '/misc/prc14/colarco/aura/dR_MERRA-AA-r2-v1621f_Full/'


; Read the files and get a variable
  for ifile = 0, n_elements(files)-1 do begin
print, ifile, n_elements(files)-1, ' ', files[ifile]

;   Get the level 2 for the lat/lon
    file_id = h5f_open(files[ifile])
    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/Longitude')
    lon_    = h5d_read(var_id)
    nxy     = n_elements(lon_)
    lon_    = reform(lon_,nxy)
    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/Latitude')
    lat_    = h5d_read(var_id)
    sz      = size(lat_)
    nx      = sz[1]
    ny      = sz[2]
    lat_    = reform(lat_,nxy)
    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/UVAerosolIndex')
    rex_    = h5d_read(var_id)
    rex_    = reform(rex_,nxy)
    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/TerrainPressure')
    prx_    = h5d_read(var_id)
    prx_    = reform(prx_,nxy)
    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/u10m')
    u10m_    = h5d_read(var_id)
    u10m_    = reform(u10m_,nxy)
    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/v10m')
    v10m_    = h5d_read(var_id)
    v10m_    = reform(v10m_,nxy)
    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/ViewingZenithAngle')
    vza_    = h5d_read(var_id)
    vza_    = reform(vza_,nxy)
    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/SolarZenithAngle')
    sza_    = h5d_read(var_id)
    sza_    = reform(sza_,nxy)
    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/RelativeAzimuthAngle')
    raa_    = h5d_read(var_id)
    raa_    = reform(raa_,nxy)
    h5f_close, file_id
u10m_ = sqrt(u10m_^2 + v10m_^2)

;   Get the static u10m ai filename
    str1 = strsplit(files[ifile],'/',/extract,count=n)
    filet = str1[n-1]
    filen = ofilesd+filet
    result = file_search(filen)
    if(result eq '') then goto, jump1
    file_id = h5f_open(filen)
    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/UVAerosolIndex')
    res_    = h5d_read(var_id)
    res_    = reform(res_,nxy)
    h5f_close, file_id

;   Get the pressure filename
    str1 = strsplit(files[ifile],'/',/extract,count=n)
    str2 = strsplit(str1[n-1],'.',/extract)
    filet = str2[0]
    filen = pfilesd+filet+'.vl_rad.he5'
    result = file_search(filen)
    if(result eq '') then goto, jump1
    file_id = h5f_open(filen)
    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/TerrainPressure')
    prs_    = h5d_read(var_id)
    prs_    = reform(prs_,nxy)
    h5f_close, file_id

    if(ifile eq 0) then begin
     rex = rex_
     res = res_
     u10m = u10m_
     prx = prx_
     prs = prs_
     lon = lon_
     lat = lat_
     vza = vza_
     sza = sza_
     raa = raa_
    endif else begin
     rex = [rex,rex_]
     res = [res,res_]
     u10m = [u10m,u10m_]
     prx = [prx,prx_]
     prs = [prs,prs_]
     lon = [lon,lon_]
     lat = [lat,lat_]
     vza = [vza,vza_]
     sza = [sza,sza_]
     raa = [raa,raa_]
    endelse

    goto, jump2
jump1: print, 'missing: ', filen
jump2:
  endfor

; Differences are OMAERUV - MERRAero
  a = where(res gt -1.e14 and rex gt -1.e14 and prx lt 1013.25)  ; OMAERUV out of bounds for pressures > 1013.25 hPa
  lon = lon[a]
  lat = lat[a]
  res = res[a]
  u10m = u10m[a]
  rex = rex[a]
  prx = prx[a]
  prs = prs[a]
  aidiff = res - rex
  ai = rex
  vza = vza[a]
  sza = sza[a]
  raa = raa[a]

; Now restrict to over ocean points, determined by the prs surface
; pressure from OMAERUV
  a = where(prs ge 1013.)
  lon = lon[a]
  lat = lat[a]
  res = res[a]
  u10m = u10m[a]
  rex = rex[a]
  prx = prx[a]
  prs = prs[a]
  aidiff = res - rex
  ai = rex
  vza = vza[a]
  sza = sza[a]
  raa = raa[a]

  save, file='u10m.sav', /all

jump:
; Calculate scattering angle
  mu0  = cos(sza/360.*2.*!pi)
  mu   = cos(vza/360.*2.*!pi)
  ra   = cos(raa/360.*2.*!pi)
  sca  = 360./2./!pi*acos(-mu0*mu+ra*sqrt((1.-mu0)*(1.-mu)))

; Setup the plot
  plotfile = 'figure.ai_u10m.ps'
  set_plot, 'ps'
  device, file=plotfile, /helvetica, font_size=14, /color, $
   xsize=32, ysize=12, xoff=.5, yoff=.5
  !p.font=0

; Panel 1: Joint PDF of AI and wind speed
  result = hist_2d(aidiff,u10m,min1=-7.,min2=0.,max1=2.,max2=25.,bin1=.05,bin2=1.)
  loadct, 0
  plot, findgen(10), /nodata, $
   position=[.075,.25,.45,.925], $
   yrange=[-2,2], xrange=[0,25], $
   ytitle='AI Difference!CMERRAero (actual winds) - MERRAero (6 m s!E-1!N)', $
   xtitle='10-m wind speed [m s!E-1!N]', $
        charsize=.75
  xyouts, .075, .935, /normal, charsize=.75, $
   'a) Histogram of !9D!3AI and 10-m wind speed'

  y = -7 + findgen(181)*.05
  x = findgen(26)
  dy = .05
  dx = 1.
  loadct, 74
  level = [10,20,50,100,200,500,1000,2000,5000,10000,20000,50000]
  color = findgen(12)*23
  plotgrid, transpose(result), level, color, x, y, dx, dy
;  contour, /overplot, result, x, y, lev=level, /fill
  
  loadct, 0
  labels = ['10','20','50','100','200','500','1000','2000','5000','10000','20000','50000']
  makekey, .1125, .08, .3, .05, 0, -0.035, $
           charsize=.5, align=0, colors=make_array(12,val=0), $
           labels=labels, /noborder
  xyouts, .26, .015, /normal, 'Frequency', $
   charsize=.75, align=.5

  loadct, 74
  labels = make_array(12,val=' ')
  makekey, .1125, .08, .3, .05, 0, -0.035, $
           charsize=.75, align=0, colors=color, $
           labels=labels, /noborder

; Panel 2: Joint PDF of AI and sza
; Find the sunglint angle.  For angle < threshold 40 degrees OMI would
; make lesser (or no?) aerosol retrievals
  sza_ = sza/360.*2.*!pi
  vza_ = vza/360.*2.*!pi
  raa_ = raa/360.*2.*!pi
  gang = acos(cos(sza)*cos(vza) + sin(sza)*sin(vza)*cos(raa))*360./2./!pi
  ga = where(gang lt 40.)

  result = hist_2d(aidiff,sza,min1=-7.,min2=0.,max1=2.,max2=75.,bin1=.05,bin2=3.)
  loadct, 0
  plot, findgen(10), /nodata, /noerase, $
   position=[.55,.25,.975,.925], $
   yrange=[-2,2], xrange=[0,75], $
   ytitle='AI Difference!CMERRAero (actual winds) - MERRAero (6 m s!E-1!N)', $
   xtitle='solar zenith angle [degrees]', $
        charsize=.75
  xyouts, .55, .935, /normal, charsize=.75, $
   'b) Histogram of !9D!3AI and solar zenith angle'

  y = -7 + findgen(181)*.05
  x = findgen(26)*3
  dy = .05
  dx = 3.
  loadct, 74
  level = [10,20,50,100,200,500,1000,2000,5000,10000,20000,50000]
  color = findgen(12)*23
  plotgrid, transpose(result), level, color, x, y, dx, dy
;  contour, /overplot, result, x, y, lev=level, /fill
  
  loadct, 0
  labels = ['10','20','50','100','200','500','1000','2000','5000','10000','20000','50000']
  makekey, .5875, .08, .3, .05, 0, -0.035, $
           charsize=.5, align=0, colors=make_array(12,val=0), $
           labels=labels, /noborder
  xyouts, .76, .015, /normal, 'Frequency', $
   charsize=.75, align=.5

  loadct, 74
  labels = make_array(12,val=' ')
  makekey, .5875, .08, .3, .05, 0, -0.035, $
           charsize=.75, align=0, colors=color, $
           labels=labels, /noborder

;; Panel 2: histogram of AI differences
;  result = histogram(aidiff,min=-2,max=2,nbins=21)
;  result = result/total(result)
;  cum = result
;  for i = 1, 20 do begin
;   cum[i] = cum[i]+cum[i-1]
;  endfor

;  loadct, 0
;  plot, findgen(10), /nodata, /noerase, $
;   position=[.55,.25,.975,.92], $
;   xrange=[-2,2], charsize=.75, yrange=[0,1], $
;   xtitle='AI Difference', $
;   ytitle='Frequency'
;  xyouts, .55, .935, /normal, charsize=.75, $
;   'b) Histogram of !9D!3AI'

;  oplot, findgen(21)*.2-2, result, thick=8, color=120
;  oplot, findgen(21)*.2-2, cum, thick=2


; Panel 1: Joint PDF of AI and wind speed
  result = hist_2d(aidiff,u10m,min1=-7.,min2=0.,max1=2.,max2=25.,bin1=.05,bin2=1.)
  loadct, 0
  plot, findgen(10), /nodata, $
   position=[.075,.25,.45,.925], $
   yrange=[-2,2], xrange=[0,25], $
   ytitle='AI Difference!CMERRAero (actual winds) - MERRAero (6 m s!E-1!N)', $
   xtitle='10-m wind speed [m s!E-1!N]', $
        charsize=.75
  xyouts, .075, .935, /normal, charsize=.75, $
   'a) Histogram of !9D!3AI and 10-m wind speed'

  y = -7 + findgen(181)*.05
  x = findgen(26)
  dy = .05
  dx = 1.
  loadct, 74
  level = [10,20,50,100,200,500,1000,2000,5000,10000,20000,50000]
  color = findgen(12)*23
  plotgrid, transpose(result), level, color, x, y, dx, dy
;  contour, /overplot, result, x, y, lev=level, /fill
  
  loadct, 0
  labels = ['10','20','50','100','200','500','1000','2000','5000','10000','20000','50000']
  makekey, .1125, .08, .3, .05, 0, -0.035, $
           charsize=.5, align=0, colors=make_array(12,val=0), $
           labels=labels, /noborder
  xyouts, .26, .015, /normal, 'Frequency', $
   charsize=.75, align=.5

  loadct, 74
  labels = make_array(12,val=' ')
  makekey, .1125, .08, .3, .05, 0, -0.035, $
           charsize=.75, align=0, colors=color, $
           labels=labels, /noborder

; Panel 2: Joint PDF of AI and sza
; Find the sunglint angle.  For angle < threshold 40 degrees OMI would
; make lesser (or no?) aerosol retrievals
  sza_ = sza/360.*2.*!pi
  vza_ = vza/360.*2.*!pi
  raa_ = raa/360.*2.*!pi
  gang = acos(cos(sza)*cos(vza) + sin(sza)*sin(vza)*cos(raa))*360./2./!pi
  ga = where(gang lt 40.)

  a = where(u10m ge 6.)

  result = hist_2d(aidiff[a],sza[a],min1=-7.,min2=0.,max1=2.,max2=75.,bin1=.05,bin2=3.)
  loadct, 0
  plot, findgen(10), /nodata, /noerase, $
   position=[.55,.25,.975,.925], $
   yrange=[-2,2], xrange=[0,75], $
   ytitle='AI Difference!CMERRAero (actual winds) - MERRAero (6 m s!E-1!N)', $
   xtitle='solar zenith angle [degrees]', $
        charsize=.75
  xyouts, .55, .935, /normal, charsize=.75, $
   'b) Histogram of !9D!3AI and solar zenith angle (u10m > 6 m s!E-1!N)'

  y = -7 + findgen(181)*.05
  x = findgen(26)*3
  dy = .05
  dx = 3.
  loadct, 74
  level = [10,20,50,100,200,500,1000,2000,5000,10000,20000,50000]
  color = findgen(12)*23
  plotgrid, transpose(result), level, color, x, y, dx, dy
;  contour, /overplot, result, x, y, lev=level, /fill
  
  loadct, 0
  labels = ['10','20','50','100','200','500','1000','2000','5000','10000','20000','50000']
  makekey, .5875, .08, .3, .05, 0, -0.035, $
           charsize=.5, align=0, colors=make_array(12,val=0), $
           labels=labels, /noborder
  xyouts, .76, .015, /normal, 'Frequency', $
   charsize=.75, align=.5

  loadct, 74
  labels = make_array(12,val=' ')
  makekey, .5875, .08, .3, .05, 0, -0.035, $
           charsize=.75, align=0, colors=color, $
           labels=labels, /noborder



;;;;;;
; Panel 1: Joint PDF of AI and wind speed
  result = hist_2d(aidiff,u10m,min1=-7.,min2=0.,max1=2.,max2=25.,bin1=.05,bin2=1.)
  loadct, 0
  plot, findgen(10), /nodata, $
   position=[.075,.25,.45,.925], $
   yrange=[-2,2], xrange=[0,25], $
   ytitle='AI Difference!CMERRAero (actual winds) - MERRAero (6 m s!E-1!N)', $
   xtitle='10-m wind speed [m s!E-1!N]', $
        charsize=.75
  xyouts, .075, .935, /normal, charsize=.75, $
   'a) Histogram of !9D!3AI and 10-m wind speed'

  y = -7 + findgen(181)*.05
  x = findgen(26)
  dy = .05
  dx = 1.
  loadct, 74
  level = [10,20,50,100,200,500,1000,2000,5000,10000,20000,50000]
  color = findgen(12)*23
  plotgrid, transpose(result), level, color, x, y, dx, dy
;  contour, /overplot, result, x, y, lev=level, /fill
  
  loadct, 0
  labels = ['10','20','50','100','200','500','1000','2000','5000','10000','20000','50000']
  makekey, .1125, .08, .3, .05, 0, -0.035, $
           charsize=.5, align=0, colors=make_array(12,val=0), $
           labels=labels, /noborder
  xyouts, .26, .015, /normal, 'Frequency', $
   charsize=.75, align=.5

  loadct, 74
  labels = make_array(12,val=' ')
  makekey, .1125, .08, .3, .05, 0, -0.035, $
           charsize=.75, align=0, colors=color, $
           labels=labels, /noborder

; Panel 2: Joint PDF of AI and vza
; Find the sunglint angle.  For angle < threshold 40 degrees OMI would
; make lesser (or no?) aerosol retrievals
  sza_ = sza/360.*2.*!pi
  vza_ = vza/360.*2.*!pi
  raa_ = raa/360.*2.*!pi
  gang = acos(cos(sza)*cos(vza) + sin(sza)*sin(vza)*cos(raa))*360./2./!pi
  ga = where(gang lt 40.)

  result = hist_2d(aidiff,vza,min1=-7.,min2=0.,max1=2.,max2=75.,bin1=.05,bin2=3.)
  loadct, 0
  plot, findgen(10), /nodata, /noerase, $
   position=[.55,.25,.975,.925], $
   yrange=[-2,2], xrange=[0,75], $
   ytitle='AI Difference!CMERRAero (actual winds) - MERRAero (6 m s!E-1!N)', $
   xtitle='viewing zenith angle [degrees]', $
        charsize=.75
  xyouts, .55, .935, /normal, charsize=.75, $
   'b) Histogram of !9D!3AI and viewing zenith angle'

  y = -7 + findgen(181)*.05
  x = findgen(26)*3
  dy = .05
  dx = 3.
  loadct, 74
  level = [10,20,50,100,200,500,1000,2000,5000,10000,20000,50000]
  color = findgen(12)*23
  plotgrid, transpose(result), level, color, x, y, dx, dy
;  contour, /overplot, result, x, y, lev=level, /fill
  
  loadct, 0
  labels = ['10','20','50','100','200','500','1000','2000','5000','10000','20000','50000']
  makekey, .5875, .08, .3, .05, 0, -0.035, $
           charsize=.5, align=0, colors=make_array(12,val=0), $
           labels=labels, /noborder
  xyouts, .76, .015, /normal, 'Frequency', $
   charsize=.75, align=.5

  loadct, 74
  labels = make_array(12,val=' ')
  makekey, .5875, .08, .3, .05, 0, -0.035, $
           charsize=.75, align=0, colors=color, $
           labels=labels, /noborder


;;;;;
; Panel 1: Joint PDF of AI and wind speed
  result = hist_2d(aidiff,u10m,min1=-7.,min2=0.,max1=2.,max2=25.,bin1=.05,bin2=1.)
  loadct, 0
  plot, findgen(10), /nodata, $
   position=[.075,.25,.45,.925], $
   yrange=[-2,2], xrange=[0,25], $
   ytitle='AI Difference!CMERRAero (actual winds) - MERRAero (6 m s!E-1!N)', $
   xtitle='10-m wind speed [m s!E-1!N]', $
        charsize=.75
  xyouts, .075, .935, /normal, charsize=.75, $
   'a) Histogram of !9D!3AI and 10-m wind speed'

  y = -7 + findgen(181)*.05
  x = findgen(26)
  dy = .05
  dx = 1.
  loadct, 74
  level = [10,20,50,100,200,500,1000,2000,5000,10000,20000,50000]
  color = findgen(12)*23
  plotgrid, transpose(result), level, color, x, y, dx, dy
;  contour, /overplot, result, x, y, lev=level, /fill
  
  loadct, 0
  labels = ['10','20','50','100','200','500','1000','2000','5000','10000','20000','50000']
  makekey, .1125, .08, .3, .05, 0, -0.035, $
           charsize=.5, align=0, colors=make_array(12,val=0), $
           labels=labels, /noborder
  xyouts, .26, .015, /normal, 'Frequency', $
   charsize=.75, align=.5

  loadct, 74
  labels = make_array(12,val=' ')
  makekey, .1125, .08, .3, .05, 0, -0.035, $
           charsize=.75, align=0, colors=color, $
           labels=labels, /noborder

; Panel 2: Joint PDF of AI and scattering angle
; Find the sunglint angle.  For angle < threshold 40 degrees OMI would
; make lesser (or no?) aerosol retrievals
  sza_ = sza/360.*2.*!pi
  vza_ = vza/360.*2.*!pi
  raa_ = raa/360.*2.*!pi
  scaang = 360./2./!pi*acos(-sza_*vza_+raa_*sqrt((1.-sza_)*(1.-vza_)))

  result = hist_2d(aidiff,scaang,min1=-7.,min2=0.,max1=2.,max2=175.,bin1=.05,bin2=7.)
  loadct, 0
  plot, findgen(10), /nodata, /noerase, $
   position=[.55,.25,.975,.925], $
   yrange=[-2,2], xrange=[0,175], $
   ytitle='AI Difference!CMERRAero (actual winds) - MERRAero (6 m s!E-1!N)', $
   xtitle='scattering angle [degrees]', $
        charsize=.75
  xyouts, .55, .935, /normal, charsize=.75, $
   'b) Histogram of !9D!3AI and scattering angle'

  y = -7 + findgen(181)*.05
  x = findgen(26)*7
  dy = .05
  dx = 7.
  loadct, 74
  level = [10,20,50,100,200,500,1000,2000,5000,10000,20000,50000]
  color = findgen(12)*23
  plotgrid, transpose(result), level, color, x, y, dx, dy
;  contour, /overplot, result, x, y, lev=level, /fill
  
  loadct, 0
  labels = ['10','20','50','100','200','500','1000','2000','5000','10000','20000','50000']
  makekey, .5875, .08, .3, .05, 0, -0.035, $
           charsize=.5, align=0, colors=make_array(12,val=0), $
           labels=labels, /noborder
  xyouts, .76, .015, /normal, 'Frequency', $
   charsize=.75, align=.5

  loadct, 74
  labels = make_array(12,val=' ')
  makekey, .5875, .08, .3, .05, 0, -0.035, $
           charsize=.75, align=0, colors=color, $
           labels=labels, /noborder



;;;;;
; Panel 1: Joint PDF of AI and wind speed
  result = hist_2d(aidiff,u10m,min1=-7.,min2=0.,max1=2.,max2=25.,bin1=.05,bin2=1.)
  loadct, 0
  plot, findgen(10), /nodata, $
   position=[.075,.25,.45,.925], $
   yrange=[-2,2], xrange=[0,25], $
   ytitle='AI Difference!CMERRAero (actual winds) - MERRAero (6 m s!E-1!N)', $
   xtitle='10-m wind speed [m s!E-1!N]', $
        charsize=.75
  xyouts, .075, .935, /normal, charsize=.75, $
   'a) Histogram of !9D!3AI and 10-m wind speed'

  y = -7 + findgen(181)*.05
  x = findgen(26)
  dy = .05
  dx = 1.
  loadct, 74
  level = [10,20,50,100,200,500,1000,2000,5000,10000,20000,50000]
  color = findgen(12)*23
  plotgrid, transpose(result), level, color, x, y, dx, dy
;  contour, /overplot, result, x, y, lev=level, /fill
  
  loadct, 0
  labels = ['10','20','50','100','200','500','1000','2000','5000','10000','20000','50000']
  makekey, .1125, .08, .3, .05, 0, -0.035, $
           charsize=.5, align=0, colors=make_array(12,val=0), $
           labels=labels, /noborder
  xyouts, .26, .015, /normal, 'Frequency', $
   charsize=.75, align=.5

  loadct, 74
  labels = make_array(12,val=' ')
  makekey, .1125, .08, .3, .05, 0, -0.035, $
           charsize=.75, align=0, colors=color, $
           labels=labels, /noborder

; Panel 2: Joint PDF of AI and scattering angle
; Find the sunglint angle.  For angle < threshold 40 degrees OMI would
; make lesser (or no?) aerosol retrievals
  sza_ = sza/360.*2.*!pi
  vza_ = vza/360.*2.*!pi
  raa_ = raa/360.*2.*!pi
  gang = acos(cos(sza)*cos(vza) + sin(sza)*sin(vza)*cos(raa))*360./2./!pi

  result = hist_2d(aidiff,gang,min1=-7.,min2=0.,max1=2.,max2=175.,bin1=.05,bin2=7.)
  loadct, 0
  plot, findgen(10), /nodata, /noerase, $
   position=[.55,.25,.975,.925], $
   yrange=[-2,2], xrange=[0,175], $
   ytitle='AI Difference!CMERRAero (actual winds) - MERRAero (6 m s!E-1!N)', $
   xtitle='glint angle [degrees]', $
        charsize=.75
  xyouts, .55, .935, /normal, charsize=.75, $
   'b) Histogram of !9D!3AI and glint angle'

  y = -7 + findgen(181)*.05
  x = findgen(26)*7
  dy = .05
  dx = 7.
  loadct, 74
  level = [10,20,50,100,200,500,1000,2000,5000,10000,20000,50000]
  color = findgen(12)*23
  plotgrid, transpose(result), level, color, x, y, dx, dy
;  contour, /overplot, result, x, y, lev=level, /fill
  
  loadct, 0
  labels = ['10','20','50','100','200','500','1000','2000','5000','10000','20000','50000']
  makekey, .5875, .08, .3, .05, 0, -0.035, $
           charsize=.5, align=0, colors=make_array(12,val=0), $
           labels=labels, /noborder
  xyouts, .76, .015, /normal, 'Frequency', $
   charsize=.75, align=.5

  loadct, 74
  labels = make_array(12,val=' ')
  makekey, .5875, .08, .3, .05, 0, -0.035, $
           charsize=.75, align=0, colors=color, $
           labels=labels, /noborder



  device, /close
  stop
; Plot some figures wrt viewing geometry
  set_plot, 'ps'
  device, file='angles.ps', /helvetica, font_size=12, $
   xoff=.5, yoff=.5, xsize=14, ysize=8
  !p.font=0
  !p.multi=[0,1,1]
  
  plot, indgen(10), /nodata, $
   xrange=[0,80], xtitle='solar zenith angle', $
   yrange=[-10,2], ytitle='AI difference (actual winds - 6 m s-1)'
  plots, sza, aidiff, psym=3
  plots, sza[ga], aidiff[ga], psym=3, color=180 

;  plot, indgen(10), /nodata, $
;   xrange=[0,80], xtitle='view zenith angle', $
;   yrange=[-10,2], ytitle='AI difference (actual winds - 6 m s-1)'
;  plots, vza, aidiff, psym=3
 
;  plot, indgen(10), /nodata, $
;   xrange=[0,180], xtitle='relative azimuth angle', $
;   yrange=[-10,2], ytitle='AI difference (actual winds - 6 m s-1)'
;  plots, raa, aidiff, psym=3
  device, /close
 


end
