; Colarco, February 2016
; Make a plot of the AI difference between OMAERUV own pressure and
; MERRAero, sorting on the pressure difference.  Two panels:
; 1) PDF of AI difference/pressure difference, showing frequency
; 2) AI difference vs. MERRAero AI sorted on pressure difference

; Setup the plot
  plotfile = 'figure03.ai_pressure_scatter.ps'
  set_plot, 'ps'
  device, file=plotfile, /helvetica, font_size=14, /color, $
   xsize=42, ysize=12, xoff=.5, yoff=.5
  !p.font=0


; Files
; Model calculated AI results
  files  = file_search('/misc/prc14/colarco/aura/dR_MERRA-AA-r2-v1621f_Full/', $
                       'OMI-Aura_L2-OMAERUV_2007m06*vl_rad.geos5_pressure.he5')

; OMAERUV returned (with own surface pressure)
  ofilesd = '/misc/prc14/colarco/aura/dR_MERRA-AA-r2-v1621f_Full_returned/POMI/'
; OMAERUV returned (with own MERRA pressure)
  gfilesd = '/misc/prc14/colarco/aura/dR_MERRA-AA-r2-v1621f_Full_returned/PGEO/'
; OMAERUV surface pressure fields
  pfilesd = '/misc/prc14/colarco/aura/dR_MERRA-AA-r2-v1621f_Full/'


; Read the files and get a variable
  for ifile = 0, n_elements(files)-1 do begin
;  for ifile = 0, 10 do begin

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
print, ifile, n_elements(files)-1, ' ', files[ifile], n_elements(prs_), nxy
    prs_    = reform(prs_,nxy)
    h5f_close, file_id

;   Get the OMI returned values and map
    filet = str2[0]
    filen = ofilesd+strmid(filet,20,21)+'_OMAERUVx_Outputs.nc4'
    result = file_search(filen)
    if(result eq '') then goto, jump1
    cdfid = ncdf_open(filen)
    id    = ncdf_varid(cdfid,'ai')
    ncdf_varget, cdfid, id, res_
    ncdf_close, cdfid
    res_ = reform(res_,nxy)

;   Get the OMI (PGEO) returned values and map
    filet = str2[0]
    filen = gfilesd+strmid(filet,20,21)+'_OMAERUVx_Outputs.nc4'
    result = file_search(filen)
    if(result eq '') then goto, jump1
    cdfid = ncdf_open(filen)
    id    = ncdf_varid(cdfid,'ai')
    ncdf_varget, cdfid, id, res__
    ncdf_close, cdfid
    res__ = reform(res__,nxy)

    if(ifile eq 0) then begin
     rex = rex_
     res = res_
     resg = res__
     prx = prx_
     prs = prs_
     lon = lon_
     lat = lat_
    endif else begin
     rex = [rex,rex_]
     res = [res,res_]
     resg = [resg,res__]
     prx = [prx,prx_]
     prs = [prs,prs_]
     lon = [lon,lon_]
     lat = [lat,lat_]
    endelse

    goto, jump2
jump1: print, 'missing: ', filen
jump2:
  endfor

; Differences are OMAERUV - MERRAero
  a = where(res gt -1.e14 and rex gt -1.e14)
  lon = lon[a]
  lat = lat[a]
  res = res[a]
  resg = resg[a]
  rex = rex[a]
  prs = prs[a]
  prx = prx[a]
  pdiff  = prs - prx
  aidiff = res - rex
  aigdiff = resg - rex
  ai = rex


; Panel 1: Joint PDF of AI and Surface Pressure Differences
  result = hist_2d(aidiff,pdiff,min1=-3.,min2=-200.,max1=3.,max2=200.,bin1=.05,bin2=2.)
  loadct, 0
  plot, findgen(10), /nodata, $
   position=[.05,.25,.33,.925], $
   xrange=[-2,2], yrange=[-150,150], $
   xtitle='AI Difference: OMAERUV (own pressure) - MERRAero', $
   ytitle='Surface Pressure Difference [hPa]!COMAERUV - MERRAero', $
        charsize=.75
  xyouts, .05, .935, /normal, charsize=.75, $
   'a) Frequency Distribution of AI and Surface Pressure Differences'

  x = -3 + findgen(121)*.05
  y = -200. + findgen(201)*2.
  dx = .05
  dy = 2.
  loadct, 74
  level = [10,20,50,100,200,500,1000,2000,5000,10000,20000,50000]
  color = findgen(12)*23
  plotgrid, result, level, color, x, y, dx, dy
;  contour, /overplot, result, x, y, lev=level, /fill
  
  loadct, 0
  labels = ['10','20','50','100','200','500','1000','2000','5000','10000','20000','50000']
  makekey, .065, .08, .25, .05, 0, -0.035, $
           charsize=.5, align=0, colors=make_array(12,val=0), $
           labels=labels, /noborder
  xyouts, .19, .015, /normal, 'Frequency', $
   charsize=.75, align=.5

  loadct, 74
  labels = make_array(12,val=' ')
  makekey, .065, .08, .25, .05, 0, -0.035, $
           charsize=.75, align=0, colors=color, $
           labels=labels, /noborder




