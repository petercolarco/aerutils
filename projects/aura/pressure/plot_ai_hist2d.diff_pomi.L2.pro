; Files
  files  = file_search('/misc/prc14/colarco/aura/dR_MERRA-AA-r2-v1621f_Full/', $
                       'OMI-Aura_L2-OMAERUV_2007m06*vl_rad.geos5_pressure.he5')

  ofilesd = '/misc/prc14/colarco/aura/dR_MERRA-AA-r2-v1621f_Full_returned/POMI/'

  pfilesd = '/misc/prc14/colarco/aura/dR_MERRA-AA-r2-v1621f_Full/'


; Read the files and get a variable
  for ifile = 0, n_elements(files)-1 do begin

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
;print, files[ifile], n_elements(prs_), nxy
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

    if(ifile eq 0) then begin
     rex = rex_
     res = res_
     prx = prx_
     prs = prs_
     lon = lon_
     lat = lat_
    endif else begin
     rex = [rex,rex_]
     res = [res,res_]
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
  res = res[a]
  rex = rex[a]
  prs = prs[a]
  prx = prx[a]
  pdiff  = prs - prx
  aidiff = res - rex
  ai = rex

  result = hist_2d(aidiff,pdiff,min1=-3.,min2=-200.,max1=3.,max2=200.,bin1=.05,bin2=2.)

  plotfile = 'aidiff_hist2d.pomi.L2.ps'

  set_plot, 'ps'
  device, file=plotfile, /helvetica, font_size=14, /color, $
   xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  plot, findgen(10), /nodata, $
   position=[.15,.25,.9,.95], $
   xrange=[-2,2], yrange=[-150,150], $
   xtitle='OMAERUV - MERRAero AI Difference', $
        ytitle='OMAERUV - MERRAero!CSurface Pressure Difference [hPa]', $
        charsize=.75

  x = -3 + findgen(121)*.05
  y = -200. + findgen(201)*2.
  dx = .05
  dy = 2.
  loadct, 74
  level = [10,20,50,100,200,500,1000,2000,5000,10000,20000,50000]
  color = findgen(12)*23
  plotgrid, result, level, color, x, y, dx, dy
;  contour, /overplot, result, x, y, lev=level, /fill
  
a = where(abs(aidiff) gt 0.2)
print, n_elements(aidiff), n_elements(a), float(n_elements(a))/float(n_elements(aidiff))
  loadct, 0
  labels = ['10','20','50','100','200','500','1000','2000','5000','10000','20000','50000']
  makekey, .2, .08, .65, .05, 0, -0.035, $
           charsize=.5, align=0, colors=make_array(12,val=0), $
           labels=labels, /noborder
  xyouts, .525, .015, /normal, 'Frequency', $
   charsize=.75, align=.5

  loadct, 74
  labels = make_array(12,val=' ')
  makekey, .2, .08, .65, .05, 0, -0.035, $
           charsize=.75, align=0, colors=color, $
           labels=labels, /noborder

  device, /close
  

end
