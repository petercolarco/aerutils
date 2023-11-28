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
  pdiff  = prs - prx
  a = where(pdiff lt -50)
  pdiff[a] = -50.
  a = where(pdiff gt 50.)
  pdiff[a] = 50.
  pdiff = pdiff+50.
  pdiff = pdiff/100.*254
  aidiff = res - rex
  ai = rex

  plotfile = 'aidiff_scatter.pomi.L2.ps'

  set_plot, 'ps'
  device, file=plotfile, /helvetica, font_size=14, /color, $
   xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  plot, findgen(10), /nodata, $
   position=[.1,.25,.95,.95], $
   xrange=[-1,5], yrange=[-2,3], $
   xtitle='MERRAero Aerosol Index', $
   ytitle='!9D!3AI (OMAERUV - MERRAero)'

  loadct, 74
  plots, ai, aidiff, psym=3, color=pdiff, noclip=0
a = where(abs(aidiff) gt 0.2)
print, n_elements(aidiff), n_elements(a), float(n_elements(a))/float(n_elements(aidiff))
  labels = ['-50','0','50']
  makekey, .2, .08, .65, .05, 0, -0.035, $
           charsize=.75, align=.5, colors=findgen(254), $
           labels=labels, /noborder
  loadct, 0
  xyouts, .525, .015, /normal, 'Pressure Difference (OMAERUV - MERRAero) [hPa]', $
   charsize=.75, align=.5

  device, /close
  

end