; Panel 2: Joint PDF of AI Difference and Surface Pressure
  result = hist_2d(aidiff,prx,min1=-3.,min2=600.,max1=3.,max2=1100.,bin1=.05,bin2=2.5)
  loadct, 0
  plot, findgen(10), /nodata, /noerase, $
   position=[.38,.25,.66,.925], $
   xrange=[-2,2], yrange=[1000,600], $
   xtitle='AI Difference: OMAERUV (own pressure) - MERRAero', $
   ytitle='Surface Pressure [hPa]', $
        charsize=.75
  xyouts, .38, .935, /normal, charsize=.75, $
   'b) Frequency Distribution of AI Difference and Surface Pressure'

  x = -3 + findgen(121)*.05
  y = 600. + findgen(201)*2.5
  dx = .05
  dy = 2.
  loadct, 74
  level = [10,20,50,100,200,500,1000,2000,5000,10000,20000,50000]
  color = findgen(12)*23
  plotgrid, result, level, color, x, y, dx, dy
;  contour, /overplot, result, x, y, lev=level, /fill


  loadct, 0
  labels = ['10','20','50','100','200','500','1000','2000','5000','10000','20000','50000']
  makekey, .395, .08, .25, .05, 0, -0.035, $
           charsize=.5, align=0, colors=make_array(12,val=0), $
           labels=labels, /noborder
  xyouts, .52, .015, /normal, 'Frequency', $
   charsize=.75, align=.5

  loadct, 74
  labels = make_array(12,val=' ')
  makekey, .395, .08, .25, .05, 0, -0.035, $
           charsize=.75, align=0, colors=color, $
           labels=labels, /noborder



; Panel 3: 
  pdiff  = prs - prx
  a = where(pdiff lt -100)
  pdiff[a] = -100.
  a = where(pdiff gt 100.)
  pdiff[a] = 100.
  pdiff = pdiff+100.
  pdiff = pdiff/200.*254

  loadct, 0
  plot, findgen(10), /nodata, /noerase, $
   position=[.71,.25,.99,.92], $
   xrange=[-1,5], yrange=[-2,3], charsize=.75, $
   xtitle='MERRAero Aerosol Index', $
   ytitle='AI Difference: OMAERUV - MERRAero'
  xyouts, .71, .935, /normal, charsize=.75, $
   'b) Distribution of AI and Surface Pressure Differences'
  xyouts, 1, 2.75, 'Colored: OMAERUV difference (own pressure)', charsize=.65
  xyouts, 1, 2.5,  'Grey: OMAERUV difference (MERRAero pressure)', color=144, charsize=.65

  loadct, 74
  plots, ai, aidiff, psym=3, color=pdiff, noclip=0
a = where(abs(aidiff) gt 0.2)
print, n_elements(aidiff), n_elements(a), float(n_elements(a))/float(n_elements(aidiff))

  loadct, 0
  plots, ai, aigdiff, psym=3, color=144, noclip=0
a = where(abs(aigdiff) gt 0.2)
print, n_elements(aidiff), n_elements(a), float(n_elements(a))/float(n_elements(aidiff))

  labels = ['-100','-50','0','50','100']
  makekey, .725, .08, .25, .05, 0, -0.035, $
           charsize=.75, align=.5, colors=findgen(254), $
           labels=labels, /noborder
  xyouts, .85, .015, /normal, 'Surface Pressure Difference [hPa]: OMAERUV - MERRAero', $
   charsize=.75, align=.5

  loadct, 74
  labels = [' ',' ',' ',' ',' ']
  makekey, .725, .08, .25, .05, 0, -0.035, $
           charsize=.75, align=.5, colors=findgen(254), $
           labels=labels, /noborder


; Original go at Panel 3:
goto, jump

; Panel 3: 
  pdiff  = prs - prx

  a = where(aidiff gt 2)
  aidiff[a] = 2.
  a = where(aidiff lt -2)
  aidiff[a] = -2.
  aidiff = aidiff+2.
  aidiff = aidiff/4.*254

  loadct, 0
  plot, findgen(10), /nodata, /noerase, $
   position=[.71,.25,.99,.92], $
   xrange=[600,1100], yrange=[-200,200], charsize=.75, $
   xtitle='OMAERUV Surface Pressure [hPa]', $
   ytitle='Surface Pressure Difference [hPa]!COMAERUV - MERRAero'
  xyouts, .71, .935, /normal, charsize=.75, $
   'c) Distribution of AI and Surface Pressure Differences'
;  xyouts, 1, 2.75, 'Colored: OMAERUV difference (own pressure)', charsize=.65
;  xyouts, 1, 2.5,  'Grey: OMAERUV difference (MERRAero pressure)', color=144, charsize=.65

  loadct, 74
  plots, prs, pdiff, psym=3, color=aidiff, noclip=0
;a = where(abs(aidiff) gt 0.2)
;print, n_elements(aidiff), n_elements(a), float(n_elements(a))/float(n_elements(aidiff))

  loadct, 0
;  plots, prs, aigdiff, psym=3, color=144, noclip=0
;a = where(abs(aigdiff) gt 0.2)
;print, n_elements(aidiff), n_elements(a), float(n_elements(a))/float(n_elements(aidiff))

  labels = ['-2','-1','0','1','2']
  makekey, .725, .08, .25, .05, 0, -0.035, $
           charsize=.75, align=.5, colors=findgen(254), $
           labels=labels, /noborder
  xyouts, .85, .015, /normal, 'AI Difference: OMAERUV!Down pressure!N - MERRAero', $
   charsize=.75, align=.5

  loadct, 74
  labels = [' ',' ',' ',' ',' ']
  makekey, .725, .08, .25, .05, 0, -0.035, $
           charsize=.75, align=.5, colors=findgen(254), $
           labels=labels, /noborder


jump:

  device, /close
  

end
